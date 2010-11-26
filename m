Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753954Ab0KZOGa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 09:06:30 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:60888 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752161Ab0KZOG3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 09:06:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=wA5mHgyRNoWDaqEJUjIko3lo7hIay0ypSB+9171ow3FQNs7jyjtMeggS7c8hob/lgh
         TTqAiuAKwVSFSFU/izmHCY/dfRILNPl4GZ+2o+wULoFKhhl624Ftzl065ezd1FGmkD2W
         CobwMqywmh2TqdTsgxIi0xC1BxDhcD1zivZ80=
MIME-Version: 1.0
Date: Fri, 26 Nov 2010 22:06:27 +0800
Message-ID: <AANLkTimV=6=Je=k6UW=ivJtmR0ONoTrscM2i8YJd5JjA@mail.gmail.com>
Subject: [PATCH] add rb_next in block throttle
From: Hillf Danton <dhillf@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When selecting group for dispatching, the first entry of the service
tree is sequentially dequeued, then the first entry is recomputed by
calling rb_first().

When the first is removed from service tree, new first could also be
computed with rb_next(), since it could be faster than rb_first in
this special environment.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- a/block/blk-throttle.c	2010-11-01 19:54:12.000000000 +0800
+++ b/block/blk-throttle.c	2010-11-26 21:27:40.000000000 +0800
@@ -251,7 +251,7 @@ static void rb_erase_init(struct rb_node
 static void throtl_rb_erase(struct rb_node *n, struct throtl_rb_root *root)
 {
 	if (root->left == n)
-		root->left = NULL;
+		root->left = rb_next(n);
 	rb_erase_init(n, &root->rb);
 	--root->count;
 }
