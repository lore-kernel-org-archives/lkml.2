Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753729Ab2FRWDl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 18:03:41 -0400
Received: from mx2.netapp.com ([216.240.18.37]:44691 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752036Ab2FRWDk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 18:03:40 -0400
X-IronPort-AV: E=Sophos;i="4.75,793,1330934400"; 
   d="scan'208";a="656299065"
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: Ken Moffat <zarniwhoop@ntlworld.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: nfs3 problem with -rc{2,3}
Thread-Topic: nfs3 problem with -rc{2,3}
Thread-Index: AQHNTMS9i2iatMLpKEGb4f4ZWuxoUpcAjD8AgAAA1ACAAAlRAIAACccAgAASfoCAAESLgIAAHiuAgAACygA=
Date: Mon, 18 Jun 2012 22:03:24 +0000
Message-ID: <1340057002.20570.31.camel@lade.trondhjem.org>
References: <20120617200700.GA15348@milliways>
	 <1340026956.2451.9.camel@lade.trondhjem.org>
	 <1340027134.2451.12.camel@lade.trondhjem.org>
	 <20120618141854.GA7962@milliways>
	 <1340031234.2451.13.camel@lade.trondhjem.org>
	 <20120618160005.GA10169@milliways> <20120618200525.GA15654@milliways>
	 <20120618215323.GA17561@milliways>
In-Reply-To: <20120618215323.GA17561@milliways>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.104.60.115]
Content-Type: text/plain; charset="utf-8"
Content-ID: <0ADF9212B610054F976A2C6C37D0E577@tahoe.netapp.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q5IM3k77024293

On Mon, 2012-06-18 at 22:53 +0100, Ken Moffat wrote:
> On Mon, Jun 18, 2012 at 09:05:25PM +0100, Ken Moffat wrote:
> > 
> >  I suppose I'll have to enable v4 in my configs.
> > 
>  Just to confirm, -rc3 with CONFIG_NFS_V4 added to my original
> .config appears to work fine on nfs v3.
> 
>  I suppose I could apply 4f97615d19c370d1d907ef37f8bcd9c3672851ca on
> top of the conmits which failed to compile without v4, if it is worth
> investigating this ?  It certainly fixes the error in fs/nfs/read.c,
> but I also had:
> 
> fs/nfs/direct.c:86:29: error: field â€˜ds_cinfoâ€™ has incomplete type
> 
>  in 3e9e0ca3 which would still prevent me testing at least some of
> these commits.  Seems to have been fixed *somewhere* in that series,
> otherwise 4f97615d would not have compiled.  Any suggestions for
> that ?  Alternatively would it be useful if I discovered which
> commits are affected for ds_cinfo, or should I just follow the good
> Dr.Pangloss and add V4 to my config ? ;-)

Doesn't 4f97615d19 fix the fs/nfs/direct.c problem too? It should.

Anyhow, if you can apply that on top of the commits that didn't compile,
and then continue the bisection, that would be great. We definitely do
want the !defined(CONFIG_NFS_V4) case to work in 3.5-final...

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
