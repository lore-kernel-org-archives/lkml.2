Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755363Ab0IPOdJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 10:33:09 -0400
Received: from dtp.xs4all.nl ([80.101.171.8]:30077 "HELO abra2.bitwizard.nl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1754981Ab0IPOdH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 10:33:07 -0400
Date: Thu, 16 Sep 2010 16:33:04 +0200
From: Rogier Wolff <R.E.Wolff@BitWizard.nl>
To: linux-kernel@vger.kernel.org
Subject: Sudden "hangs".... 
Message-ID: <20100916143304.GA14874@bitwizard.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: BitWizard.nl
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

It seems my home workstation hangs on a "mkdir" once every morning for
about half a minute. It'll freeze whatever I'm doing and continue
happily 30 seconds later, but I can't figure out what's going on
because it's frozen...

My server did it just now and I was able to grab some more
debugging info..... 

obelix:~> time mkdir /recover3/testdir
0.000u 0.004s 2:11.83 0.0%      0+0k 0+0io 5pf+0w
obelix:~> 

Over two minutes to make a directory! (I have the impression that
the wait is for something to finish, so if I had started the mkdir
a minute earlier, it would've taken a minute longer). 

The process:
28649 root      20   0     0    0    0 D  6.3  0.0   0:11.69 flush-9:0 

was in "top", and as shown here in "disk wait" mode. 

While this is going on, "vmstat 1"  shows:

procs -----------memory---------- ---swap-- -----io---- -system-- ----cpu----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa
 0  1   5368  12764 324804 1616932    0    0   464     0  244  477  0  2  0 98
 0  1   5368  12764 324556 1617168    0    0   448     0  255  474  0  1  0 99
 0  1   5368  12764 324952 1616832    0    0   472     0  257  487  0  1  0 99

... about 400 kbytes of IO per second. This is similar to the
single-disk machine at home.

The server runs: 

Linux version 2.6.34 (wolff@abra2) (gcc version 4.1.2 20061115 (prerelease) (Debian 4.1.1-21)) #5 SMP Tue Jun 1 14:44:01 CEST 2010

at home I run: 
Linux version 2.6.28-19-generic (buildd@palmer) (gcc version 4.3.3 (Ubuntu 4.3.3-5ubuntu4) ) #61-Ubuntu SMP Wed May 26 23:35:15 UTC 2010


Does anybody know what's going on? 

	Roger. 


-- 
** R.E.Wolff@BitWizard.nl ** http://www.BitWizard.nl/ ** +31-15-2600998 **
**    Delftechpark 26 2628 XH  Delft, The Netherlands. KVK: 27239233    **
*-- BitWizard writes Linux device drivers for any device you may have! --*
Q: It doesn't work. A: Look buddy, doesn't work is an ambiguous statement. 
Does it sit on the couch all day? Is it unemployed? Please be specific! 
Define 'it' and what it isn't doing. --------- Adapted from lxrbot FAQ
