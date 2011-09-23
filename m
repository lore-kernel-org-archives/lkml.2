Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751596Ab1IWSyD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 14:54:03 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:63086 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102Ab1IWSyB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 14:54:01 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-4.tower-132.messagelabs.com!1316803970!36099467!73
X-Originating-IP: [216.166.12.178]
X-StarScan-Version: 6.3.6; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] ceph/super.c: quiet sparse noise
Date: Fri, 23 Sep 2011 11:53:30 -0700
User-Agent: KMail/1.9.9
CC: <ceph-devel@vger.kernel.org>, <sage@newdream.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201109231153.30334.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quiet the sparse noise:

warning: symbol 'create_fs_client' was not declared. Should it be static?
warning: symbol 'destroy_fs_client' was not declared. Should it be static?

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Sage Weil <sage@newdream.net>
ceph-devel@vger.kernel.org

---

diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index e0a6a06..bbc1b78 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -426,7 +426,7 @@ static int extra_mon_dispatch(struct ceph_client *client, struct ceph_msg *msg)
 /*
  * create a new fs client
  */
-struct ceph_fs_client *create_fs_client(struct ceph_mount_options *fsopt,
+static struct ceph_fs_client *create_fs_client(struct ceph_mount_options *fsopt,
 					struct ceph_options *opt)
 {
 	struct ceph_fs_client *fsc;
@@ -502,7 +502,7 @@ fail:
 	return ERR_PTR(err);
 }
 
-void destroy_fs_client(struct ceph_fs_client *fsc)
+static void destroy_fs_client(struct ceph_fs_client *fsc)
 {
 	dout("destroy_fs_client %p\n", fsc);
 
