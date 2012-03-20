Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759442Ab2CTNZv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 09:25:51 -0400
Received: from mx2.netapp.com ([216.240.18.37]:9640 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758590Ab2CTNZt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 09:25:49 -0400
X-IronPort-AV: E=Sophos;i="4.73,618,1325491200"; 
   d="scan'208";a="634769555"
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Adamson, Dros" <Weston.Adamson@netapp.com>
Subject: Re: linux-next: build failure after merge of the final tree (nfs
 tree related)
Thread-Topic: linux-next: build failure after merge of the final tree (nfs
 tree related)
Thread-Index: AQHNBpzqaTSkJmvtwEq1gHGt8Hv0Bw==
Date: Tue, 20 Mar 2012 13:25:29 +0000
Message-ID: <1332249929.2963.4.camel@lade.trondhjem.org>
References: <20120320192952.ed82031eec8a49cf7da40a8e@canb.auug.org.au>
In-Reply-To: <20120320192952.ed82031eec8a49cf7da40a8e@canb.auug.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.104.60.115]
Content-Type: text/plain; charset="utf-8"
Content-ID: <85F8EDDF7A38454D8A30D8DEEADC6B4D@tahoe.netapp.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q2KDPw8S002094

On Tue, 2012-03-20 at 19:29 +1100, Stephen Rothwell wrote:
> Hi Trond,
> 
> [This was previously reported as a warning ... but sparc uses -Werr in
> more places]
> 
> After merging the final tree, today's linux-next build (sparc64 defconfig)
> failed like this:
> 
> In file included from arch/sparc/kernel/sys_sparc32.c:24:0:
> include/linux/nfs_fs.h: In function 'nfs_display_fhandle_hash':
> include/linux/nfs_fs.h:416:1: error: no return statement in function returning non-void [-Werror=return-type]
> 
> Caused by commit d8e0539ebdff ("NFS: add filehandle crc for debug display").
> 
> I added the following patch for today:
> 
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Tue, 20 Mar 2012 19:26:42 +1100
> Subject: [PATCH] nfs: non void functions must return a value
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  include/linux/nfs_fs.h |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/nfs_fs.h b/include/linux/nfs_fs.h
> index 8f27c2e..69ec9cb 100644
> --- a/include/linux/nfs_fs.h
> +++ b/include/linux/nfs_fs.h
> @@ -413,6 +413,7 @@ extern void _nfs_display_fhandle(const struct nfs_fh *fh, const char *caption);
>  #else
>  static inline u32 nfs_display_fhandle_hash(const struct nfs_fh *fh)
>  {
> +	return 0;
>  }
>  static inline void nfs_display_fhandle(const struct nfs_fh *fh,
>  				       const char *caption)

Thanks Stephen! I've applied the above patch to my tree.

Cheers
  Trond

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
