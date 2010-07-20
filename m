Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758326Ab0GTMMz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 08:12:55 -0400
Received: from mailhost4.gawab.com ([66.220.20.4]:50340 "HELO info9.gawab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752160Ab0GTMMw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 08:12:52 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 Jul 2010 08:12:52 EDT
X-Trusted: Whitelisted
From: Al Boldi <a1426z@gawab.com>
To: linux-kernel@vger.kernel.org
Subject: [Regression] mm: Huge swapout performance regression on recent kernels
Date: Tue, 20 Jul 2010 15:07:31 +0300
User-Agent: KMail/1.5
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201007201507.31851.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have noticed a big swapout performance regression on recent kernels using 
the following testcase:

swapon /dev/md0 (raid0)
mount none /dev/shm -t tmpfs -o size=10G 
cat /dev/full > /dev/shm/tst.dmp

Kernel starts to swapout at full speed after filling physical ram.
Then, kernel progressively slows down swapout after crossing the ~3G VM 
threshold, compounding at over 50% slowdown when reaching the 10G tmpfs 
limit.

Has this been fixed?


Thanks!

--
Al

