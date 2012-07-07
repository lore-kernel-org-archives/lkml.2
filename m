Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751709Ab2GGPM3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2012 11:12:29 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:54617 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751640Ab2GGPM1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2012 11:12:27 -0400
From: "Justin Piszcz" <jpiszcz@lucidpixels.com>
To: <pool@lists.ntp.org>, <linux-kernel@vger.kernel.org>
Subject: X9SCM-F-O clock drift +1 second into the future when ntp running?
Date: Sat, 7 Jul 2012 11:12:25 -0400
Message-ID: <015e01cd5c52$eb27a510$c176ef30$@lucidpixels.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: Ac1cUngH2QsLovkmS5SiVdLHo/oTSg==
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I migrated from an X7SPA to an X9SCM-F-O and now gpsd/ntp no longer sync
with my GPS unit:
http://www.amazon.com/GlobalSat-BU-353-USB-GPS-Receiver/dp/B000PKX2KA

I did some digging and it looks like the system clock on this motherboard
with the latest BIOS (2.00a) runs 1 second too fast when comparing to other
NTP-synchronized machines.

When comparing the clock on this vs. an atomic clock, the system clock is ~1
second faster, which is probably why the GPS has problems syncing.

Is this a faulty motherboard clock or is this an issue with Ivy Bridge (I am
using an E3-1200 V2 CPU) with the X9SCM-F-O and BIOS 2.00a?

DMI Info:

Handle 0x0000, DMI type 0, 24 bytes
BIOS Information
        Vendor: American Megatrends Inc.
        Version: 2.0a
        Release Date: 06/08/2012
        Address: 0xF0000
        Runtime Size: 64 kB
        ROM Size: 8192 kB

NTP problem:

Problem, the x127 for the GPS:

$ ntpq -pn
     remote           refid      st t when poll reach   delay   offset
jitter
============================================================================
==
x127.127.28.0    .GPS.            0 l   11   16  377    0.000    0.363
100.414
*204.235.61.9    128.174.38.133   2 u   48   64   37   48.716  -985.27
326.767
+184.105.192.247 216.218.254.202  2 u   43   64   37   90.902  -987.55
332.766
+50.7.247.114    85.114.26.194    2 u   42   64   37  158.445  -985.19
330.627
+69.65.40.29     209.51.161.238   2 u   43   64   37   47.733  -984.50
329.232

Any idea why it consistently has a ~1 second offset?
Is there a good way to fix this?

Before, on the X7SPA I ran gpsd+ntp for years without any issues, it
synchronized perfectly.  Is this a BIOS issue?  Kernel problem or HW issue?

$ cat /sys/devices/system/clocksource/clocksource0/current_clocksource
tsc

Full output:

# adjtimex -p            
         mode: 0
       offset: 0
    frequency: 1523449
     maxerror: 16000000
     esterror: 16000000
       status: 8257
time_constant: 3
    precision: 1
    tolerance: 32768000
         tick: 10015
     raw time:  1341673069s 873569969us = 1341673069.873569969
return value = 5

After 5-10 minutes without ntpd running, the clock had drifted -2.27 seconds
the other direction..

# ntpdate time.nist.gov
 7 Jul 11:03:32 ntpdate[374]: step time server 128.138.140.44 offset
-2.273077 sec

Justin.

