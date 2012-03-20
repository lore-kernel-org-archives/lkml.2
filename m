Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759903Ab2CTN3F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 09:29:05 -0400
Received: from mx2.netapp.com ([216.240.18.37]:49170 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758671Ab2CTN3B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 09:29:01 -0400
X-IronPort-AV: E=Sophos;i="4.73,618,1325491200"; 
   d="scan'208";a="634770959"
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: build warning after merge of the nfs tree
Thread-Topic: linux-next: build warning after merge of the nfs tree
Thread-Index: AQHNBp1oqOpFyJPoR0ir7B4cCdOlIQ==
Date: Tue, 20 Mar 2012 13:28:59 +0000
Message-ID: <1332250139.2963.7.camel@lade.trondhjem.org>
References: <20120320193443.ac26a6f22feacc00e59d3467@canb.auug.org.au>
In-Reply-To: <20120320193443.ac26a6f22feacc00e59d3467@canb.auug.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.104.60.115]
Content-Type: text/plain; charset="utf-8"
Content-ID: <58A283697BB97C4F96030429F844D348@tahoe.netapp.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q2KDTBQq002129

On Tue, 2012-03-20 at 19:34 +1100, Stephen Rothwell wrote:
> Hi Trond,
> 
> After merging the nfs tree, today's linux-next build (sparc32 defconfig)
> produced this warning:
> 
> net/sunrpc/rpcb_clnt.c: In function 'rpcb_enc_mapping':
> net/sunrpc/rpcb_clnt.c:820:19: warning: unused variable 'task' [-Wunused-variable]
> net/sunrpc/rpcb_clnt.c: In function 'rpcb_dec_getport':
> net/sunrpc/rpcb_clnt.c:837:19: warning: unused variable 'task' [-Wunused-variable]
> net/sunrpc/rpcb_clnt.c: In function 'rpcb_dec_set':
> net/sunrpc/rpcb_clnt.c:860:19: warning: unused variable 'task' [-Wunused-variable]
> net/sunrpc/rpcb_clnt.c: In function 'rpcb_enc_getaddr':
> net/sunrpc/rpcb_clnt.c:892:19: warning: unused variable 'task' [-Wunused-variable]
> net/sunrpc/rpcb_clnt.c: In function 'rpcb_dec_getaddr':
> net/sunrpc/rpcb_clnt.c:914:19: warning: unused variable 'task' [-Wunused-variable]
> fs/lockd/svclock.c:49:20: warning: 'nlmdbg_cookie2a' declared 'static' but never defined [-Wunused-function]
> 
> 
> Probably caused by some debugging being turned off.

Yes, this is due to the new CONFIG_SUNRPC_DEBUG being turned off. The
issue has in fact been in the tree for quite a while, but before we
added the explicit Kbuild switch, you had to have SUNRPC enabled, while
disabling SYSCTL in order to see it.

Anyhow, I've added a fix. Thanks for the report!

Cheers
  Trond
-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
