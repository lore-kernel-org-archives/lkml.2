Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752733Ab0IOKN6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 06:13:58 -0400
Received: from adelie.canonical.com ([91.189.90.139]:60822 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751615Ab0IOKN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 06:13:56 -0400
Message-ID: <4C909C57.5030107@canonical.com>
Date: Wed, 15 Sep 2010 18:13:43 +0800
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
References: <20100819193146.GB32665@darkside.kls.lan> <4C6E2833.6080407@canonical.com> <20100820090824.GA23186@darkside.kls.lan> <4C7505A2.3000402@canonical.com> <20100830181954.GE31068@darkside.kls.lan> <4C7E3DE0.7030209@canonical.com> <20100901195617.GD32589@darkside.kls.lan> <4C80BA81.20701@canonical.com> <20100909181714.GA14951@darkside.kls.lan> <4C89D3C0.7040105@canonical.com> <20100910071155.GA1263@darkside.kls.lan>
In-Reply-To: <20100910071155.GA1263@darkside.kls.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/2010 03:11 PM, Mario 'BitKoenig' Holbe wrote:
> 
> ideapad_rfk_set is also called in ideapad_register_rfkill:
> 
> static int ideapad_register_rfkill(struct acpi_device *adevice, int dev)
> {
> ...
> 	if (no_bt_rfkill && (ideapad_rfk_data[dev].type == RFKILL_TYPE_BLUETOOTH))
> 		return 0;
> ...
> 	rfkill_init_sw_state(priv->rfk[dev], 0);
> }

eh.. after review the code, the rfkill_init_sw_state shall not give 0 as the default
value. I shall read the value from EC and set reasonable value.

> 
> The rfkill_init_sw_state call to unblock the device finally calls
> ideapad_rfk_set. In the no_bt_rfkill=1 case rfkill_init_sw_state isn't
> called, thus the device is not unblocked if it was blocked before.
> Hence, if I prior disabled BT in Windows, the device remains invisible.
> This is why I think a manual call to ideapad_rfk_set in the
> no_bt_rfkill=1 case would make the BT device visible.
> 
> "manual" in terms of:
> 	if (no_bt_rfkill && (ideapad_rfk_data[dev].type == RFKILL_TYPE_BLUETOOTH))
> 	{
> 		ideapad_rfk_set(???, 0);
> 		return 0;
> 	}
> 
> But I don't know what to provide as "???".

Do you mean driver still setup the rfkill for bluetooth, but we can not block
bluetooth when module parameter set to 1? This idea is better then no_bt_rfkill.
Will modify the driver.

