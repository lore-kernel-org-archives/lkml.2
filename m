Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757414Ab0ERQdj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 12:33:39 -0400
Received: from hera.kernel.org ([140.211.167.34]:36953 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751539Ab0ERQdh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 12:33:37 -0400
Message-ID: <4BF2C136.4020104@kernel.org>
Date: Tue, 18 May 2010 18:32:54 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
CC: Alan Stern <stern@rowland.harvard.edu>, Oleg Nesterov <oleg@redhat.com>
Subject: [GIT PULL] workqueue for v2.6.35-rc1
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 18 May 2010 16:32:55 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

Please pull from the following branch to receive wq changes for
v2.6.35-rc1.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git for-linus

Bulk of cmwq still waiting for scheduler hooks to be resolved, there
are only two commits for v2.6.35-rc1.

One adds comment to flush_scheduled_work() mostly warning about the
possibility of deadlock.  The other makes cancel_work_sync() clear
work->data which speeds up further cancel/flush requests on it and
also makes it safe to call cancel/flush on already canceled works even
if the previous workqueue is destroyed.

Thanks.

Alan Stern (1):
      workqueue: warn about flush_scheduled_work()

Oleg Nesterov (1):
      workqueue: change cancel_work_sync() to clear work->data

 kernel/workqueue.c |   36 +++++++++++++++++++++++++++++++++++-
 1 files changed, 35 insertions(+), 1 deletions(-)

--
tejun
