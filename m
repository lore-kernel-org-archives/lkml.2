Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755119Ab1ILVv6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 17:51:58 -0400
Received: from mail-vw0-f52.google.com ([209.85.212.52]:38381 "EHLO
	mail-vw0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754856Ab1ILVvz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 17:51:55 -0400
MIME-Version: 1.0
Date: Mon, 12 Sep 2011 14:51:53 -0700
Message-ID: <CAB2gnbXKGD5fBykQdNhgTjS4GZDchzFGxXqRuuLEMqALLO4_7w@mail.gmail.com>
Subject: [PATCH 1/2] ceph: fix parse options memory leak
From: Noah Watkins <noahwatkins@gmail.com>
To: Sage Weil <sage@newdream.net>
Cc: ceph-devel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ceph_destroy_options does not free opt->mon_addr that
is allocated in ceph_parse_options.

Signed-off-by: Noah Watkins <noahwatkins@gmail.com>
---
 net/ceph/ceph_common.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/ceph/ceph_common.c b/net/ceph/ceph_common.c
index d4038ca..97f70e5 100644
--- a/net/ceph/ceph_common.c
+++ b/net/ceph/ceph_common.c
@@ -232,6 +232,7 @@ void ceph_destroy_options(struct ceph_options *opt)
 		ceph_crypto_key_destroy(opt->key);
 		kfree(opt->key);
 	}
+	kfree(opt->mon_addr);
 	kfree(opt);
 }
 EXPORT_SYMBOL(ceph_destroy_options);
-- 
1.7.6.1
