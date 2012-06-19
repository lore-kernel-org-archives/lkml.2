Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753589Ab2FSQX0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 12:23:26 -0400
Received: from mx2.netapp.com ([216.240.18.37]:32946 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751619Ab2FSQXY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 12:23:24 -0400
X-IronPort-AV: E=Sophos;i="4.75,799,1330934400"; 
   d="scan'208";a="656484669"
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: Ken Moffat <zarniwhoop@ntlworld.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: nfs3 problem with -rc{2,3} : blame
Thread-Topic: nfs3 problem with -rc{2,3} : blame
Thread-Index: AQHNTbfMQXPaY40l50mll7MzWrSjoJcCSNMAgAAAxYA=
Date: Tue, 19 Jun 2012 16:23:23 +0000
Message-ID: <1340123001.3754.11.camel@lade.trondhjem.org>
References: <20120617200700.GA15348@milliways>
	 <1340026956.2451.9.camel@lade.trondhjem.org>
	 <1340027134.2451.12.camel@lade.trondhjem.org>
	 <20120618141854.GA7962@milliways>
	 <1340031234.2451.13.camel@lade.trondhjem.org>
	 <20120618160005.GA10169@milliways> <20120618200525.GA15654@milliways>
	 <20120618215323.GA17561@milliways>
	 <1340057002.20570.31.camel@lade.trondhjem.org>
	 <20120618221052.GA18341@milliways> <20120619010641.GA22288@milliways>
	 <1340122836.3754.9.camel@lade.trondhjem.org>
In-Reply-To: <1340122836.3754.9.camel@lade.trondhjem.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.104.60.115]
Content-Type: text/plain; charset="utf-8"
Content-ID: <8B1486114680D041939F68AC4C074913@tahoe.netapp.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q5JGNUBk029277

On Tue, 2012-06-19 at 12:20 -0400, Trond Myklebust wrote:
> On Tue, 2012-06-19 at 02:06 +0100, Ken Moffat wrote:
> > On Mon, Jun 18, 2012 at 11:10:52PM +0100, Ken Moffat wrote:
> > > On Mon, Jun 18, 2012 at 10:03:24PM +0000, Myklebust, Trond wrote:
> > > > 
> > > > Doesn't 4f97615d19 fix the fs/nfs/direct.c problem too? It should.
> > > > 
> > > > Anyhow, if you can apply that on top of the commits that didn't compile,
> > > > and then continue the bisection, that would be great. We definitely do
> > > > want the !defined(CONFIG_NFS_V4) case to work in 3.5-final...
> > > > 
> > >  OK (I was assuming errors in different places were from different
> > > causes).  I'll do that after I've rerun rc3 without NFS_V4 with
> > > SUNRPC_DEBUG.  Thanks.
> > 
> > Bisection now points to:
> > 
> > 6d74743b088d116e31fe1b73f47e782ee2016b94 is the first bad commit
> > commit 6d74743b088d116e31fe1b73f47e782ee2016b94
> > Author: Trond Myklebust <Trond.Myklebust@netapp.com>
> > Date:   Mon Apr 30 13:27:31 2012 -0400
> > 
> >     NFS: Simplify O_DIRECT page referencing
> >     
> >     The O_DIRECT code shouldn't need to hold 2 references to each
> > page. The
> >     reference held by the struct nfs_page should suffice.
> >     
> >     Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
> >     Cc: Fred Isaman <iisaman@netapp.com>
> > 
> >  I was going to revert that from 3.5.0-rc3 to confirm that my
> > problem with backups was gone, and then give it more extended
> > testing to prove firefox downloads were ok, but 6 of 11 hunks
> > failed, the code has changed and I'm not familiar with it.
> 
> However you are saying that the problem is there when you compile a
> kernel with this commit as the head, and it goes away when you compile a
> kernel with commit 3e9e0ca3f19e911ce13c2e6c9858fcb41a37496c as the head?
> 
> I'm confused as to how a bug in that patch could depend on
> CONFIG_NFS_V4, but I'll see what I can find.

By the way, I thought your test-case was doing firefox downloads. Do
those really use O_DIRECT?

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
