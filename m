Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751592Ab1ADOCL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 09:02:11 -0500
Received: from smtp.nokia.com ([147.243.128.24]:19593 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751430Ab1ADOCJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 09:02:09 -0500
Subject: Re: [PATCH v2 1/3] ECI: input: introduce ECI accessory input driver
From: Tapio Vihuri <tapio.vihuri@nokia.com>
Reply-To: tapio.vihuri@nokia.com
To: ext Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: randy.dunlap@oracle.com, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, ilkka.koskinen@nokia.com,
        samu.p.onkalo@nokia.com
In-Reply-To: <20110102081922.GD5429@core.coreip.homeip.net>
References: <1293716219-26089-1-git-send-email-tapio.vihuri@nokia.com>
	 <1293716219-26089-2-git-send-email-tapio.vihuri@nokia.com>
	 <20110102081922.GD5429@core.coreip.homeip.net>
Content-Type: text/plain; charset="UTF-8"
Organization: Nokia Oyj
Date: Tue, 04 Jan 2011 16:01:44 +0200
Message-ID: <1294149704.2389.82.camel@dell>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-01-02 at 00:19 -0800, ext Dmitry Torokhov wrote:
> Hi Tapio,
> 

Hi Dmitry

Thank you for good comments. I sent v3 patch set right after this email.

--------8<-------

> Please keep Makefile and Kconfig sorted alphabetically.
> 

Corrected in patch set.

--------8<-------

> Consider switching to sparse keymap library. You won't be needing ugly
> KEY_MAX + SW_XXX hacks and it will also support remapping keys from
> userspace.
> 

Much nicer solution, thank you.

--------8<-------

> Do not break strings on 80 column boundaries, wither align the arguments
> differently or just go past 80 columns, like this:
> 
>                         dev_err(eci->dev,
>                                 "Unable to control headset microphone\n");
> 
Corrected in patch set.

--------8<-------


> > +#define eci_initialize_debugfs(eci)  1
> 
> Should be 0 I think, and not have a parameter, preferably
> 
> static inline int eci_initialize_debugfs(void)
> {
>         return 0;
> }
> 

I take this static inline solution, but I needed the parameter.

--------8<-------

> > +     struct eci_mem_block *ekey = (void *)buf;
> > +     int ret;
> > +
> > +     /* Read always four bytes */
> > +     ret = eci->eci_hw_ops->acc_read_direct(0, buf);
> > +
> > +     if (ret)
> > +             return ret;
> > +
> > +     if (ekey->id != ECI_EKEY_BLOCK_ID)
> > +             return -ENODEV;
> > +
> > +     *key = cpu_to_be16(ekey->size);
> 
> cpu_to_be16()??? This looks really wierd.
> 

The ECI specification says that data in ECI accessory's memory is in big
endian order. This simply get 16-bit size parameter right in any
endianes machine.

--------8<-------


> > +static ssize_t show_cable_plugged(struct device *dev,
> > +             struct device_attribute *attr, char *buf)
> > +{
> > +     struct eci_data *eci = dev_get_drvdata(dev);
> > +
> > +     return snprintf(buf, sizeof(buf), "Cable plugged %s\n",
> > +                             eci->plugged ? "in" : "out");
> 
> Should it be dsimple 0/1? How is this attribute supposed to be used?
> 
> > +static ssize_t store_cable_plugged(struct device *dev,
> > +             struct device_attribute *attr,
> > +             const char *buf, size_t len)
> > +{
--------8<-------

> Same here. Should it be in debugfs probably?
> 

I made it now as 0/1. It's in sysfs as this is user space's interface
for ECI acessories inserting.

The other way is via ALSA sound driver providing jack detection, but
it's not there yet.

--------8<-------

> > +     /*
> > +      * Configure ECI buttons now as we have after parsed
> > +      * enchancement features table
> > +      */
> 
> I do not understand this comment.
> 

I have loose some word somewhere... Now it goes:
 	/*
         * Configure ECI buttons now as we know how after
         * enchancement features table has been parsed
         */


--------8<-------


> > +     set_bit(EV_KEY, eci->acc_input->evbit);
> > +     set_bit(EV_SW, eci->acc_input->evbit);
> > +     set_bit(EV_REP, eci->acc_input->evbit);
> 
> __set_bit(), no neded to lock bus.
> 
Corrected in patch set.

--------8<-------

> > +
> > +static struct miscdevice eci_device = {
> > +     .minor = MISC_DYNAMIC_MINOR,
> > +     .name = ECI_DRIVERNAME,
> > +};
> 
> What does this device do?
> 

Nothing, and I can't even remember why I have put it there first place.
Removed now.

--------8<-------

> Thank you.
> 
> --
> Dmitry

Thank you, now driver is better.

-- 
Tapsa

