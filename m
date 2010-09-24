Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754595Ab0IXQwA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 12:52:00 -0400
Received: from kroah.org ([198.145.64.141]:38423 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932724Ab0IXQ2h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 12:28:37 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Sep 24 09:26:19 2010
Message-Id: <20100924162619.218157467@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 24 Sep 2010 09:24:38 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [50/80] GFS2: gfs2_logd should be using interruptible waits
In-Reply-To: <20100924162706.GA7381@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Steven Whitehouse <swhiteho@redhat.com>

commit 5f4874903df3562b9d5649fc1cf7b8c6bb238e42 upstream.

Looks like this crept in, in a recent update.

Reported-by: Krzysztof Urbaniak <urban@bash.org.pl>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/gfs2/log.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/gfs2/log.c
+++ b/fs/gfs2/log.c
@@ -932,7 +932,7 @@ int gfs2_logd(void *data)
 
 		do {
 			prepare_to_wait(&sdp->sd_logd_waitq, &wait,
-					TASK_UNINTERRUPTIBLE);
+					TASK_INTERRUPTIBLE);
 			if (!gfs2_ail_flush_reqd(sdp) &&
 			    !gfs2_jrnl_flush_reqd(sdp) &&
 			    !kthread_should_stop())


