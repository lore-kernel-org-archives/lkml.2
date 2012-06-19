Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753427Ab2FSWo5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 18:44:57 -0400
Received: from mx2.netapp.com ([216.240.18.37]:19918 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751548Ab2FSWo4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 18:44:56 -0400
X-IronPort-AV: E=Sophos;i="4.77,439,1336374000"; 
   d="scan'208";a="656575870"
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: Ken Moffat <zarniwhoop@ntlworld.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: nfs3 problem with -rc{2,3} : blame
Thread-Topic: nfs3 problem with -rc{2,3} : blame
Thread-Index: AQHNTbfMQXPaY40l50mll7MzWrSjoJcCSNMAgAAAxYCAAAjvAIAADkmAgAAegwCAADTLgA==
Date: Tue, 19 Jun 2012 22:44:38 +0000
Message-ID: <1340145877.3754.39.camel@lade.trondhjem.org>
References: <20120618160005.GA10169@milliways>
	 <20120618200525.GA15654@milliways> <20120618215323.GA17561@milliways>
	 <1340057002.20570.31.camel@lade.trondhjem.org>
	 <20120618221052.GA18341@milliways> <20120619010641.GA22288@milliways>
	 <1340122836.3754.9.camel@lade.trondhjem.org>
	 <1340123001.3754.11.camel@lade.trondhjem.org>
	 <20120619165520.GA11015@milliways>
	 <1340127987.3754.16.camel@lade.trondhjem.org>
	 <20120619193540.GA14702@milliways>
In-Reply-To: <20120619193540.GA14702@milliways>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.104.60.115]
Content-Type: text/plain; charset="utf-8"
Content-ID: <D27CBA6B07ADD1479CA73E29E205794E@tahoe.netapp.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q5JMj2fm030897

On Tue, 2012-06-19 at 20:35 +0100, Ken Moffat wrote:
>  Unfortunately, no difference (on top of -rc3).
> 
>  FWIW, after rsync stalled I tried a download from firefox, to a
> different nfs mount, and that too appeared to lock up firefox.

OK, I think I see what the problem is...

Does the following patch work for you?

Cheers
  Trond
8<------------------------------------------------------
>From 1a0de48ae56b5cdb9a46b3d3a0b578dd7f787f22 Mon Sep 17 00:00:00 2001
From: Trond Myklebust <Trond.Myklebust@netapp.com>
Date: Tue, 19 Jun 2012 18:38:56 -0400
Subject: [PATCH] NFS: Initialise commit_info.rpc_out when
 !defined(CONFIG_NFS_V4)

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: Fred Isaman <iisaman@netapp.com>
---
 fs/nfs/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
index e605d69..f729698 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -1530,7 +1530,6 @@ static inline void nfs4_init_once(struct nfs_inode *nfsi)
 	nfsi->delegation_state = 0;
 	init_rwsem(&nfsi->rwsem);
 	nfsi->layout = NULL;
-	atomic_set(&nfsi->commit_info.rpcs_out, 0);
 #endif
 }
 
@@ -1545,6 +1544,7 @@ static void init_once(void *foo)
 	INIT_LIST_HEAD(&nfsi->commit_info.list);
 	nfsi->npages = 0;
 	nfsi->commit_info.ncommit = 0;
+	atomic_set(&nfsi->commit_info.rpcs_out, 0);
 	atomic_set(&nfsi->silly_count, 1);
 	INIT_HLIST_HEAD(&nfsi->silly_list);
 	init_waitqueue_head(&nfsi->waitqueue);
-- 
1.7.10.2


-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
