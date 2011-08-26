Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754832Ab1HZKVb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 06:21:31 -0400
Received: from wavehammer.waldi.eu.org ([82.139.201.20]:44269 "EHLO
	wavehammer.waldi.eu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754568Ab1HZKV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 06:21:28 -0400
X-Greylist: delayed 342 seconds by postgrey-1.27 at vger.kernel.org; Fri, 26 Aug 2011 06:21:28 EDT
Date: Fri, 26 Aug 2011 12:15:42 +0200
From: Bastian Blank <bastian@waldi.eu.org>
To: dm-devel@redhat.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] dm-kcopyd: Correctly free requests
Message-ID: <20110826101542.GB20197@wavehammer.waldi.eu.org>
Mail-Followup-To: dm-devel@redhat.com, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kcopyd only frees the requests if the master job information is set up
correctly, but it was not in the recently added path. This leads to many
unfreed slabs during snapshot usage.

Signed-off-by: Bastian Blank <waldi@debian.org>
Tested-by: Andreas Barth <aba@not.so.argh.org>

diff --git a/drivers/md/dm-kcopyd.c b/drivers/md/dm-kcopyd.c
index f821470..32ac708 100644
--- a/drivers/md/dm-kcopyd.c
+++ b/drivers/md/dm-kcopyd.c
@@ -628,6 +628,7 @@ void *dm_kcopyd_prepare_callback(struct dm_kcopyd_client *kc,
 	job->kc = kc;
 	job->fn = fn;
 	job->context = context;
+	job->master_job = job;
 
 	atomic_inc(&kc->nr_jobs);
 
-- 
Landru! Guide us!
		-- A Beta 3-oid, "The Return of the Archons", stardate 3157.4
