Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755900Ab1KPQvA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 11:51:00 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:44879 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753612Ab1KPQu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 11:50:58 -0500
Date: Wed, 16 Nov 2011 08:50:43 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: anish kumar <anish198519851985@gmail.com>
Cc: oskar.andero@sonyericsson.com,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jic23@cam.ac.uk" <jic23@cam.ac.uk>,
        "aghayal@codeaurora.org" <aghayal@codeaurora.org>,
        "Cavin, Courtney" <Courtney.Cavin@sonyericsson.com>
Subject: Re: [PATCH v2] input: add driver support for Sharp gp2ap002a00f
 proximity sensor
Message-ID: <20111116165043.GB19305@core.coreip.homeip.net>
References: <1321285158-7123-1-git-send-email-oskar.andero@sonyericsson.com>
 <20111114170352.GA12659@core.coreip.homeip.net>
 <20111115073400.GD9307@caracas.corpusers.net>
 <1321457952.1790.16.camel@anish-Inspiron-N5050>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1321457952.1790.16.camel@anish-Inspiron-N5050>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 17, 2011 at 12:39:12AM +0900, anish kumar wrote:
> On Tue, 2011-11-15 at 08:34 +0100, oskar.andero@sonyericsson.com wrote:
> > > > +#ifdef CONFIG_PM_SLEEP
> > > > +static int gp2a_suspend(struct device *dev)
> > > > +{
> > > > +	struct i2c_client *client = to_i2c_client(dev);
> > > > +	struct gp2a_data *dt = i2c_get_clientdata(client);
> > > > +	int error;
> > > > +
> > > > +	if (device_may_wakeup(&client->dev)) {
> > > > +		enable_irq_wake(client->irq);
> > > > +	} else {
> > > 
> > > This needs locking WRT open/close. Please acquire dt->device->mutex and
> > > only disable if dt->device->users != 0. Similar shoudl be done for
> > > resume.
> > 
> > I see what you mean. I will fix it. 
> Is my understanding correct?You are going to disable the device 
> only when there are users of the driver and not disable the device
> otherwise.As anyway if there are no users the driver would have been
> already disabled right?

Right, if there are no usrs device should already be in low power mode
and we do not need anything to do here. Additionally, if device has no
users we do not wantt o power it on in esume() as this will only cause
us to waste power.

Thanks.

-- 
Dmitry
