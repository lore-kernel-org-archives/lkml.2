Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759475Ab2J2P0w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 11:26:52 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:58122 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751612Ab2J2P0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 11:26:50 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] fanotify: Fix missing break
To: linux-kernel@vger.kernel.org, eparis@redhat.com, akpm@linux-foundation.org
Date: Mon, 29 Oct 2012 15:28:39 +0000
Message-ID: <20121029152837.14661.90815.stgit@bob.linux.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Paris <eparis@redhat.com>

Anders Blondell noted in 2010 that Fanotify lost events and provided a test
case. Eric Paris confirmed it was a bug and posted a fix to the list

https://groups.google.com/forum/?fromgroups=#!topic/linux.kernel/RrJfTfyW2BE

but never applied it. Repeated attempts over time to actually get him to
apply it have never had a reply from anyone who has raised it

So apply it anyway

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 fs/notify/fanotify/fanotify.c |    1 +
 1 file changed, 1 insertion(+)


diff --git a/fs/notify/fanotify/fanotify.c b/fs/notify/fanotify/fanotify.c
index aeb5b5a..0c2f912 100644
--- a/fs/notify/fanotify/fanotify.c
+++ b/fs/notify/fanotify/fanotify.c
@@ -27,6 +27,7 @@ static bool should_merge(struct fsnotify_event *old, struct fsnotify_event *new)
 			if ((old->path.mnt == new->path.mnt) &&
 			    (old->path.dentry == new->path.dentry))
 				return true;
+			break;
 		case (FSNOTIFY_EVENT_NONE):
 			return true;
 		default:

