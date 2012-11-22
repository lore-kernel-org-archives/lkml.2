Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758333Ab2KVWT1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 17:19:27 -0500
Received: from mail.kernel.org ([198.145.19.201]:49362 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754553Ab2KVSib (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:38:31 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Alan Cox <alan@linux.intel.com>,
        Anders Blomdell <anders.blomdell@control.lth.se>,
        Eric Paris <eparis@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 10/83] fanotify: fix missing break
Date: Wed, 21 Nov 2012 16:41:32 -0800
Message-Id: <20121122004213.576080418@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121122004212.371862690@linuxfoundation.org>
References: <20121122004212.371862690@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/notify/fanotify/fanotify.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/notify/fanotify/fanotify.c
+++ b/fs/notify/fanotify/fanotify.c
@@ -21,6 +21,7 @@ static bool should_merge(struct fsnotify
 			if ((old->path.mnt == new->path.mnt) &&
 			    (old->path.dentry == new->path.dentry))
 				return true;
+			break;
 		case (FSNOTIFY_EVENT_NONE):
 			return true;
 		default:


