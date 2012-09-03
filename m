Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756537Ab2ICSwx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 14:52:53 -0400
Received: from mx2.netapp.com ([216.240.18.37]:4789 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754370Ab2ICSww (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 14:52:52 -0400
X-IronPort-AV: E=Sophos;i="4.80,361,1344236400"; 
   d="scan'208";a="685271462"
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: Andi Kleen <andi@firstfloor.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Fix memset in NFS zap caches
Thread-Topic: [PATCH] Fix memset in NFS zap caches
Thread-Index: AQHNigLiTnmJlQHzNUyblrA1JsIXkpd5aCAAgAACXACAAAF2AA==
Date: Mon, 3 Sep 2012 18:52:49 +0000
Message-ID: <4FA345DA4F4AE44899BD2B03EEEC2FA908F81B7D@SACEXCMBX04-PRD.hq.netapp.com>
References: <20120903183515.GT16230@one.firstfloor.org>
	 <4FA345DA4F4AE44899BD2B03EEEC2FA908F81A8E@SACEXCMBX04-PRD.hq.netapp.com>
	 <20120903184734.GU16230@one.firstfloor.org>
In-Reply-To: <20120903184734.GU16230@one.firstfloor.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.104.60.115]
Content-Type: text/plain; charset="utf-8"
Content-ID: <C70131D1AEB6474C8E11537A3F1D2291@tahoe.netapp.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q83IqviF007639

On Mon, 2012-09-03 at 20:47 +0200, Andi Kleen wrote:
> > No, this is a gcc bug.
> > 
> > NFS_COOKIEVERF(inode) resolves to an array, so the current code is
> > correct. The above change will cause the 2nd half of the array to remain
> > uninitialised...
> 
> Are you sure?
> 
> include/linux/nfs_fs.h:268:static inline __be32 *NFS_COOKIEVERF(const struct inode *inode)
> 
> That doesn't look like an array type to me. 

Argh... It used to be a #define, but got converted in the commit
99fadcd7646 static inline blitz...

OK, let's just get rid of the NFS_COOKIEVERF thing altogether. At this
point it is clearly just obfuscating the code.

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
