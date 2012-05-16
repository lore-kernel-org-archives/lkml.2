Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759497Ab2EPRry (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 13:47:54 -0400
Received: from mx2.netapp.com ([216.240.18.37]:15306 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759250Ab2EPRru (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 13:47:50 -0400
X-IronPort-AV: E=Sophos;i="4.75,604,1330934400"; 
   d="scan'208";a="648074780"
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Schumaker, Bryan" <Bryan.Schumaker@netapp.com>
Subject: Re: linux-next: build failure after merge of the nfs tree
Thread-Topic: linux-next: build failure after merge of the nfs tree
Thread-Index: AQHNM4wC2rZAKbG/2kK6nku/JYcr6g==
Date: Wed, 16 May 2012 17:47:20 +0000
Message-ID: <1337190469.3008.4.camel@lade.trondhjem.org>
References: <20120516124942.5d776132d69f82bd8ed50e08@canb.auug.org.au>
In-Reply-To: <20120516124942.5d776132d69f82bd8ed50e08@canb.auug.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.106.53.51]
Content-Type: text/plain; charset="utf-8"
Content-ID: <C85A5C8CF057F0419185B67690C79E97@tahoe.netapp.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q4GHmQ2a013043

On Wed, 2012-05-16 at 12:49 +1000, Stephen Rothwell wrote:
> Hi Trond,
> 
> After merging the nfs tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
> 
> fs/nfs/super.c: In function 'nfs_get_cache_cookie':
> fs/nfs/super.c:2361:12: error: 'struct nfs_server' has no member named 'fscache_key'
> fs/nfs/super.c:2362:16: error: 'struct nfs_server' has no member named 'fscache_key'
> fs/nfs/super.c:2363:16: error: 'struct nfs_server' has no member named 'fscache_key'
> fs/nfs/super.c:2367:2: warning: passing argument 3 of 'nfs_fscache_get_super_cookie' makes pointer from integer without a cast [enabled by default]
> fs/nfs/fscache.h:173:20: note: expected 'struct nfs_clone_mount *' but argument is of type 'int'
> 
> Casued by commit 2311b9439ce8 ("NFS: Don't pass mount data to
> nfs_fscache_get_super_cookie()").  This build has CONFIG_NFS_FSCACHE
> unset.  grep is your friend.
> 
> I have used the nfs tree from next-20120514 for today.
> 

Thanks Stephen! I've added a fix for this in todays linux-next branch.

Cheers
  Trond
-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
