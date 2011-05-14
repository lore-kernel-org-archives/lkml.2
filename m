Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758356Ab1ENP7K (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 May 2011 11:59:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26491 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757560Ab1ENP7H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 May 2011 11:59:07 -0400
Date: Sat, 14 May 2011 17:59:00 +0200 (CEST)
From: John Kacur <jkacur@redhat.com>
X-X-Sender: jkacur@localhost6.localdomain6
To: Thomas Gleixner <tglx@linutronix.de>
cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
Subject: merge of real-time 2.6.33.9-rt31 with stable 2.6.33.13
Message-ID: <alpine.LFD.2.00.1105141749180.29326@localhost6.localdomain6>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Thomas

I did some light testing merging 2.6.33.13 into real-time 2.6.33.9-rt31.
In addition I cherry-picked 3c955b407a084810f57260d61548cc92c14bc627
in order to compile on newer distros.

Please consider picking this up. You can get it from
git://git.kernel.org/pub/scm/linux/kernel/git/jkacur/jk-2.6.git rt/2.6.33

Thanks

John Kacur

Here is the result of cyclic test on one machine
sudo ./cyclictest -t32 -p 80 -n -i 10000 -l 10000
policy: fifo: loadavg: 0.00 0.00 0.00 1/541 3759          

T: 0 ( 3728) P:80 I:10000 C:  10000 Min:      7 Act:  104 Avg:  114 Max:     470
T: 1 ( 3729) P:79 I:10500 C:   9524 Min:      4 Act:   93 Avg:  105 Max:     417
T: 2 ( 3730) P:78 I:11000 C:   9091 Min:      4 Act:  114 Avg:  125 Max:     420
T: 3 ( 3731) P:77 I:11500 C:   8696 Min:      4 Act:   58 Avg:   91 Max:     387
T: 4 ( 3732) P:76 I:12000 C:   8333 Min:      4 Act:   84 Avg:  114 Max:     425
T: 5 ( 3733) P:75 I:12500 C:   8000 Min:      4 Act:  133 Avg:  112 Max:     385
T: 6 ( 3734) P:74 I:13000 C:   7692 Min:      3 Act:    8 Avg:   65 Max:     377
T: 7 ( 3735) P:73 I:13500 C:   7407 Min:      3 Act:   91 Avg:   71 Max:     358
T: 8 ( 3736) P:72 I:14000 C:   7143 Min:      4 Act:   78 Avg:   98 Max:     323
T: 9 ( 3737) P:71 I:14500 C:   6897 Min:      7 Act:  133 Avg:  109 Max:     300
T:10 ( 3738) P:70 I:15000 C:   6667 Min:      5 Act:  115 Avg:   98 Max:     314
T:11 ( 3739) P:69 I:15500 C:   6452 Min:      3 Act:    6 Avg:   79 Max:     280
T:12 ( 3740) P:68 I:16000 C:   6250 Min:      3 Act:   68 Avg:   80 Max:     317
T:13 ( 3741) P:67 I:16500 C:   6061 Min:      4 Act:  142 Avg:   82 Max:     255
T:14 ( 3742) P:66 I:17000 C:   5882 Min:      4 Act:  132 Avg:  102 Max:     253
T:15 ( 3743) P:65 I:17500 C:   5714 Min:      4 Act:  135 Avg:  111 Max:     342
T:16 ( 3744) P:64 I:18000 C:   5556 Min:      4 Act:   16 Avg:   37 Max:     315
T:17 ( 3745) P:63 I:18500 C:   5405 Min:      3 Act:   12 Avg:   53 Max:     322
T:18 ( 3746) P:62 I:19000 C:   5263 Min:      3 Act:   62 Avg:   37 Max:     250
T:19 ( 3747) P:61 I:19500 C:   5128 Min:      3 Act:   65 Avg:   35 Max:     276
T:20 ( 3748) P:60 I:20000 C:   5000 Min:      3 Act:  180 Avg:   81 Max:     295
T:21 ( 3749) P:59 I:20500 C:   4878 Min:      3 Act:   76 Avg:   45 Max:     314
T:22 ( 3750) P:58 I:21000 C:   4762 Min:      3 Act:  133 Avg:   38 Max:     265
T:23 ( 3751) P:57 I:21500 C:   4651 Min:      3 Act:  132 Avg:   71 Max:     300
T:24 ( 3752) P:56 I:22000 C:   4546 Min:      3 Act:    6 Avg:   57 Max:     227
T:25 ( 3753) P:55 I:22500 C:   4445 Min:      3 Act:   72 Avg:   50 Max:     258
T:26 ( 3754) P:54 I:23000 C:   4348 Min:      4 Act:   97 Avg:  106 Max:     335
T:27 ( 3755) P:53 I:23500 C:   4255 Min:      3 Act:   67 Avg:   80 Max:     244
T:28 ( 3756) P:52 I:24000 C:   4167 Min:      3 Act:    7 Avg:   26 Max:     232
T:29 ( 3757) P:51 I:24500 C:   4082 Min:      3 Act:    6 Avg:   81 Max:     353
T:30 ( 3758) P:50 I:25000 C:   4000 Min:      3 Act:   11 Avg:   31 Max:     418
T:31 ( 3759) P:49 I:25500 C:   3922 Min:      3 Act:    6 Avg:   21 Max:     433


