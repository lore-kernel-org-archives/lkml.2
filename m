Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753154Ab2CaVKM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2012 17:10:12 -0400
Received: from mx2.netapp.com ([216.240.18.37]:2097 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753104Ab2CaVJk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2012 17:09:40 -0400
X-IronPort-AV: E=Sophos;i="4.75,349,1330934400"; 
   d="scan'208";a="637739621"
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: Chuck Lever <chuck.lever@oracle.com>
CC: Jim Rees <rees@umich.edu>, Sasha Levin <levinsasha928@gmail.com>,
        "Lukas Razik" <linux@razik.name>, Pekka Enberg <penberg@kernel.org>,
        "Linux NFS Mailing List" <linux-nfs@vger.kernel.org>,
        LKML Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] nfs: Don't try mounting device as nfs root unless type
 fully matches
Thread-Topic: [PATCH] nfs: Don't try mounting device as nfs root unless type
 fully matches
Thread-Index: AczOyD8O2ia/X6JtQLKyxujV3UdWfRAxG/6AAAAyEYAAC/KdgA==
Date: Sat, 31 Mar 2012 21:09:29 +0000
Message-ID: <1333228179.2719.14.camel@lade.trondhjem.org>
References: <1325927523-30103-1-git-send-email-levinsasha928@gmail.com>
	 <5FF522E0-132E-4A6A-A40F-5CCD08AF800A@oracle.com>
	 <20120107181221.GA3777@umich.edu> <1326111265.30169.5.camel@lappy>
	 <CA+1xoqdQPi53GYr_Q6RtECJJcrz0TVVp4uNQX6jkfbQWQSNF7g@mail.gmail.com>
	 <D3642511-B29B-4CA7-A133-C99B711954C1@oracle.com>
In-Reply-To: <D3642511-B29B-4CA7-A133-C99B711954C1@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.104.60.115]
Content-Type: text/plain; charset="utf-8"
Content-ID: <D23928FD98776448B229B1B9AD5E45A6@tahoe.netapp.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q2VLAJYD025534

On Sat, 2012-03-31 at 11:27 -0400, Chuck Lever wrote:
> Oops.  Trond?  This got dropped somewhere.

I don't own the 'init' directory, and since quite frankly this isn't
related to NFS at all, it should be sent to Linus directly.

I'm quite happy to ack the patch if that would help.

Cheers
  Trond

> On Mar 31, 2012, at 11:21 AM, Sasha Levin wrote:
> 
> > ping? I saw that this one didn't get pulled into the tree.
> > 
> > On Mon, Jan 9, 2012 at 1:14 PM, Sasha Levin <levinsasha928@gmail.com> wrote:
> >> On Sat, 2012-01-07 at 13:12 -0500, Jim Rees wrote:
> >>> Chuck Lever wrote:
> >>> 
> >>>   On Jan 7, 2012, at 4:12 AM, Sasha Levin wrote:
> >>> 
> >>>   > Currently, we'll try mounting any device who's major device number is
> >>>   > UNNAMED_MAJOR as NFS root. This would happen for non-NFS devices as well (such
> >>>   > as 9p devices) but it wouldn't cause any issues since mounting the device
> >>>   > as NFS would fail quickly and the code proceeded to doing the proper mount:
> >>>   >
> >>>   >   [  101.522716] VFS: Unable to mount root fs via NFS, trying floppy.
> >>>   >   [  101.534499] VFS: Mounted root (9p filesystem) on device 0:18.
> >>>   >
> >>>   > Commit 6829a048 ("NFS: Retry mounting NFSROOT") has introduced retries when
> >>>   > mounting NFS root, which means that now we don't immediately fail and instead
> >>>   > it takes an additional 90+ seconds until we stop retrying.
> >>>   >
> >>>   > This meant that it would take an additional 90 seconds to boot when we're not
> >>>   > using a device type which gets detected in order before NFS.
> >>> 
> >>>   The long timeouts are kind of irrelevant, in my view.  The real problem is
> >>>   that NFS was tried at all in this case.  That behavior was not introduced
> >>>   by 6829a058.
> >>> 
> >>> The comment does imply that 6829a048 introduced a bug, but that's not true.
> >>> It uncovered a bug that was there before.
> >>> 
> >>> I would change the part about "now we don't immediately fail."  It didn't
> >>> immediately fail before, but the timeout was short enough that you wouldn't
> >>> notice it.
> >> 
> >> I tried to point out that 6829a048 changed the behavior which was
> >> described in the first paragraph, I didn't try to imply that 6829a048 is
> >> buggy on its own.
> >> 
> >> I'm fine with changing the changelog to whatever will make it clearer.
> >> 
> >> --
> >> 
> >> Sasha.
> >> 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
