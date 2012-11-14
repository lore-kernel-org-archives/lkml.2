Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756325Ab2KNGEe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 01:04:34 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55067 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754898Ab2KNFuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 00:50:25 -0500
Message-Id: <20121114053942.671138015@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 14 Nov 2012 05:40:37 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Eric Paris <eparis@redhat.com>, Alan Cox <alan@linux.intel.com>,
        Anders Blomdell <anders.blomdell@control.lth.se>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 64/82] fanotify: fix missing break
In-Reply-To: <20121114053933.726869752@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Paris <eparis@redhat.com>

commit 848561d368751a1c0f679b9f045a02944506a801 upstream.

Anders Blomdell noted in 2010 that Fanotify lost events and provided a
test case.  Eric Paris confirmed it was a bug and posted a fix to the
list

  https://groups.google.com/forum/?fromgroups=#!topic/linux.kernel/RrJfTfyW2BE

but never applied it.  Repeated attempts over time to actually get him
to apply it have never had a reply from anyone who has raised it

So apply it anyway

Signed-off-by: Alan Cox <alan@linux.intel.com>
Reported-by: Anders Blomdell <anders.blomdell@control.lth.se>
Cc: Eric Paris <eparis@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/notify/fanotify/fanotify.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/notify/fanotify/fanotify.c b/fs/notify/fanotify/fanotify.c
index f35794b..a506360 100644
--- a/fs/notify/fanotify/fanotify.c
+++ b/fs/notify/fanotify/fanotify.c
@@ -21,6 +21,7 @@ static bool should_merge(struct fsnotify_event *old, struct fsnotify_event *new)
 			if ((old->path.mnt == new->path.mnt) &&
 			    (old->path.dentry == new->path.dentry))
 				return true;
+			break;
 		case (FSNOTIFY_EVENT_NONE):
 			return true;
 		default:


