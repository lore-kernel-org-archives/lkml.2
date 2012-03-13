Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756340Ab2CMPcG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 11:32:06 -0400
Received: from mx2.netapp.com ([216.240.18.37]:10150 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756094Ab2CMPcD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 11:32:03 -0400
X-IronPort-AV: E=Sophos;i="4.73,577,1325491200"; 
   d="scan'208";a="633016435"
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: Miklos Szeredi <miklos@szeredi.hu>
CC: "viro@ZenIV.linux.org.uk" <viro@ZenIV.linux.org.uk>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hch@infradead.org" <hch@infradead.org>,
        "sfrench@samba.org" <sfrench@samba.org>,
        "sage@newdream.net" <sage@newdream.net>,
        "ericvh@gmail.com" <ericvh@gmail.com>
Subject: Re: [PATCH 04/25] vfs: add i_op->atomic_open()
Thread-Topic: [PATCH 04/25] vfs: add i_op->atomic_open()
Thread-Index: AQHNASuUC7lUB3jyj06t8SMxFcM85ZZoz8+A
Date: Tue, 13 Mar 2012 15:31:47 +0000
Message-ID: <1331652707.3419.16.camel@lade.trondhjem.org>
References: <1331155362-11132-1-git-send-email-miklos@szeredi.hu>
	 <1331155362-11132-5-git-send-email-miklos@szeredi.hu>
	 <1331649485.3419.12.camel@lade.trondhjem.org>
	 <87y5r47cyg.fsf@tucsk.pomaz.szeredi.hu>
In-Reply-To: <87y5r47cyg.fsf@tucsk.pomaz.szeredi.hu>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.104.60.115]
Content-Type: text/plain; charset="utf-8"
Content-ID: <07009DF35449064DBC896DB8964DF189@tahoe.netapp.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q2DFWCvg022131

On Tue, 2012-03-13 at 16:11 +0100, Miklos Szeredi wrote:
> "Myklebust, Trond" <Trond.Myklebust@netapp.com> writes:
> 
> > On Wed, 2012-03-07 at 22:22 +0100, Miklos Szeredi wrote:
> >> +
> >> +	if ((nd->flags & LOOKUP_OPEN) && dir_inode->i_op->atomic_open) {
> >> +		struct file *filp;
> >> +
> >> +		filp = atomic_open(nd, dentry, op, want_write, &create_error);
> >> +		if (filp) {
> >> +			dput(dentry);
> >> +			return filp;
> >> +		}
> >> +		/* fall back to plain lookup */
> >> +	}
> >
> > Would it be possible to allow the filesystem to return a new dentry even
> > if it can't complete the actual open? That way we can return the actual
> > symlink that caused the open to fail instead of looking it up separately
> > (which may be subject to races).
> 
> This should be possible, but I'm reluctant to add more arguments to
> ->atomic_open.  Other possibilites that come to mind:
> 
>   return -ELOOKEDUP - caller should retry d_lookup and proceed with the result
> 
>   call opendata_set_dentry(od, dentry) and return NULL - caller checks
>   opendata for non-NULL dentry and proceeds with that

Or convert the existing 'dentry' argument into a struct dentry **.

Then again, it might just be easier to convert the existing arguments
into a single "open" structure.

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
