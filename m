Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754386Ab2IYJmg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 05:42:36 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:64331 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753499Ab2IYJmf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 05:42:35 -0400
MIME-Version: 1.0
In-Reply-To: <20120918143635.GF15432@kroah.com>
References: <5057C55D.2060402@dd-wrt.com>
	<5057C5AD.80609@dd-wrt.com>
	<20120918143635.GF15432@kroah.com>
Date: Tue, 25 Sep 2012 15:12:33 +0530
Message-ID: <CAFp+6iEVbZ0F28n60yJevcno9DizETY3_undxYkVbmJ9bPz0_w@mail.gmail.com>
Subject: Re: XHCI Bug discovered in 3.6-RC6 (solution included)
From: Vivek Gautam <gautamvivek1987@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: "Sebastian Gottschall (DD-WRT)" <s.gottschall@dd-wrt.com>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I have posted the required patch for this:
usb: host: xhci: Fix Null pointer dereferencing with 71c731a for non-x86 systems

Can we please get that in ?

On Tue, Sep 18, 2012 at 8:06 PM, Greg KH <greg@kroah.com> wrote:
> On Tue, Sep 18, 2012 at 02:51:57AM +0200, Sebastian Gottschall (DD-WRT) wrote:
>> this following function is missing a important NULL check. if DMI is
>> not available or not enabled in the kernel config (which is common
>> in my case, since its a ARM Platform with XHCI support)
>> the xhci-hcd driver will crash due nullpointer access since
>> dmi_get_system_info returns always NULL if DMI support is not
>> enabled.
>>
>> static bool compliance_mode_recovery_timer_quirk_check(void)
>> {
>>     const char *dmi_product_name, *dmi_sys_vendor;
>>
>>     dmi_product_name = dmi_get_system_info(DMI_PRODUCT_NAME);
>>     dmi_sys_vendor = dmi_get_system_info(DMI_SYS_VENDOR);
>>
>>     if (!(strstr(dmi_sys_vendor, "Hewlett-Packard")))
>>         return false;
>>
>>     if (strstr(dmi_product_name, "Z420") ||
>>             strstr(dmi_product_name, "Z620") ||
>>             strstr(dmi_product_name, "Z820"))
>>         return true;
>>
>>     return false;
>> }
>>
>> proposed patch: simply add
>>
>>  if (!dmi_sys_vendor || !dmi_product_name)
>>         return false;
>>
>> even better. disable the whole quirk handling for this case if
>> CONFIG_DMI is not set
>
> Care to send a patch to fix this up?
>
> thanks,
>
> greg k-h
> --
> To unsubscribe from this list: send the line "unsubscribe linux-usb" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Thanks
vivek
