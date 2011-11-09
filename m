Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934490Ab1KJDZH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 22:25:07 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42110 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933701Ab1KJDZD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:25:03 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:27:07 2011
Message-Id: <20111109212707.225328030@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:26:30 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Milan Broz <mbroz@redhat.com>,
        Kay Sievers <kay.sievers@vrfy.org>
Subject: [068/262] kobj_uevent: Ignore if some listeners cannot handle message
In-Reply-To: <20111109212847.GA20838@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Milan Broz <mbroz@redhat.com>

commit ebf4127cd677e9781b450e44dfaaa1cc595efcaa upstream.

kobject_uevent() uses a multicast socket and should ignore
if one of listeners cannot handle messages or nobody is
listening at all.

Easily reproducible when a process in system is cloned
with CLONE_NEWNET flag.

(See also http://article.gmane.org/gmane.linux.kernel.device-mapper.dm-crypt/5256)

Signed-off-by: Milan Broz <mbroz@redhat.com>
Acked-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 lib/kobject_uevent.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/kobject_uevent.c
+++ b/lib/kobject_uevent.c
@@ -282,7 +282,7 @@ int kobject_uevent_env(struct kobject *k
 							    kobj_bcast_filter,
 							    kobj);
 			/* ENOBUFS should be handled in userspace */
-			if (retval == -ENOBUFS)
+			if (retval == -ENOBUFS || retval == -ESRCH)
 				retval = 0;
 		} else
 			retval = -ENOMEM;


