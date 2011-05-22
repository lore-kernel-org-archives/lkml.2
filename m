Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755008Ab1EVNBl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 May 2011 09:01:41 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:55774 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754896Ab1EVNBe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 May 2011 09:01:34 -0400
X-Authenticated: #12510340
X-Provags-ID: V01U2FsdGVkX18yamIHRjcyDtO3dOfwQXZe9uq1nXTZoJ7ksEZWe9
	jkoG8lDJpgKaBr
Message-ID: <4DD9092A.4080507@gmx.net>
Date: Sun, 22 May 2011 15:01:30 +0200
From: Olaf Freyer <aaron667@gmx.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110430 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Erroneous package power limit notification since kernel 2.6.39
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

since using kernel-2.6.39 I recieve those reports right after rebooting
my system when it's still "warm".
(Sensors reporting about 50°C. I don't see those on a cold boot early in
the morning.)
I don't get any such reports with 2.6.38.7 or any earlier kernel I used
before.

May 22 14:41:34 localhost kernel: [   57.525844] CPU4: Package power
limit notification (total events = 1)
May 22 14:41:34 localhost kernel: [   57.525848] CPU0: Package power
limit notification (total events = 1)
May 22 14:41:34 localhost kernel: [   57.525851] CPU1: Package power
limit notification (total events = 1)
May 22 14:41:34 localhost kernel: [   57.525854] CPU2: Package power
limit notification (total events = 1)
May 22 14:41:34 localhost kernel: [   57.525856] CPU5: Package power
limit notification (total events = 1)
May 22 14:41:34 localhost kernel: [   57.525859] CPU3: Package power
limit notification (total events = 1)
May 22 14:41:34 localhost kernel: [   57.525861] Disabling lock
debugging due to kernel taint
May 22 14:41:34 localhost kernel: [   57.525869] CPU6: Package power
limit notification (total events = 1)
May 22 14:41:34 localhost kernel: [   57.525872] CPU7: Package power
limit notification (total events = 1)
May 22 14:41:34 localhost kernel: [   57.536890] CPU1: Package power
limit normal
May 22 14:41:34 localhost kernel: [   57.536893] CPU4: Package power
limit normal
May 22 14:41:34 localhost kernel: [   57.536896] CPU2: Package power
limit normal
May 22 14:41:34 localhost kernel: [   57.536899] CPU3: Package power
limit normal
May 22 14:41:34 localhost kernel: [   57.536901] CPU5: Package power
limit normal
May 22 14:41:34 localhost kernel: [   57.536904] CPU0: Package power
limit normal
May 22 14:41:34 localhost kernel: [   57.536915] CPU6: Package power
limit normal
May 22 14:41:34 localhost kernel: [   57.536918] CPU7: Package power
limit normal

On executing "mcelog --syslog" I recieve those reports in /var/log/messages

