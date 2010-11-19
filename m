Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757785Ab0KSWBg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 17:01:36 -0500
Received: from kroah.org ([198.145.64.141]:45413 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757640Ab0KSV7G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 16:59:06 -0500
X-Mailbox-Line: From gregkh@clark.site Fri Nov 19 13:56:45 2010
Message-Id: <20101119215645.151352011@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 19 Nov 2010 13:56:39 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Eric Paris <eparis@redhat.com>, Paul Moore <paul.moore@hp.com>,
        James Morris <jmorris@namei.org>
Subject: [78/82] secmark: do not return early if there was no error
In-Reply-To: <20101119215658.GA7804@kroah.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Eric Paris <eparis@redhat.com>

commit 15714f7b58011cf3948cab2988abea560240c74f upstream.

Commit 4a5a5c73 attempted to pass decent error messages back to userspace for
netfilter errors.  In xt_SECMARK.c however the patch screwed up and returned
on 0 (aka no error) early and didn't finish setting up secmark.  This results
in a kernel BUG if you use SECMARK.

Signed-off-by: Eric Paris <eparis@redhat.com>
Acked-by: Paul Moore <paul.moore@hp.com>
Signed-off-by: James Morris <jmorris@namei.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/netfilter/xt_SECMARK.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/netfilter/xt_SECMARK.c
+++ b/net/netfilter/xt_SECMARK.c
@@ -101,7 +101,7 @@ static int secmark_tg_check(const struct
 	switch (info->mode) {
 	case SECMARK_MODE_SEL:
 		err = checkentry_selinux(info);
-		if (err <= 0)
+		if (err)
 			return err;
 		break;
 


