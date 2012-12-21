Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751447Ab2LUFop (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 00:44:45 -0500
Received: from us01smtp2.synopsys.com ([198.182.44.80]:43295 "EHLO
	kiruna.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750751Ab2LUFok (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 00:44:40 -0500
Message-ID: <50D3F735.4060506@synopsys.com>
Date: Fri, 21 Dec 2012 11:14:21 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: 3.8 NFS build breakage with !CONFIG_NFS_FSCACHE
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.197.205]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

Not sure if this was report/fixed already - but as of today's Linus tree
(tip has commit 96680d2), I'm seeing a build breakage due to a trivial
missing def for nfs_fscache_wait_on_invalidate.

Following fixes it for me.

diff --git a/fs/nfs/fscache.h b/fs/nfs/fscache.h
index 277b027..4ecb766 100644
--- a/fs/nfs/fscache.h
+++ b/fs/nfs/fscache.h
@@ -222,6 +222,7 @@ static inline void nfs_readpage_to_fscache(struct
inode *inode,
 
 
 static inline void nfs_fscache_invalidate(struct inode *inode) {}
+static inline void nfs_fscache_wait_on_invalidate(struct inode *inode) {}


Thx,
-Vineet