May 22 14:41:55 localhost mcelog: Unsupported new Family 6 Model 2a CPU:
only decoding architectural errors
May 22 14:41:55 localhost mcelog: HARDWARE ERROR. This is *NOT* a
software problem!
May 22 14:41:55 localhost mcelog: Please contact your hardware vendor
May 22 14:41:55 localhost mcelog: MCE 0
May 22 14:41:55 localhost mcelog: CPU 1 THERMAL EVENT TSC 263055cdd1
May 22 14:41:55 localhost mcelog: TIME 1306068115 Sun May 22 14:41:55 2011
May 22 14:41:55 localhost mcelog: Processor 1 below trip temperature.
Throttling disabled
May 22 14:41:55 localhost mcelog: STATUS c000000088260c00 MCGSTATUS 0
May 22 14:41:55 localhost mcelog: MCGCAP c09 APICID 1 SOCKETID 0
May 22 14:41:55 localhost mcelog: CPUID Vendor Intel Family 6 Model 42
May 22 14:41:55 localhost mcelog: Unsupported new Family 6 Model 2a CPU:
only decoding architectural errors
May 22 14:41:55 localhost mcelog: HARDWARE ERROR. This is *NOT* a
software problem!
May 22 14:41:55 localhost mcelog: Please contact your hardware vendor
May 22 14:41:55 localhost mcelog: MCE 1
May 22 14:41:55 localhost mcelog: CPU 2 THERMAL EVENT TSC 263055e95d
May 22 14:41:55 localhost mcelog: TIME 1306068115 Sun May 22 14:41:55 2011
May 22 14:41:55 localhost mcelog: Processor 2 below trip temperature.
Throttling disabled
May 22 14:41:55 localhost mcelog: STATUS c000000088260c00 MCGSTATUS 0
May 22 14:41:55 localhost mcelog: MCGCAP c09 APICID 2 SOCKETID 0
May 22 14:41:55 localhost mcelog: CPUID Vendor Intel Family 6 Model 42
May 22 14:41:55 localhost mcelog: Unsupported new Family 6 Model 2a CPU:
only decoding architectural errors
May 22 14:41:55 localhost mcelog: HARDWARE ERROR. This is *NOT* a
software problem!
May 22 14:41:55 localhost mcelog: Please contact your hardware vendor
May 22 14:41:55 localhost mcelog: MCE 2
May 22 14:41:55 localhost mcelog: CPU 5 THERMAL EVENT TSC 263055fe7b
May 22 14:41:55 localhost mcelog: TIME 1306068115 Sun May 22 14:41:55 2011
May 22 14:41:55 localhost mcelog: Processor 5 below trip temperature.
Throttling disabled
May 22 14:41:55 localhost mcelog: STATUS c000000088260c00 MCGSTATUS 0
May 22 14:41:55 localhost mcelog: MCGCAP c09 APICID 5 SOCKETID 0
May 22 14:41:55 localhost mcelog: CPUID Vendor Intel Family 6 Model 42
May 22 14:41:55 localhost mcelog: Unsupported new Family 6 Model 2a CPU:
only decoding architectural errors
May 22 14:41:55 localhost mcelog: HARDWARE ERROR. This is *NOT* a
software problem!
May 22 14:41:55 localhost mcelog: Please contact your hardware vendor
May 22 14:41:55 localhost mcelog: MCE 3
May 22 14:41:55 localhost mcelog: CPU 3 THERMAL EVENT TSC 2630561550
May 22 14:41:55 localhost mcelog: TIME 1306068115 Sun May 22 14:41:55 2011
May 22 14:41:55 localhost mcelog: Processor 3 below trip temperature.
Throttling disabled
May 22 14:41:55 localhost mcelog: STATUS c000000088260c00 MCGSTATUS 0
May 22 14:41:55 localhost mcelog: MCGCAP c09 APICID 3 SOCKETID 0
May 22 14:41:55 localhost mcelog: CPUID Vendor Intel Family 6 Model 42
May 22 14:41:55 localhost mcelog: Unsupported new Family 6 Model 2a CPU:
only decoding architectural errors
May 22 14:41:55 localhost mcelog: HARDWARE ERROR. This is *NOT* a
software problem!
May 22 14:41:55 localhost mcelog: Please contact your hardware vendor
May 22 14:41:55 localhost mcelog: MCE 4
May 22 14:41:55 localhost mcelog: CPU 0 THERMAL EVENT TSC 26305627e1
May 22 14:41:55 localhost mcelog: TIME 1306068115 Sun May 22 14:41:55 2011
May 22 14:41:55 localhost mcelog: Processor 0 below trip temperature.
Throttling disabled
May 22 14:41:55 localhost mcelog: STATUS c000000088260c00 MCGSTATUS 0
May 22 14:41:55 localhost mcelog: MCGCAP c09 APICID 0 SOCKETID 0
May 22 14:41:55 localhost mcelog: CPUID Vendor Intel Family 6 Model 42
May 22 14:41:55 localhost mcelog: Unsupported new Family 6 Model 2a CPU:
only decoding architectural errors
May 22 14:41:55 localhost mcelog: HARDWARE ERROR. This is *NOT* a
software problem!
May 22 14:41:55 localhost mcelog: Please contact your hardware vendor
May 22 14:41:55 localhost mcelog: MCE 5
May 22 14:41:55 localhost mcelog: CPU 4 THERMAL EVENT TSC 2630562c03
May 22 14:41:55 localhost mcelog: TIME 1306068115 Sun May 22 14:41:55 2011
May 22 14:41:55 localhost mcelog: Processor 4 below trip temperature.
Throttling disabled
May 22 14:41:55 localhost mcelog: STATUS c000000088260c00 MCGSTATUS 0
May 22 14:41:55 localhost mcelog: MCGCAP c09 APICID 4 SOCKETID 0
May 22 14:41:55 localhost mcelog: CPUID Vendor Intel Family 6 Model 42
May 22 14:41:55 localhost mcelog: Unsupported new Family 6 Model 2a CPU:
only decoding architectural errors
May 22 14:41:55 localhost mcelog: HARDWARE ERROR. This is *NOT* a
software problem!
May 22 14:41:55 localhost mcelog: Please contact your hardware vendor
May 22 14:41:55 localhost mcelog: MCE 6
May 22 14:41:55 localhost mcelog: CPU 7 THERMAL EVENT TSC 2630568665
May 22 14:41:55 localhost mcelog: TIME 1306068115 Sun May 22 14:41:55 2011
May 22 14:41:55 localhost mcelog: Processor 7 below trip temperature.
Throttling disabled
May 22 14:41:55 localhost mcelog: STATUS c000000088260c00 MCGSTATUS 0
May 22 14:41:55 localhost mcelog: MCGCAP c09 APICID 7 SOCKETID 0
May 22 14:41:55 localhost mcelog: CPUID Vendor Intel Family 6 Model 42
May 22 14:41:55 localhost mcelog: Unsupported new Family 6 Model 2a CPU:
only decoding architectural errors
May 22 14:41:55 localhost mcelog: HARDWARE ERROR. This is *NOT* a
software problem!
May 22 14:41:55 localhost mcelog: Please contact your hardware vendor
May 22 14:41:55 localhost mcelog: MCE 7
May 22 14:41:55 localhost mcelog: CPU 6 THERMAL EVENT TSC 2630568af6
May 22 14:41:55 localhost mcelog: TIME 1306068115 Sun May 22 14:41:55 2011
May 22 14:41:55 localhost mcelog: Processor 6 below trip temperature.
Throttling disabled
May 22 14:41:55 localhost mcelog: STATUS c000000088260c00 MCGSTATUS 0
May 22 14:41:55 localhost mcelog: MCGCAP c09 APICID 6 SOCKETID 0
May 22 14:41:55 localhost mcelog: CPUID Vendor Intel Family 6 Model 42
May 22 14:41:55 localhost mcelog: Unsupported new Family 6 Model 2a CPU:
only decoding architectural errors
May 22 14:41:55 localhost mcelog: HARDWARE ERROR. This is *NOT* a
software problem!
May 22 14:41:55 localhost mcelog: Please contact your hardware vendor
May 22 14:41:55 localhost mcelog: MCE 8
May 22 14:41:55 localhost mcelog: CPU 4 THERMAL EVENT TSC 2631c812ca
May 22 14:41:55 localhost mcelog: TIME 1306068115 Sun May 22 14:41:55 2011
May 22 14:41:55 localhost mcelog: Processor 4 below trip temperature.
Throttling disabled
May 22 14:41:55 localhost mcelog: STATUS c000000088260800 MCGSTATUS 0
May 22 14:41:55 localhost mcelog: MCGCAP c09 APICID 4 SOCKETID 0
May 22 14:41:55 localhost mcelog: CPUID Vendor Intel Family 6 Model 42
May 22 14:41:55 localhost mcelog: Unsupported new Family 6 Model 2a CPU:
only decoding architectural errors
May 22 14:41:55 localhost mcelog: HARDWARE ERROR. This is *NOT* a
software problem!
May 22 14:41:55 localhost mcelog: Please contact your hardware vendor
May 22 14:41:55 localhost mcelog: MCE 9
May 22 14:41:55 localhost mcelog: CPU 2 THERMAL EVENT TSC 2631c82b05
May 22 14:41:55 localhost mcelog: TIME 1306068115 Sun May 22 14:41:55 2011
May 22 14:41:55 localhost mcelog: Processor 2 below trip temperature.
Throttling disabled
May 22 14:41:55 localhost mcelog: STATUS c000000088260800 MCGSTATUS 0
May 22 14:41:55 localhost mcelog: MCGCAP c09 APICID 2 SOCKETID 0
May 22 14:41:55 localhost mcelog: CPUID Vendor Intel Family 6 Model 42
May 22 14:41:55 localhost mcelog: Unsupported new Family 6 Model 2a CPU:
only decoding architectural errors
May 22 14:41:55 localhost mcelog: HARDWARE ERROR. This is *NOT* a
software problem!
May 22 14:41:55 localhost mcelog: Please contact your hardware vendor
May 22 14:41:55 localhost mcelog: MCE 10
May 22 14:41:55 localhost mcelog: CPU 3 THERMAL EVENT TSC 2631c83eb2
May 22 14:41:55 localhost mcelog: TIME 1306068115 Sun May 22 14:41:55 2011
May 22 14:41:55 localhost mcelog: Processor 3 below trip temperature.
Throttling disabled
May 22 14:41:55 localhost mcelog: STATUS c000000088260800 MCGSTATUS 0
May 22 14:41:55 localhost mcelog: MCGCAP c09 APICID 3 SOCKETID 0
May 22 14:41:55 localhost mcelog: CPUID Vendor Intel Family 6 Model 42
May 22 14:41:55 localhost mcelog: Unsupported new Family 6 Model 2a CPU:
only decoding architectural errors
May 22 14:41:55 localhost mcelog: HARDWARE ERROR. This is *NOT* a
software problem!
May 22 14:41:55 localhost mcelog: Please contact your hardware vendor
May 22 14:41:55 localhost mcelog: MCE 11
May 22 14:41:55 localhost mcelog: CPU 5 THERMAL EVENT TSC 2631c852d5
May 22 14:41:55 localhost mcelog: TIME 1306068115 Sun May 22 14:41:55 2011
May 22 14:41:55 localhost mcelog: Processor 5 below trip temperature.
Throttling disabled
May 22 14:41:55 localhost mcelog: STATUS c000000088260800 MCGSTATUS 0
May 22 14:41:55 localhost mcelog: MCGCAP c09 APICID 5 SOCKETID 0
May 22 14:41:55 localhost mcelog: CPUID Vendor Intel Family 6 Model 42
May 22 14:41:55 localhost mcelog: Unsupported new Family 6 Model 2a CPU:
only decoding architectural errors
May 22 14:41:55 localhost mcelog: HARDWARE ERROR. This is *NOT* a
software problem!
May 22 14:41:55 localhost mcelog: Please contact your hardware vendor
May 22 14:41:55 localhost mcelog: MCE 12
May 22 14:41:55 localhost mcelog: CPU 0 THERMAL EVENT TSC 2631c8668e
May 22 14:41:55 localhost mcelog: TIME 1306068115 Sun May 22 14:41:55 2011
May 22 14:41:55 localhost mcelog: Processor 0 below trip temperature.
Throttling disabled
May 22 14:41:55 localhost mcelog: STATUS c000000088260800 MCGSTATUS 0
May 22 14:41:55 localhost mcelog: MCGCAP c09 APICID 0 SOCKETID 0
May 22 14:41:55 localhost mcelog: CPUID Vendor Intel Family 6 Model 42
May 22 14:41:55 localhost mcelog: Unsupported new Family 6 Model 2a CPU:
only decoding architectural errors
May 22 14:41:55 localhost mcelog: HARDWARE ERROR. This is *NOT* a
software problem!
May 22 14:41:55 localhost mcelog: Please contact your hardware vendor
May 22 14:41:55 localhost mcelog: MCE 13
May 22 14:41:55 localhost mcelog: CPU 1 THERMAL EVENT TSC 2631c86895
May 22 14:41:55 localhost mcelog: TIME 1306068115 Sun May 22 14:41:55 2011
May 22 14:41:55 localhost mcelog: Processor 1 below trip temperature.
Throttling disabled
May 22 14:41:55 localhost mcelog: STATUS c000000088260800 MCGSTATUS 0
May 22 14:41:55 localhost mcelog: MCGCAP c09 APICID 1 SOCKETID 0
May 22 14:41:55 localhost mcelog: CPUID Vendor Intel Family 6 Model 42
May 22 14:41:55 localhost mcelog: Unsupported new Family 6 Model 2a CPU:
only decoding architectural errors
May 22 14:41:55 localhost mcelog: HARDWARE ERROR. This is *NOT* a
software problem!
May 22 14:41:55 localhost mcelog: Please contact your hardware vendor
May 22 14:41:55 localhost mcelog: MCE 14
May 22 14:41:55 localhost mcelog: CPU 7 THERMAL EVENT TSC 2631c8df4e
May 22 14:41:55 localhost mcelog: TIME 1306068115 Sun May 22 14:41:55 2011
May 22 14:41:55 localhost mcelog: Processor 7 below trip temperature.
Throttling disabled
May 22 14:41:55 localhost mcelog: STATUS c000000088260800 MCGSTATUS 0
May 22 14:41:55 localhost mcelog: MCGCAP c09 APICID 7 SOCKETID 0
May 22 14:41:55 localhost mcelog: CPUID Vendor Intel Family 6 Model 42
May 22 14:41:55 localhost mcelog: Unsupported new Family 6 Model 2a CPU:
only decoding architectural errors
May 22 14:41:55 localhost mcelog: HARDWARE ERROR. This is *NOT* a
software problem!
May 22 14:41:55 localhost mcelog: Please contact your hardware vendor
May 22 14:41:55 localhost mcelog: MCE 15
May 22 14:41:55 localhost mcelog: CPU 6 THERMAL EVENT TSC 2631c8e40f
May 22 14:41:55 localhost mcelog: TIME 1306068115 Sun May 22 14:41:55 2011
May 22 14:41:55 localhost mcelog: Processor 6 below trip temperature.
Throttling disabled
May 22 14:41:55 localhost mcelog: STATUS c000000088260800 MCGSTATUS 0
May 22 14:41:55 localhost mcelog: MCGCAP c09 APICID 6 SOCKETID 0
May 22 14:41:55 localhost mcelog: CPUID Vendor Intel Family 6 Model 42

I haven't dealt with any kernel issues before, so I'm somewhat lost what
to do next.
If there is anything I can do to track down the cause or any additional
information I need to provide,
just tell me what to.

Best regards,
Olaf Freyer


