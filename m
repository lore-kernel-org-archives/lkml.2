Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754720Ab1LIUge (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 15:36:34 -0500
Received: from claw.goop.org ([74.207.240.146]:35423 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750954Ab1LIUgd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 15:36:33 -0500
Message-ID: <4EE27147.4030001@goop.org>
Date: Fri, 09 Dec 2011 12:36:23 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Daniel Nicoletti <dantti12@gmail.com>
CC: Anton Vorontsov <cbouatmailru@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Richard Hughes <hughsient@gmail.com>, linux-input@vger.kernel.org,
        Jiri Kosina <jkosina@suse.cz>, vojtech@ucw.cz,
        Przemo Firszt <przemo@firszt.eu>, Richard Hughes <richard@hughsie.com>
Subject: Re: [GIT PULL] power_supply: add power supply scope
References: <CACo8zOd45i3EnCVMyJoDPP4bx2AnD9mEjDiC=bJKvmX=TWfXGg@mail.gmail.com> <4ED90E6D.8090402@goop.org> <CACo8zOcvKwr0wDkytvJfqyx4kV0ceYyCt+qnDqiSgxNywpzeHg@mail.gmail.com> <4ED9BDF8.3010600@goop.org> <CAD2FfiE-rg-1bMmVpYzBhnQcBMKKKO4WPnu0bvx+pvdFnpARrQ@mail.gmail.com> <4EDE4C7A.1010802@goop.org> <CAD2FfiHWuEmVTa54YqfJDk5zHpSQuM_nwPT=mR6NoWpajpydpg@mail.gmail.com> <4EDFA192.7000602@goop.org> <CAD2FfiF+fVoLPWpPyGGKdnoGhx1f=Loh2Ju-vdU58Y=2kf6C3g@mail.gmail.com> <4EE015D1.5070005@goop.org> <20111209101700.GA20100@oksana.dev.rtsoft.ru> <4EE24A3A.7030304@goop.org> <CACo8zOfek64X8ouGgUz6JSiQDz62OFkUJyQDSj=YdMsq8hjwoQ@mail.gmail.com>
In-Reply-To: <CACo8zOfek64X8ouGgUz6JSiQDz62OFkUJyQDSj=YdMsq8hjwoQ@mail.gmail.com>
X-Enigmail-Version: 1.3.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/2011 12:00 PM, Daniel Nicoletti wrote:
>>>> diff --git a/drivers/power/power_supply_sysfs.c b/drivers/power/power_supply_sysfs.c
>>>> index e15d4c9..21178eb 100644
>>>> --- a/drivers/power/power_supply_sysfs.c
>>>> +++ b/drivers/power/power_supply_sysfs.c
>>>> @@ -63,6 +63,9 @@ static ssize_t power_supply_show_property(struct device *dev,
>>>>      static char *capacity_level_text[] = {
>>>>              "Unknown", "Critical", "Low", "Normal", "High", "Full"
>>>>      };
>>>> +    static char *scope_text[] = {
>>>> +            "Unknown", "System", "Device"
>>>> +    };
>>>>      ssize_t ret = 0;
>>>>      struct power_supply *psy = dev_get_drvdata(dev);
>>>>      const ptrdiff_t off = attr - power_supply_attrs;
>>>> @@ -95,6 +98,8 @@ static ssize_t power_supply_show_property(struct device *dev,
>>>>              return sprintf(buf, "%s\n", capacity_level_text[value.intval]);
>>>>      else if (off == POWER_SUPPLY_PROP_TYPE)
>>>>              return sprintf(buf, "%s\n", type_text[value.intval]);
>>>> +    else if (off == POWER_SUPPLY_PROP_SCOPE)
>>>> +            return sprintf(buf, "%s\n", scope_text[value.intval]);
>>> Should we really handle the PROP_SCOPE as a dynamic property?
>>> Maybe do it similar to PROP_TYPE, so that drivers will only need to
>>> specity the scope during registration, and not bother w/ handling
>>> it in theirs get_property() callbacks?
>> I don't really know.  I guess its possible in theory that a device could
>> change scope on the fly if its power was re-routed.  But then, the type
>> can change too (if, for example, a UPS switched between AC and battery
>> power, or a HID device switching between corded USB power or cordless
>> battery power), so I'm not really sure what the rationale is either
>> way.  (I guess you model power supplies switching type as having
>> multiple power supplies which turn themselves on and offline?)
> But isn't the scope about powering or not the system? If so even if
> the device is now using AC it will not be powering the computer.
>

Sure.  I was just commenting on the similarity between scope and type
with respect to whether they're immutable properties of a power supply
or things that can change over time.

    J
