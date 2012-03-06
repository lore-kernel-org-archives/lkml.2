Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964954Ab2CFRsI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 12:48:08 -0500
Received: from mx2.netapp.com ([216.240.18.37]:52645 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932522Ab2CFRsG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 12:48:06 -0500
X-IronPort-AV: E=Sophos;i="4.73,540,1325491200"; 
   d="scan'208";a="631153236"
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: Miklos Szeredi <miklos@szeredi.hu>
CC: "viro@ZenIV.linux.org.uk" <viro@ZenIV.linux.org.uk>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hch@infradead.org" <hch@infradead.org>
Subject: Re: [PATCH 9/9] nfs: don't open in ->d_revalidate
Thread-Topic: [PATCH 9/9] nfs: don't open in ->d_revalidate
Thread-Index: AQHM+7wY/8/o98YKtk2fJ0XNzaBcrJZeER+A
Date: Tue, 6 Mar 2012 17:47:48 +0000
Message-ID: <1331056067.10560.26.camel@lade.trondhjem.org>
References: <1331038601-20353-1-git-send-email-miklos@szeredi.hu>
	 <1331038601-20353-10-git-send-email-miklos@szeredi.hu>
	 <1331043158.3260.3.camel@lade.trondhjem.org>
	 <87boo9k861.fsf@tucsk.pomaz.szeredi.hu>
	 <1331052079.3260.33.camel@lade.trondhjem.org>
	 <87y5rdirj2.fsf@tucsk.pomaz.szeredi.hu>
In-Reply-To: <87y5rdirj2.fsf@tucsk.pomaz.szeredi.hu>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.104.60.115]
Content-Type: text/plain; charset="utf-8"
Content-ID: <63A3730199B11C498119D561FBE597D9@tahoe.netapp.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q26HmEZR009376

On Tue, 2012-03-06 at 18:10 +0100, Miklos Szeredi wrote:
> "Myklebust, Trond" <Trond.Myklebust@netapp.com> writes:
> 
> > It makes a big difference to the cache miss case, since not only is the
> > entire path looked up again, but the LOOKUP_REVAL flag gets set, which
> > forces a full lookup of each component (as opposed to just
> > revalidating).
> 
> This is not about a cache miss.  It's about a cache hit (positive cached
> dentry) but changed inode on the server.
> 
> Is this a likely scenario?

Consider something like a git pull on the server, or a distributed
compile across many NFS clients. In both those cases, you are typically
creating and re-creating files with the same name while bypassing the
dcache on your client.

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
