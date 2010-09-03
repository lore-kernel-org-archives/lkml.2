Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756278Ab0ICJG1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 05:06:27 -0400
Received: from adelie.canonical.com ([91.189.90.139]:33302 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753496Ab0ICJGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 05:06:24 -0400
Message-ID: <4C80BA81.20701@canonical.com>
Date: Fri, 03 Sep 2010 17:06:09 +0800
From: Ike Panhc <ike.pan@canonical.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100820 Thunderbird/3.1.2
MIME-Version: 1.0
To: "Mario 'BitKoenig' Holbe" <Mario.Holbe@TU-Ilmenau.DE>,
        David Woodhouse <dwmw2@infradead.org>,
        "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Thomas Renninger <trenn@suse.de>, Alan Cox <alan@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Corentin Chary <corentincj@iksaif.net>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        "Brown, Len" <len.brown@intel.com>, Matthew Garrett <mjg@redhat.com>
Subject: Re: [PATCH 0/8] [Resend] ideapad: using EC command to control rf/camera
 power
References: <1282120564-11324-1-git-send-email-ike.pan@canonical.com> <1282127719.2747.211.camel@localhost> <20100818155128.GA24363@darkside.kls.lan> <4C6CA31D.6030407@canonical.com> <20100819193146.GB32665@darkside.kls.lan> <4C6E2833.6080407@canonical.com> <20100820090824.GA23186@darkside.kls.lan> <4C7505A2.3000402@canonical.com> <20100830181954.GE31068@darkside.kls.lan> <4C7E3DE0.7030209@canonical.com> <20100901195617.GD32589@darkside.kls.lan>
In-Reply-To: <20100901195617.GD32589@darkside.kls.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mario,

I look at the DSDT again and again but unfortunately can not find anything
may cause the bluetooth device initial failed. BTEN looks like the switch
for EC to turn on/off bluetooth, BTST records the status of BTEN and BTPS
means bluetooth present. But no idea why initial failed after BTEN=1

So I fall back to your suggestion. Have a module parameter to tell module
not to register rfkill for bluetooth.

I prepare the driver and please spend some time testing. Driver is at

http://kernel.ubuntu.com/git?p=ikepanhc/ideapad-laptop.git;a=blob;f=drivers/platform/x86/ideapad-laptop.c;h=c4cf46a363f3f72d6db5339ec326d282d7e58183;hb=26a58948693b7d25960299a8025e569e68f28937

and you may use "insmod ideapad-laptop.ko no_bt_rfkill=1" for your S12.

For more information, please see the following link:

http://kernel.ubuntu.com/git?p=ikepanhc/ideapad-laptop.git;a=commit;h=26a58948693b7d25960299a8025e569e68f28937

On 09/02/2010 03:56 AM, Mario 'BitKoenig' Holbe wrote:
> On Wed, Sep 01, 2010 at 07:49:52PM +0800, Ike Panhc wrote:
>> Your log tells a lot. It tells me if the bluetooth init failed. Then we
>> have to turning off and power on again by hw switch to make it alive again.
>>
>> So, I believe we have two issue here.
>> * when rfkill unblock, sometimes bluetooth init failed.
> 
> Yes.
> 
>> * power up system after rfkill block bluetooth, sometimes the cfgbit = 0xc0000
>> Am I correct?
> 
> Not completely.
> 
> * reboot system after rfkill block bluetooth, sometimes the cfgbit = 0xc0000
> 
> I never had cfgbit = 0xc0000 when I power-cycled the system, only when I
> rebooted it.
> This is why I belive the second point has virtually the same reason as
> the first point: bluetooth device initialization fails and thus its
> detection by BIOS fails and thus ACPI returns 0xc0000 cfg.
> Hence, I belive chances are high that solving the first point does also
> solve the second.
> 
> While thinking about it... the init problems persisting a reboot could
> also mean that not the unblock operation is the real issue but the block
> operation - which probably leaves the bluetooth device in kind of a
> semi-disabled state or something like that.
> 
> 
> regards
>    Mario

