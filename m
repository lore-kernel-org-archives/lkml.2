Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934213Ab0EEJMR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 05:12:17 -0400
Received: from hera.kernel.org ([140.211.167.34]:51499 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755064Ab0EEJMP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 05:12:15 -0400
Message-ID: <4BE1365F.5010908@kernel.org>
Date: Wed, 05 May 2010 11:11:59 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
CC: Oleg Nesterov <oleg@redhat.com>
Subject: [GIT PULL] workqueue fixes for v2.6.34-rc6
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 05 May 2010 09:12:00 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

Please pull from

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git for-linus

to receive wq fix for v2.6.34-rc6.  The branch contains only single
fix from Oleg Nesterov.  8c53e46314562fe814b0afef6cfcbd2f562b017c
modified flush_delayed_work() to queue the work immediately after
shooting down the timer but it incorrectly always used keventd_wq
instead of the original workqueue the delayed work was destined for.
As the work is executed on the default workqueue, it probably can go
unnoticed in most cases but may still lead to very subtle problems.

Thanks.

Oleg Nesterov (1):
      workqueue: flush_delayed_work: keep the original workqueue for re-queueing

 kernel/workqueue.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

-- 
tejun
