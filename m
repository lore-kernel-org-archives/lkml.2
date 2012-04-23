Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753970Ab2DWHIA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 03:08:00 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:55753 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945Ab2DWHH7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 03:07:59 -0400
Date: Mon, 23 Apr 2012 00:06:41 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>
Cc: Russell King <linux@arm.linux.org.uk>, Mike Frysinger <vapier@gentoo.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Richard Weinberger <richard@nod.at>, Paul Mundt <lethal@linux-sh.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        John Stultz <john.stultz@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        uclinux-dist-devel@blackfin.uclinux.org, linuxppc-dev@lists.ozlabs.org,
        linux-sh@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net,
        linux-mm@kvack.org, linaro-kernel@lists.linaro.org, patches@linaro.org
Subject: [PATCH v3 0/9] Fixes for common mistakes w/ for_each_process and
 task->mm
Message-ID: <20120423070641.GA27702@lizard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

This is another resend of several task->mm fixes, the bugs I found
during LMK code audit. Architectures were traverse the tasklist
in an unsafe manner, plus there are a few cases of unsafe access to
task->mm in general.

There were no objections on the previous resend, and the final words
were somewhere along "the patches are fine" line.

In v3:
- Dropped a controversal 'Make find_lock_task_mm() sparse-aware' patch;
- Reword arm and sh commit messages, per Oleg Nesterov's suggestions;
- Added an optimization trick in clear_tasks_mm_cpumask(): take only
  the rcu read lock, no need for the whole tasklist_lock.
  Suggested by Peter Zijlstra.

In v2: 
- introduced a small helper in cpu.c: most arches duplicate the
  same [buggy] code snippet, so it's better to fix it and move the
  logic into a common function.

Thanks,

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
