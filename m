Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935085Ab1KCBoL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 21:44:11 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51628 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935040Ab1KCBoI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 21:44:08 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  2 15:27:46 2011
Message-Id: <20111102222746.156076550@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 02 Nov 2011 15:26:54 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Milan Broz <mbroz@redhat.com>,
        Kay Sievers <kay.sievers@vrfy.org>
Subject: [070/101] kobj_uevent: Ignore if some listeners cannot handle message
In-Reply-To: <20111102222755.GA10893@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

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
@@ -235,7 +235,7 @@ int kobject_uevent_env(struct kobject *k
 			retval = netlink_broadcast(uevent_sock, skb, 0, 1,
 						   GFP_KERNEL);
 			/* ENOBUFS should be handled in userspace */
-			if (retval == -ENOBUFS)
+			if (retval == -ENOBUFS || retval == -ESRCH)
 				retval = 0;
 		} else
 			retval = -ENOMEM;


