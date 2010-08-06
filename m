Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935773Ab0HFTKY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 15:10:24 -0400
Received: from kroah.org ([198.145.64.141]:58611 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965123Ab0HFTAX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 15:00:23 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Aug  6 11:58:36 2010
Message-Id: <20100806185835.989589396@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 06 Aug 2010 11:57:19 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dave Airlie <airlied@redhat.com>, David Howells <dhowells@redhat.com>,
        Kurt Garloff <garloff@suse.de>
Subject: [24/34] slow-work: use get_ref wrapper instead of directly calling get_ref
In-Reply-To: <20100806185853.GA28270@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dave Airlie <airlied@redhat.com>

commit 88be12c440cfa2fa3f5be83507360aac9ea1c54e upstream.

Otherwise we can get an oops if the user has no get_ref/put_ref
requirement.

Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Kurt Garloff <garloff@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/slow-work.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/slow-work.c
+++ b/kernel/slow-work.c
@@ -640,7 +640,7 @@ int delayed_slow_work_enqueue(struct del
 			goto cancelled;
 
 		/* the timer holds a reference whilst it is pending */
-		ret = work->ops->get_ref(work);
+		ret = slow_work_get_ref(work);
 		if (ret < 0)
 			goto cant_get_ref;
 


