Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758022Ab2KVVmD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 16:42:03 -0500
Received: from mail.kernel.org ([198.145.19.201]:49621 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755057Ab2KVSk1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:40:27 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Alex Elder <elder@inktank.com>, Sage Weil <sage@inktank.com>
Subject: [ 057/171] crush: adjust local retry threshold
Date: Wed, 21 Nov 2012 16:40:03 -0800
Message-Id: <20121122004039.092093923@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121122004033.298367941@linuxfoundation.org>
References: <20121122004033.298367941@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sage Weil <sage@inktank.com>

(cherry picked from commit c90f95ed46393e29d843686e21947d1c6fcb1164)

This small adjustment reflects a change that was made in ceph.git commit
af6a9f30696c900a2a8bd7ae24e8ed15fb4964bb, about 6 months ago.  An N-1
search is not exhaustive.  Fixed ceph.git bug #1594.

Reviewed-by: Alex Elder <elder@inktank.com>
Signed-off-by: Sage Weil <sage@inktank.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ceph/crush/mapper.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ceph/crush/mapper.c
+++ b/net/ceph/crush/mapper.c
@@ -415,7 +415,7 @@ reject:
 					if (collide && flocal < 3)
 						/* retry locally a few times */
 						retry_bucket = 1;
-					else if (flocal < in->size + orig_tries)
+					else if (flocal <= in->size + orig_tries)
 						/* exhaustive bucket search */
 						retry_bucket = 1;
 					else if (ftotal < 20)


