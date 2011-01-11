Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755224Ab1AKBnp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 20:43:45 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:17546 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753410Ab1AKBnh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 20:43:37 -0500
Message-ID: <4D2BB555.7000604@kernel.org>
Date: Mon, 10 Jan 2011 17:41:41 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>, Thomas Gleixner <tglx@linutronix.de>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        linux-usb@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -v3 4/4] x86: usb handoff in early_quirk
References: <4D2A1382.7010407@kernel.org> <4D2AC6BF.3010907@kernel.org> <4D2BA8FE.9090204@kernel.org> <4D2BAA85.9060902@kernel.org> <20110111010827.GD32585@kroah.com>
In-Reply-To: <20110111010827.GD32585@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/10/2011 05:08 PM, Greg KH wrote:
> On Mon, Jan 10, 2011 at 04:55:33PM -0800, Yinghai Lu wrote:
>>
>> some systems keep getting
>>   APIC calibration not consistent with PM-Timer: 139ms instead of 100ms
>>   APIC delta adjusted to PM-Timer: 831249 (1163736)
>>
>> USB legacy SMI handler is not disabled at that time.
>>
>> Try to disable USB legacy support early with this patch.
>> So later APIC Timer calibration don't get messed up by USB legacy support SMI handler.
>> After this patch, that warning never show up for 100 reboot tests.
> 
> So all of this work was for one warning that really doesn't mean much,
> if anything?  That seems very pointless, wouldn't you agree?
> 
> Wouldn't it be nicer if the BIOS fixed the SMI code to not have such
> problems?

find detail info that calibration code from Thomas
http://lkml.indiana.edu/hypermail/linux/kernel/0703.2/0420.html

Thomas said:
The wrong calibration values are probably caused by SMM code trying to
emulate a PS/2 keyboard from a (maybe connected or not) USB keyboard.
This prohibits the accurate delivery of PIT interrupts, which are used
to calibrate the local APIC timer. Unfortunately we have no way to
disable this BIOS misfeature in the early boot process.
---

We could disable it early with x86 early_quirks.

Thanks

Yinghai
