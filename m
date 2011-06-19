Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752029Ab1FSQdM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jun 2011 12:33:12 -0400
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:40603 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751618Ab1FSQdK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jun 2011 12:33:10 -0400
Date: Sun, 19 Jun 2011 19:33:08 +0300 (EEST)
From: Meelis Roos <mroos@linux.ee>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
        sparclinux@vger.kernel.org
Subject: reorganized struct inode results in unaligned accesses
Message-ID: <alpine.SOC.1.00.1106191927250.4844@math.ut.ee>
User-Agent: Alpine 1.00 (SOC 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A week ago I noticed that in 3.0.0-rc3, sparc64 machines log a lot of 
unaligned accesses in different vfs functions in dmesg. I reported but 
obviously not well enough. Today I had a look at it and found the 
reason.

Commit 13e12d14e2dccc7995b8f15a5678a338ab4e6a8c (vfs: reorganize 'struct 
inode' layout a bit) changes i_state to be unsigned int instead of 
unsigned long. This is the cause of unaligned accesses on sparc64 and 
maybe others. Changing it back to unsigned long fixes the warnings but I 
did not look at the layout of the resulting struct - might leave a hole 
there.

-- 
Meelis Roos (mroos@linux.ee)
