Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754486Ab0IPL7S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 07:59:18 -0400
Received: from adelie.canonical.com ([91.189.90.139]:43362 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753581Ab0IPL7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 07:59:16 -0400
Message-ID: <4C920684.7080000@canonical.com>
Date: Thu, 16 Sep 2010 19:59:00 +0800
From: Ike Panhc <ike.pan@canonical.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100903 Thunderbird/3.1.3
MIME-Version: 1.0
To: "Mario 'BitKoenig' Holbe" <Mario.Holbe@TU-Ilmenau.DE>
CC: David Woodhouse <dwmw2@infradead.org>,
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
References: <20100820090824.GA23186@darkside.kls.lan> <4C7505A2.3000402@canonical.com> <20100830181954.GE31068@darkside.kls.lan> <4C7E3DE0.7030209@canonical.com> <20100901195617.GD32589@darkside.kls.lan> <4C80BA81.20701@canonical.com> <20100909181714.GA14951@darkside.kls.lan> <4C89D3C0.7040105@canonical.com> <20100910071155.GA1263@darkside.kls.lan> <4C909C57.5030107@canonical.com> <20100915114820.GA22415@darkside.kls.lan>
In-Reply-To: <20100915114820.GA22415@darkside.kls.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mario,

I have modified the driver[1]. Please kindly have a test and see if it is ok for you.

[1] http://kernel.ubuntu.com/git?p=ikepanhc/ideapad-laptop.git;a=blob;f=drivers/platform/x86/ideapad-laptop.c;h=0e1f60bb53fd483bffb0e0f914254a589baa152a;hb=9dc37c9289c3edd2a171a6fd7872578107cf3063

--
Ike Panhc

On 09/15/2010 07:48 PM, Mario 'BitKoenig' Holbe wrote:
> On Wed, Sep 15, 2010 at 06:13:43PM +0800, Ike Panhc wrote:
>> On 09/10/2010 03:11 PM, Mario 'BitKoenig' Holbe wrote:
>>> 	rfkill_init_sw_state(priv->rfk[dev], 0);
>> eh.. after review the code, the rfkill_init_sw_state shall not give 0 as the default
>> value. I shall read the value from EC and set reasonable value.
> 
> Well - probably :)
> The current behaviour results in each device becoming unblocked no
> matter what state it had before.
> 
>>> 	if (no_bt_rfkill && (ideapad_rfk_data[dev].type == RFKILL_TYPE_BLUETOOTH))
>>> 		ideapad_rfk_set(???, 0);
>> Do you mean driver still setup the rfkill for bluetooth, but we can not block
>> bluetooth when module parameter set to 1? This idea is better then no_bt_rfkill.
>> Will modify the driver.
> 
> Well, not really... I mean: in the no_bt_rfkill=1 case the driver should
> (try to) unblock the bluetooth device in order to activate it to make it
> further manageable via it's own (hci) rfkill switch.
> I don't think setting up the ideapad_bluetooth rfkill is necessary for
> that. Not setting it up is IMHO the right direction. Just the device
> activation is missing.
> 
> 
> Mario

