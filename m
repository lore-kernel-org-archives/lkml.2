Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754405Ab0EZTCt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 15:02:49 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:33511 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752795Ab0EZTCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 15:02:47 -0400
Date: Wed, 26 May 2010 12:02:36 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Udo van den Heuvel <udovdh@xs4all.nl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: hpet timers gone?
Message-Id: <20100526120236.4a849b5b.randy.dunlap@oracle.com>
In-Reply-To: <4BFA52C3.4080006@xs4all.nl>
References: <4BFA52C3.4080006@xs4all.nl>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090206.4BFD7057.006C:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 May 2010 12:19:47 +0200 Udo van den Heuvel wrote:

> Hello,
> 
> What has happened between 2.6.30.9 and 2.6.32.8 with regard to hpet timers?
> 
> dmesg output from 2.6.30.9 does show activity but 2.6.32.8 and beyond don't.
> Also /proc/timer_list doesn't show hpet anymore. Also on 2.6.34 no hpet
> in timer_list.
> 
> relevant .config:
> CONFIG_HPET_TIMER=y
> CONFIG_HPET_EMULATE_RTC=y
> CONFIG_HPET=y
> CONFIG_HPET_MMAP=y

Same here.

> And I have hpet=force on the kernel commandline for this VIA Epia
> LT10000 board.
> 
> Any ideas?

On x86 peecee:

$ uname -a
Linux chimera.site 2.6.34 #2 SMP Tue May 18 10:52:27 PDT 2010 x86_64 x86_64 x86_64 GNU/Linux
$ grep hpet /proc/timer_list
Clock Event Device: hpet
 set_next_event: hpet_legacy_next_event
 set_mode:       hpet_legacy_set_mode



$ dmesg | grep -i hpet
[    0.000000] ACPI: HPET 00000000cf6f3000 00038 (v01 GATEWA SYSTEM   0000017E MSFT 01000013)
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] hpet clockevent registered
[    0.000000] TSC: PIT calibration matches HPET. 1 loops
[    0.771604] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    0.771604] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.771604] hpet0: 3 comparators, 64-bit 14.318180 MHz counter


What does dmesg show on your machine?

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
