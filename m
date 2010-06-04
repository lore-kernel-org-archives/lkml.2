Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752936Ab0FDH2o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 03:28:44 -0400
Received: from cantor.suse.de ([195.135.220.2]:44255 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752873Ab0FDH2l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 03:28:41 -0400
Message-Id: <20100604064307.737085373@suse.de>
User-Agent: quilt/0.48-4.4
Date: Fri, 04 Jun 2010 16:43:07 +1000
From: Nick Piggin <npiggin@suse.de>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org
Cc: Frank Mayhar <fmayhar@google.com>
Cc: John Stultz <johnstul@us.ibm.com>
Cc: Andi Kleen <ak@linux.intel.com>
Subject: [patch 0/4] Initial vfs scalability patches again
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OK, I realised what I was smoking last time. So I put down the pipe and
went to score some stronger crack. And then:
- reduced ifdefs as much as feasible
- add more comments, avoided churn
- vastly improved lock library code, works with lockdep
- added helpers for file list iterations
- lglock type for what was previously open coded in file list locking

It looks in much better shape now I hope. Al would you consider them?

With all patches applied, I ran some single threaded microbenchmarks, and it
was difficult to tell much difference from the noise. I don't claim that there
is no slowdown because there is more instructions and memory accesses for SMP.
But it doesn't seem too bad.

Opteron, ran each test 30 times. Each run lasts for 3 seconds performing as
many operations as possible. Between each 10 runs, a rebooted. After all that
you still get artifacts, oh well.

Difference at 95.0% confidence (times, positive means patch is slower)
dup/close    No difference proven at 95.0% confidence
open/close  -2.48989% +/- 0.538414%
creat/unlink 3.14688% +/- 0.32411%



