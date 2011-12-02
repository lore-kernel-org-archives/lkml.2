Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756174Ab1LBMnz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 07:43:55 -0500
Received: from mail.openrapids.net ([64.15.138.104]:49391 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755699Ab1LBMny (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 07:43:54 -0500
Date: Fri, 2 Dec 2011 07:43:52 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Greg KH <greg@kroah.com>
Cc: Jens Axboe <jens@axboe.dk>, lttng-dev@lists.lttng.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: [PATCH] fs/splice: export splice_to_pipe to modules
Message-ID: <20111202124352.GB13082@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 07:40:48 up 373 days, 17:43,  2 users,  load average: 0.07, 0.18,
	0.32
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The LTTng driver needs this symbol exported because it implements its
own splice actor.

All other exports in splice are EXPORT_SYMBOL(), so follow the local
trend by not using a _GPL() export.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>
CC: Jens Axboe <axboe@kernel.dk>
CC: linux-kernel@vger.kernel.org
CC: Greg KH <greg@kroah.com>
---
 fs/splice.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/splice.c b/fs/splice.c
index fa2defa..492585d 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -263,6 +263,7 @@ ssize_t splice_to_pipe(struct pipe_inode_info *pipe,
 
 	return ret;
 }
+EXPORT_SYMBOL(splice_to_pipe);
 
 void spd_release_page(struct splice_pipe_desc *spd, unsigned int i)
 {
-- 
1.7.5.4
