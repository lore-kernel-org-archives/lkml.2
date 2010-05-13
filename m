Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932890Ab0EMWSA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 18:18:00 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:59536 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754485Ab0EMWR6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 18:17:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=YHJIz+1cVDQXbx3/79nZ/gJPCDqXkT+l/K0mCq/97EP4SR4/C5c0Z1+SbtmF98+qFT
         b1wpP9yFFPK9m0ArMwuWxV1wTHLjvZsUAXTSIxsE7D6TWyBpfMwOP3uwJxBj+3GP1u83
         ZrI4VlAxYWOr5/Dj0HFwvB/xKyVFHbcLY/o5U=
MIME-Version: 1.0
Date: Fri, 14 May 2010 03:47:55 +0530
Message-ID: <AANLkTimKHkgWJJOOICzQ4TL3mbL-lvYEocwBSe3XSBVR@mail.gmail.com>
Subject: Performance Events hangs with Intel P4 system
From: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I am testing Performance Events on P4 with HT:

[    0.002243] Performance Events: Netburst events, Netburst P4/Xeon PMU driver.
[    0.002432] ... version:                0
[    0.002545] ... bit width:              40
[    0.002659] ... generic registers:      18
[    0.002772] ... value mask:             000000ffffffffff
[    0.002887] ... max period:             0000007fffffffff
[    0.003004] ... fixed-purpose events:   0
[    0.003118] ... event mask:             000000000003ffff

dmesg : http://userweb.kernel.org/~jaswinder/P4_HT/dmesg-2634-rc7-tip.txt
config : http://userweb.kernel.org/~jaswinder/P4_HT/config-2634-rc7-tip.txt

[jaswinder@ht perf]$ ./perf stat -e cycles ls > /dev/null

 Performance counter stats for 'ls':

  <not counted>  cycles

    0.003447053  seconds time elapsed

[jaswinder@ht perf]$ ./perf stat -e cycles,instructions ls > /dev/null

 Performance counter stats for 'ls':

  <not counted>  cycles
        1862188  instructions             #      0.000 IPC    (scaled
from 54.91%)

    0.003419230  seconds time elapsed

[jaswinder@ht perf]$ ./perf stat -e
cycles,instructions,cache-references ls > /dev/null

<<this dumps on screen and hangs the systems>>

How can I fix this problem.

Thanks,
--
Jaswinder Singh.
