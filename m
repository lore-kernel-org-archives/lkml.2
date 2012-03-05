Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754984Ab2CEVsX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 16:48:23 -0500
Received: from mail-pz0-f52.google.com ([209.85.210.52]:35024 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754239Ab2CEVsW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 16:48:22 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of htejun@gmail.com designates 10.68.203.135 as permitted sender) smtp.mail=htejun@gmail.com; dkim=pass header.i=htejun@gmail.com
Date: Mon, 5 Mar 2012 13:48:18 -0800
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Christoph Lameter <cl@linux-foundation.org>
Subject: [GIT PULL] percpu: fixes for v3.3-rc6
Message-ID: <20120305214818.GE1263@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

This pull request contains four patches.  One replaces manual clearing
with bitmap_clear(), two fix generic definition of __this_cpu ops so
that they don't choose unnecessarily strict arch version.  One makes
_this_cpu definition use raw_local_irq_*() so that it doesn't end up
wrecking irq on/off state tracking when used from inside lockdep.

Of the four patches, the raw_local_irq_*() update is the most
important, so please feel free to cherry pick only that one patch and
ignore the rest if you want to - e920d5971d "percpu: use
raw_local_irq_* in _this_cpu op".

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu.git for-3.3-fixes

Akinobu Mita (1):
      percpu: use bitmap_clear

Konstantin Khlebnikov (2):
      percpu: fix generic definition of __this_cpu_add_and_return()
      percpu: fix __this_cpu_{sub,inc,dec}_return() definition

Ming Lei (1):
      percpu: use raw_local_irq_* in _this_cpu op

 include/linux/percpu.h |   29 +++++++++++++++--------------
 mm/percpu-vm.c         |    3 +--
 2 files changed, 16 insertions(+), 16 deletions(-)

Thanks.

-- 
tejun
