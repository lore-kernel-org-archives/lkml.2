Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753477Ab0GAFAu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 01:00:50 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:43588 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752097Ab0GAFAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 01:00:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=WJXgvr2ZWzj1livscfNR+wz4zwCG39OqgHGc0YVxg77chIqpgipZUe5pw6hO1SkAZM
         jqGoI4d6kb2NfU5VbxFZn8JRB7JxYIwPoAhgEqx7V7oNj7LluogqGX2kvZc/gADWFNX4
         BkjIk4Fv5SqMZoTYOlC0511NttL1MIcxLpr5w=
MIME-Version: 1.0
Date: Thu, 1 Jul 2010 07:00:45 +0200
Message-ID: <AANLkTilvxV18Qc2-34GtNmfAIvNL2dtEAPC3iPFNU2Pv@mail.gmail.com>
Subject: i8042 no mouse on resume. (i8042: failed to resume active 
	multiplexor, mouse won't work.)
From: Jerome Lacoste <jerome.lacoste@gmail.com>
To: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Please CC me]

Hei,

I've had a suspend/resume issue for 3 years: my mouse isn't working
upon resume. I see this at resume time:

    i8042: failed to resume active multiplexor, mouse won't work.

and also some

    atkbd.c: Spurious ACK on isa0060/serio0. Some program might be
trying access hardware directly.

I used to solve it by unbinding/binding my i8042 module after suspend.
Worked great.
Now that I've upgraded my distribution once more, the latest kernel
doesn't expose unbind/bind attributes for the driver.
See http://marc.info/?l=linux-kernel&m=125585230724962&w=2 for patch
and thread that (understandably) disabled the feature.

So it looks like there's no workaround left for me to troubleshoot
this problem. I guess I need to finally fix the original issue !

I've enabled i8042.debug. I've tested the following: boot. go to
console. echo mem > /sys/power/state, resume, ALT+F7: no mouse on gdm.

Here's the log

[ startup ]

