Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752201Ab1IWUWd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 16:22:33 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:47942 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752047Ab1IWUWc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 16:22:32 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-6.tower-132.messagelabs.com!1316809270!28822663!95
X-Originating-IP: [216.166.12.97]
X-StarScan-Version: 6.3.6; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] ceph/mds_client.c: quiet sparse noise
Date: Fri, 23 Sep 2011 13:22:11 -0700
User-Agent: KMail/1.9.9
CC: <ceph-devel@vger.kernel.org>, <sage@newdream.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201109231322.12090.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quiet the following sparse noise:

warning: symbol 'get_nonsnap_parent' was not declared. Should it be static?
warning: symbol 'done_closing_sessions' was not declared. Should it be static?

Local functions don't need external visability. Make them static.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Sage Weil <sage@newdream.net>

---

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 2712e8f..9ec5d1e 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -619,7 +619,7 @@ static void __unregister_request(struct ceph_mds_client *mdsc,
  *
  * Called under mdsc->mutex.
  */
-struct dentry *get_nonsnap_parent(struct dentry *dentry)
+static struct dentry *get_nonsnap_parent(struct dentry *dentry)
 {
 	/*
 	 * we don't need to worry about protecting the d_parent access
@@ -3154,7 +3154,7 @@ void ceph_mdsc_sync(struct ceph_mds_client *mdsc)
 /*
  * true if all sessions are closed, or we force unmount
  */
-bool done_closing_sessions(struct ceph_mds_client *mdsc)
+static bool done_closing_sessions(struct ceph_mds_client *mdsc)
 {
 	int i, n = 0;
 
