Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753139Ab0IOMkS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 08:40:18 -0400
Received: from adelie.canonical.com ([91.189.90.139]:45924 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751727Ab0IOMkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 08:40:16 -0400
Message-ID: <4C90BE9F.5050007@canonical.com>
Date: Wed, 15 Sep 2010 20:39:59 +0800
From: Ike Panhc <ike.pan@canonical.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.12) Gecko/20100826 Thunderbird/3.0.7
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
References: <20100820090824.GA23186@darkside.kls.lan> <4C7505A2.3000402@canonical.com> <20100830181954.GE31068@darkside.kls.lan> <4C7E3DE0.7030209@canonical.com> <20100901195617.GD32589@darkside.kls.lan> <4C80BA81.20701@canonical.com> <20100909181714.GA14951@darkside.kls.lan> <4C89D3C0.7040105@canonical.com> <20100910071155.GA1263@darkside.kls.lan> <4C909C57.5030107@canonical.com> <20100915114820.GA22415@darkside.kls.lan>
In-Reply-To: <20100915114820.GA22415@darkside.kls.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

This sounds even better, will modify the driver in this way - force enable
bluetooth and no setup rfkill for bluetooth when no_bt_rfkill.

> 
> 
> Mario