Jul  1 05:50:28 expresso2 kernel: [    0.678904] PNP: PS/2 Controller
[PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
Jul  1 05:50:28 expresso2 kernel: [    0.678992]
/build/buildd/linux-2.6.32/drivers/input/serio/i8042.c: 20 -> i8042
(command) [0]
Jul  1 05:50:28 expresso2 kernel: [    0.679004]
/build/buildd/linux-2.6.32/drivers/input/serio/i8042.c: 47 <- i8042
(return) [0]
Jul  1 05:50:28 expresso2 kernel: [    0.679068]
/build/buildd/linux-2.6.32/drivers/input/serio/i8042.c: 20 -> i8042
(command) [0]
Jul  1 05:50:28 expresso2 kernel: [    0.679080]
/build/buildd/linux-2.6.32/drivers/input/serio/i8042.c: 47 <- i8042
(return) [0]
Jul  1 05:50:28 expresso2 kernel: [    0.679089]
/build/buildd/linux-2.6.32/drivers/input/serio/i8042.c: 60 -> i8042
(command) [0]
Jul  1 05:50:28 expresso2 kernel: [    0.680008]
/build/buildd/linux-2.6.32/drivers/input/serio/i8042.c: 56 -> i8042
(parameter) [0]
Jul  1 05:50:28 expresso2 kernel: [    0.681368]
/build/buildd/linux-2.6.32/drivers/input/serio/i8042.c: d3 -> i8042
(command) [1]
Jul  1 05:50:28 expresso2 kernel: [    0.682935]
/build/buildd/linux-2.6.32/drivers/input/serio/i8042.c: 5a -> i8042
(parameter) [1]
Jul  1 05:50:28 expresso2 kernel: [    0.684248]
/build/buildd/linux-2.6.32/drivers/input/serio/i8042.c: 5a <- i8042
(return) [1]
Jul  1 05:50:28 expresso2 kernel: [    0.684280]
/build/buildd/linux-2.6.32/drivers/input/serio/i8042.c: a7 -> i8042
(command) [2]
Jul  1 05:50:28 expresso2 kernel: [    0.685793]
/build/buildd/linux-2.6.32/drivers/input/serio/i8042.c: 20 -> i8042
(command) [2]
Jul  1 05:50:28 expresso2 kernel: [    0.685805]
/build/buildd/linux-2.6.32/drivers/input/serio/i8042.c: 76 <- i8042
(return) [2]
Jul  1 05:50:28 expresso2 kernel: [    0.685812]
/build/buildd/linux-2.6.32/drivers/input/serio/i8042.c: a8 -> i8042
(command) [2]
Jul  1 05:50:28 expresso2 kernel: [    0.688266]
/build/buildd/linux-2.6.32/drivers/input/serio/i8042.c: 20 -> i8042
(command) [2]
Jul  1 05:50:28 expresso2 kernel: [    0.688266]
/build/buildd/linux-2.6.32/drivers/input/serio/i8042.c: 56 <- i8042
(return) [2]
Jul  1 05:50:28 expresso2 kernel: [    0.688387]
/build/buildd/linux-2.6.32/drivers/input/serio/i8042.c: 60 -> i8042
(command) [3]
Jul  1 05:50:28 expresso2 kernel: [    0.689747]
/build/buildd/linux-2.6.32/drivers/input/serio/i8042.c: 74 -> i8042
(parameter) [3]
Jul  1 05:50:28 expresso2 kernel: [    0.690485]
/build/buildd/linux-2.6.32/drivers/input/serio/i8042.c: d3 -> i8042
(command) [3]
Jul  1 05:50:28 expresso2 kernel: [    0.692052]
/build/buildd/linux-2.6.32/drivers/input/serio/i8042.c: f0 -> i8042
(parameter) [3]
Jul  1 05:50:28 expresso2 kernel: [    0.692340]
/build/buildd/linux-2.6.32/drivers/input/serio/i8042.c: f0 <- i8042
(return) [3]
Jul  1 05:50:28 expresso2 kernel: [    0.693420]
/build/buildd/linux-2.6.32/drivers/input/serio/i8042.c: d3 -> i8042
(command) [4]
Jul  1 05:50:28 expresso2 kernel: [    0.694831]
/build/buildd/linux-2.6.32/drivers/input/serio/i8042.c: 56 -> i8042
(parameter) [4]
Jul  1 05:50:28 expresso2 kernel: [    0.695935]
/build/buildd/linux-2.6.32/drivers/input/serio/i8042.c: 56 <- i8042
(return) [4]
Jul  1 05:50:28 expresso2 kernel: [    0.695942]
/build/buildd/linux-2.6.32/drivers/input/serio/i8042.c: d3 -> i8042
(command) [4]
Jul  1 05:50:28 expresso2 kernel: [    0.697383]
/build/buildd/linux-2.6.32/drivers/input/serio/i8042.c: a4 -> i8042
(parameter) [4]
Jul  1 05:50:28 expresso2 kernel: [    0.697383]
/build/buildd/linux-2.6.32/drivers/input/serio/i8042.c: 11 <- i8042
(return) [4]
Jul  1 05:50:28 expresso2 kernel: [    0.698303] i8042.c: Detected
active multiplexing controller, rev 1.1.
Jul  1 05:50:28 expresso2 kernel: [    0.698310]
/build/buildd/linux-2.6.32/drivers/input/serio/i8042.c: 60 -> i8042
(command) [5]
Jul  1 05:50:28 expresso2 kernel: [    0.699410]
/build/buildd/linux-2.6.32/drivers/input/serio/i8042.c: 74 -> i8042
(parameter) [5]
Jul  1 05:50:28 expresso2 kernel: [    0.724392]
/build/buildd/linux-2.6.32/drivers/input/serio/i8042.c: 90 -> i8042
(command) [12]
Jul  1 05:50:28 expresso2 kernel: [    0.725442]
/build/buildd/linux-2.6.32/drivers/input/serio/i8042.c: a8 -> i8042
(command) [12]
Jul  1 05:50:28 expresso2 kernel: [    0.727114]
/build/buildd/linux-2.6.32/drivers/input/serio/i8042.c: 91 -> i8042
(command) [12]
Jul  1 05:50:28 expresso2 kernel: [    0.728008]
/build/buildd/linux-2.6.32/drivers/input/serio/i8042.c: a8 -> i8042
(command) [12]
Jul  1 05:50:28 expresso2 kernel: [    0.731100]
/build/buildd/linux-2.6.32/drivers/input/serio/i8042.c: 92 -> i8042
(command) [13]
Jul  1 05:50:28 expresso2 kernel: [    0.732512]
/build/buildd/linux-2.6.32/drivers/input/serio/i8042.c: a8 -> i8042
(command) [13]
Jul  1 05:50:28 expresso2 kernel: [    0.734979]
/build/buildd/linux-2.6.32/drivers/input/serio/i8042.c: 93 -> i8042
(command) [14]
Jul  1 05:50:28 expresso2 kernel: [    0.736390]
/build/buildd/linux-2.6.32/drivers/input/serio/i8042.c: a8 -> i8042
(command) [14]
Jul  1 05:50:28 expresso2 kernel: [    0.738286]
/build/buildd/linux-2.6.32/drivers/input/serio/i8042.c: 60 -> i8042
(command) [15]
Jul  1 05:50:28 expresso2 kernel: [    0.739594]
/build/buildd/linux-2.6.32/drivers/input/serio/i8042.c: 56 -> i8042
(parameter) [15]
Jul  1 05:50:28 expresso2 kernel: [    0.748647]
/build/buildd/linux-2.6.32/drivers/input/serio/i8042.c: 60 -> i8042
(command) [18]
Jul  1 05:50:28 expresso2 kernel: [    0.749800]
/build/buildd/linux-2.6.32/drivers/input/serio/i8042.c: 47 -> i8042
(parameter) [18]
Jul  1 05:50:28 expresso2 kernel: [    0.749809] serio: i8042 KBD port
at 0x60,0x64 irq 1
Jul  1 05:50:28 expresso2 kernel: [    0.749828] serio: i8042 AUX0
port at 0x60,0x64 irq 12
Jul  1 05:50:28 expresso2 kernel: [    0.756100] serio: i8042 AUX1
port at 0x60,0x64 irq 12
Jul  1 05:50:28 expresso2 kernel: [    0.756166] serio: i8042 AUX2
port at 0x60,0x64 irq 12
Jul  1 05:50:28 expresso2 kernel: [    0.756217] serio: i8042 AUX3
port at 0x60,0x64 irq 12
Jul  1 05:50:28 expresso2 kernel: [    0.756472] mice: PS/2 mouse
device common for all mice
Jul  1 05:50:28 expresso2 kernel: [    0.756692]
/build/buildd/linux-2.6.32/drivers/input/serio/i8042.c: f2 -> i8042
(kbd-data) [20]
Jul  1 05:50:28 expresso2 kernel: [    0.756745] rtc_cmos 00:08: RTC
can wake from S4
Jul  1 05:50:28 expresso2 kernel: [    0.756819] rtc_cmos 00:08: rtc
core: registered rtc_cmos as rtc0
Jul  1 05:50:28 expresso2 kernel: [    0.756862] rtc0: alarms up to
one month, y3k, 242 bytes nvram, hpet irqs
Jul  1 05:50:28 expresso2 kernel: [    0.757079] device-mapper:
uevent: version 1.0.3
Jul  1 05:50:28 expresso2 kernel: [    0.759440]
/build/buildd/linux-2.6.32/drivers/input/serio/i8042.c: fa <- i8042
(interrupt, 0, 1) [20]
Jul  1 05:50:28 expresso2 kernel: [    0.760116]
/build/buildd/linux-2.6.32/drivers/input/serio/i8042.c: ab <- i8042
(interrupt, 0, 1) [21]
Jul  1 05:50:28 expresso2 kernel: [    0.760587]
/build/buildd/linux-2.6.32/drivers/input/serio/i8042.c: 41 <- i8042
(interrupt, 0, 1) [21]
Jul  1 05:50:28 expresso2 kernel: [    0.761107]
/build/buildd/linux-2.6.32/drivers/input/serio/i8042.c: ed -> i8042
(kbd-data) [21]
Jul  1 05:50:28 expresso2 kernel: [    0.762370]
/build/buildd/linux-2.6.32/drivers/input/serio/i8042.c: fa <- i8042
(interrupt, 0, 1) [21]
Jul  1 05:50:28 expresso2 kernel: [    0.762525]
/build/buildd/linux-2.6.32/drivers/input/serio/i8042.c: 00 -> i8042
(kbd-data) [21]
Jul  1 05:50:28 expresso2 kernel: [    0.765162]
/build/buildd/linux-2.6.32/drivers/input/serio/i8042.c: fa <- i8042
(interrupt, 0, 1) [22]
Jul  1 05:50:28 expresso2 kernel: [    0.765485]
/build/buildd/linux-2.6.32/drivers/input/serio/i8042.c: f3 -> i8042
(kbd-data) [22]
Jul  1 05:50:28 expresso2 kernel: [    0.767824]
/build/buildd/linux-2.6.32/drivers/input/serio/i8042.c: fa <- i8042
(interrupt, 0, 1) [22]
Jul  1 05:50:28 expresso2 kernel: [    0.768066]
/build/buildd/linux-2.6.32/drivers/input/serio/i8042.c: 00 -> i8042
(kbd-data) [23]
Jul  1 05:50:28 expresso2 kernel: [    0.769838]
/build/buildd/linux-2.6.32/drivers/input/serio/i8042.c: fa <- i8042
(interrupt, 0, 1) [23]
Jul  1 05:50:28 expresso2 kernel: [    0.769942] isapnp: No Plug &
Play device found
Jul  1 05:50:28 expresso2 kernel: [    0.769972]
/build/buildd/linux-2.6.32/drivers/input/serio/i8042.c: f4 -> i8042
(kbd-data) [23]
Jul  1 05:50:28 expresso2 kernel: [    0.770177] device-mapper: ioctl:
4.15.0-ioctl (2009-04-01) initialised: dm-devel@redhat.com
Jul  1 05:50:28 expresso2 kernel: [    0.770305] device-mapper:
multipath: version 1.1.0 loaded
Jul  1 05:50:28 expresso2 kernel: [    0.770311] device-mapper:
multipath round-robin: version 1.0.0 loaded
Jul  1 05:50:28 expresso2 kernel: [    0.770542] EISA: Probing bus 0 at eisa.0
Jul  1 05:50:28 expresso2 kernel: [    0.770552] Cannot allocate
resource for EISA slot 1
Jul  1 05:50:28 expresso2 kernel: [    0.770557] Cannot allocate
resource for EISA slot 2
Jul  1 05:50:28 expresso2 kernel: [    0.770561] Cannot allocate
resource for EISA slot 3
Jul  1 05:50:28 expresso2 kernel: [    0.770566] Cannot allocate
resource for EISA slot 4
Jul  1 05:50:28 expresso2 kernel: [    0.770590] EISA: Detected 0 cards.
Jul  1 05:50:28 expresso2 kernel: [    0.770869] cpuidle: using governor ladder
Jul  1 05:50:28 expresso2 kernel: [    0.771111] cpuidle: using governor menu
Jul  1 05:50:28 expresso2 kernel: [    0.771563]
/build/buildd/linux-2.6.32/drivers/input/serio/i8042.c: fa <- i8042
(interrupt, 0, 1) [23]
Jul  1 05:50:28 expresso2 kernel: [    0.772026] TCP cubic registered
Jul  1 05:50:28 expresso2 kernel: [    0.772287] input: AT Translated
Set 2 keyboard as /devices/platform/i8042/serio0/input/input4
Jul  1 05:50:28 expresso2 kernel: [    0.772369]
/build/buildd/linux-2.6.32/drivers/input/serio/i8042.c: 90 -> i8042
(command) [24]
Jul  1 05:50:28 expresso2 kernel: [    0.772391] NET: Registered
protocol family 10
Jul  1 05:50:28 expresso2 kernel: [    0.773314]
/build/buildd/linux-2.6.32/drivers/input/serio/i8042.c: f2 -> i8042
(parameter) [24]
Jul  1 05:50:28 expresso2 kernel: [    0.773373] lo: Disabled Privacy Extensions
Jul  1 05:50:28 expresso2 kernel: [    0.774080] NET: Registered
protocol family 17
Jul  1 05:50:28 expresso2 kernel: [    0.774710]
/build/buildd/linux-2.6.32/drivers/input/serio/i8042.c: fe <- i8042
(interrupt, 2, 12) [24]
Jul  1 05:50:28 expresso2 kernel: [    0.774907]
/build/buildd/linux-2.6.32/drivers/input/serio/i8042.c: 90 -> i8042
(command) [24]
Jul  1 05:50:28 expresso2 kernel: [    0.774943] Using IPI No-Shortcut mode
Jul  1 05:50:28 expresso2 kernel: [    0.775061] PM: Resume from disk failed.
Jul  1 05:50:28 expresso2 kernel: [    0.775074] registered taskstats version 1
Jul  1 05:50:28 expresso2 kernel: [    0.775682]   Magic number: 2:183:815
Jul  1 05:50:28 expresso2 kernel: [    0.776009]
/build/buildd/linux-2.6.32/drivers/input/serio/i8042.c: ed -> i8042
(parameter) [24]
Jul  1 05:50:28 expresso2 kernel: [    0.776097] rtc_cmos 00:08:
setting system clock to 2010-07-01 03:50:08 UTC (1277956208)
Jul  1 05:50:28 expresso2 kernel: [    0.776101] BIOS EDD facility
v0.16 2004-Jun-25, 0 devices found
Jul  1 05:50:28 expresso2 kernel: [    0.776103] EDD information not available.
Jul  1 05:50:28 expresso2 kernel: [    0.777365]
/build/buildd/linux-2.6.32/drivers/input/serio/i8042.c: fe <- i8042
(interrupt, 2, 12) [25]
Jul  1 05:50:28 expresso2 kernel: [    0.777442]
/build/buildd/linux-2.6.32/drivers/input/serio/i8042.c: 91 -> i8042
(command) [25]
Jul  1 05:50:28 expresso2 kernel: [    0.778846]
/build/buildd/linux-2.6.32/drivers/input/serio/i8042.c: f2 -> i8042
(parameter) [25]
Jul  1 05:50:28 expresso2 kernel: [    0.779739]
/build/buildd/linux-2.6.32/drivers/input/serio/i8042.c: fe <- i8042
(interrupt, 3, 12) [25]
Jul  1 05:50:28 expresso2 kernel: [    0.779802]
/build/buildd/linux-2.6.32/drivers/input/serio/i8042.c: 91 -> i8042
(command) [25]
Jul  1 05:50:28 expresso2 kernel: [    0.780947]
/build/buildd/linux-2.6.32/drivers/input/serio/i8042.c: ed -> i8042
(parameter) [25]
Jul  1 05:50:28 expresso2 kernel: [    0.781990]
/build/buildd/linux-2.6.32/drivers/input/serio/i8042.c: fe <- i8042
(interrupt, 3, 12) [26]
Jul  1 05:50:28 expresso2 kernel: [    0.782061]
/build/buildd/linux-2.6.32/drivers/input/serio/i8042.c: 92 -> i8042
(command) [26]
Jul  1 05:50:28 expresso2 kernel: [    0.783931]
/build/buildd/linux-2.6.32/drivers/input/serio/i8042.c: f2 -> i8042
(parameter) [26]
Jul  1 05:50:28 expresso2 kernel: [    0.784844]
/build/buildd/linux-2.6.32/drivers/input/serio/i8042.c: fe <- i8042
(interrupt, 4, 12) [27]
Jul  1 05:50:28 expresso2 kernel: [    0.784906]
/build/buildd/linux-2.6.32/drivers/input/serio/i8042.c: 92 -> i8042
(command) [27]
Jul  1 05:50:28 expresso2 kernel: [    0.786621]
/build/buildd/linux-2.6.32/drivers/input/serio/i8042.c: ed -> i8042
(parameter) [27]
Jul  1 05:50:28 expresso2 kernel: [    0.787544]
/build/buildd/linux-2.6.32/drivers/input/serio/i8042.c: fe <- i8042
(interrupt, 4, 12) [27]
Jul  1 05:50:28 expresso2 kernel: [    0.787615]
/build/buildd/linux-2.6.32/drivers/input/serio/i8042.c: 93 -> i8042
(command) [27]
Jul  1 05:50:28 expresso2 kernel: [    0.788967]
/build/buildd/linux-2.6.32/drivers/input/serio/i8042.c: f2 -> i8042
(parameter) [27]
Jul  1 05:50:28 expresso2 kernel: [    0.794694]
/build/buildd/linux-2.6.32/drivers/input/serio/i8042.c: fa <- i8042
(interrupt, 5, 12) [29]
Jul  1 05:50:28 expresso2 kernel: [    0.795382]
/build/buildd/linux-2.6.32/drivers/input/serio/i8042.c: 00 <- i8042
(interrupt, 5, 12) [29]
Jul  1 05:50:28 expresso2 kernel: [    0.812803] ata1.00: ATA-8: WDC
WD3200BEKT-22F3T0, 11.01A11, max UDMA/133


[resume]

Jul  1 05:53:46 expresso2 kernel: [  208.988160] PM: resume of drv:usb
dev:usb2 complete after 247.950 msecs
Jul  1 05:53:46 expresso2 kernel: [  209.236141] PM: resume of drv:usb
dev:usb4 complete after 247.936 msecs
Jul  1 05:53:46 expresso2 kernel: [  209.236236]
/build/buildd/linux-2.6.32/drivers/input/serio/i8042.c: aa <- i8042
(flush, kbd) [52140]
Jul  1 05:53:46 expresso2 kernel: [  209.236246]
/build/buildd/linux-2.6.32/drivers/input/serio/i8042.c: 60 -> i8042
(command) [52140]
Jul  1 05:53:46 expresso2 kernel: [  209.237397]
/build/buildd/linux-2.6.32/drivers/input/serio/i8042.c: 74 -> i8042
(parameter) [52140]
Jul  1 05:53:46 expresso2 kernel: [  209.238607]
/build/buildd/linux-2.6.32/drivers/input/serio/i8042.c: d3 -> i8042
(command) [52140]
Jul  1 05:53:46 expresso2 kernel: [  209.239758]
/build/buildd/linux-2.6.32/drivers/input/serio/i8042.c: f0 -> i8042
(parameter) [52140]
Jul  1 05:53:46 expresso2 kernel: [  209.239769]
/build/buildd/linux-2.6.32/drivers/input/serio/i8042.c:      -- i8042
(auxerr) [52140]
Jul  1 05:53:46 expresso2 kernel: [  209.239780]
/build/buildd/linux-2.6.32/drivers/input/serio/i8042.c: fa <- i8042
(interrupt, 0, 1) [52140]
Jul  1 05:53:46 expresso2 kernel: [  209.239786] i8042: failed to
resume active multiplexor, mouse won't work.
Jul  1 05:53:46 expresso2 kernel: [  209.240064]
/build/buildd/linux-2.6.32/drivers/input/serio/i8042.c: 60 -> i8042
(command) [52140]
Jul  1 05:53:46 expresso2 kernel: [  209.240064]
/build/buildd/linux-2.6.32/drivers/input/serio/i8042.c: 65 -> i8042
(parameter) [52140]
Jul  1 05:53:46 expresso2 kernel: [  209.241836]
/build/buildd/linux-2.6.32/drivers/input/serio/i8042.c: MUX error,
status is 37, data is f0 [52141]
Jul  1 05:53:46 expresso2 kernel: [  209.241842]
/build/buildd/linux-2.6.32/drivers/input/serio/i8042.c: fe <- i8042
(interrupt, 2, 0, timeout) [52141]

And the relevant code:

http://lxr.free-electrons.com/source/drivers/input/serio/i8042.c?v=2.6.32#L1079
http://lxr.free-electrons.com/source/drivers/input/serio/i8042.c?v=2.6.32#L526

so i8042_set_mux_mode() doesn't seem to work at all

I am running

    Linux expresso2 2.6.32-22-generic #36-Ubuntu SMP Thu Jun 3
22:02:19 UTC 2010 i686 GNU/Linux

But as far as I can tell, there's no modification to i8042 in that
kernel (http://packages.ubuntu.com/en/lucid/linux-image-2.6.32-22-generic)

Let me know if you need anything else.

Cheers,

Jerome

For reference,

* the hardware is a Lenovo 3000 N100
* some links:
https://bugs.launchpad.net/ubuntu/+source/pm-utils/+bug/23497
https://bugs.launchpad.net/ubuntu/+source/linux-source-2.6.20/+bug/86820
