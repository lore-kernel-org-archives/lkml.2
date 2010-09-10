Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751573Ab0IJGo3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 02:44:29 -0400
Received: from adelie.canonical.com ([91.189.90.139]:43549 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956Ab0IJGo1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 02:44:27 -0400
Message-ID: <4C89D3C0.7040105@canonical.com>
Date: Fri, 10 Sep 2010 14:44:16 +0800
From: Ike Panhc <ike.pan@canonical.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100903 Thunderbird/3.1.3
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
References: <20100818155128.GA24363@darkside.kls.lan> <4C6CA31D.6030407@canonical.com> <20100819193146.GB32665@darkside.kls.lan> <4C6E2833.6080407@canonical.com> <20100820090824.GA23186@darkside.kls.lan> <4C7505A2.3000402@canonical.com> <20100830181954.GE31068@darkside.kls.lan> <4C7E3DE0.7030209@canonical.com> <20100901195617.GD32589@darkside.kls.lan> <4C80BA81.20701@canonical.com> <20100909181714.GA14951@darkside.kls.lan>
In-Reply-To: <20100909181714.GA14951@darkside.kls.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/2010 02:17 AM, Mario 'BitKoenig' Holbe wrote:
> On Fri, Sep 03, 2010 at 05:06:09PM +0800, Ike Panhc wrote:
>> I look at the DSDT again and again but unfortunately can not find anything
>> may cause the bluetooth device initial failed. BTEN looks like the switch
>> for EC to turn on/off bluetooth, BTST records the status of BTEN and BTPS
>> means bluetooth present. But no idea why initial failed after BTEN=1
> 
> Is there some way to trace ACPI calls under Windows (XP Home)?
> I could then have a look at what happens when I Fn-F5 BT off.
> 

I heard that we can install the driver in virtual machine for study its behavior.
But dont know the detail - it means we need to have a pseudo device there.

Sorry, I do not know much about Windows.

>> So I fall back to your suggestion. Have a module parameter to tell module
>> not to register rfkill for bluetooth.
>> I prepare the driver and please spend some time testing. Driver is at
>> http://kernel.ubuntu.com/git?p=ikepanhc/ideapad-laptop.git;a=blob;f=drivers/platform/x86/ideapad-laptop.c;h=c4cf46a363f3f72d6db5339ec326d282d7e58183;hb=26a58948693b7d25960299a8025e569e68f28937
>> and you may use "insmod ideapad-laptop.ko no_bt_rfkill=1" for your S12.
> 
> Hmmm, with this version and no_bt_rfkill=1 I run into the same problem
> as without the ideapad module: If I switch BT off in Windows and reboot
> to Linux, the device remains invisible and I have no chance to switch it
> back on again :/

The no_bt_rfkill is a stopgap for dual OS user. when BT is default on, user
still have the BT sw rfkill registered as hci0. when BT is defualt off, user
can re-insert module with no_bt_rfkill=0.

> I guess this is because the initial device activation does currently
> only happen in ideapad_register_rfkill() via rfkill_init_sw_state()
> which is not called if no_bt_rfkill=1.
> A manual call to ideapad_rfk_set() (or ideapad_sync_rfk_state()?) in the
> no_bt_rfkill=1 case would very likely solve this, but I don't know how
> to provide this call with the correct arguments.

Sorry I do not get the point of a manual call. Could you explain more on this?

ideapad_rfk_set is called when user update /sys/class/rfkill/rfkill?/state and
ideapad_sync_rfk_state is called when user touch the hw rfkill switch.

> 
> 
> regards
>    Mario

