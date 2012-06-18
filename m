Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753643Ab2FRWK5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 18:10:57 -0400
Received: from mtaout02-winn.ispmail.ntl.com ([81.103.221.48]:28060 "EHLO
	mtaout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751385Ab2FRWK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 18:10:56 -0400
Date: Mon, 18 Jun 2012 23:10:52 +0100
From: Ken Moffat <zarniwhoop@ntlworld.com>
To: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: nfs3 problem with -rc{2,3}
Message-ID: <20120618221052.GA18341@milliways>
References: <20120617200700.GA15348@milliways>
 <1340026956.2451.9.camel@lade.trondhjem.org>
 <1340027134.2451.12.camel@lade.trondhjem.org>
 <20120618141854.GA7962@milliways>
 <1340031234.2451.13.camel@lade.trondhjem.org>
 <20120618160005.GA10169@milliways>
 <20120618200525.GA15654@milliways>
 <20120618215323.GA17561@milliways>
 <1340057002.20570.31.camel@lade.trondhjem.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1340057002.20570.31.camel@lade.trondhjem.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Cloudmark-Analysis: v=1.1 cv=R50lirqlHffDPPkwUlkuVa99MrvKdVWo//yz83qex8g= c=1 sm=0 a=wom5GMh1gUkA:10 a=IxJ0d4kOqokA:10 a=uObrxnre4hsA:10 a=IkcTkHD0fZMA:10 a=yOP717waBBROScAMR_cA:9 a=QEXdDO2ut3YA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 18, 2012 at 10:03:24PM +0000, Myklebust, Trond wrote:
> On Mon, 2012-06-18 at 22:53 +0100, Ken Moffat wrote:
> > On Mon, Jun 18, 2012 at 09:05:25PM +0100, Ken Moffat wrote:
> > > 
> > >  I suppose I'll have to enable v4 in my configs.
> > > 
> >  Just to confirm, -rc3 with CONFIG_NFS_V4 added to my original
> > .config appears to work fine on nfs v3.
> > 
> >  I suppose I could apply 4f97615d19c370d1d907ef37f8bcd9c3672851ca on
> > top of the conmits which failed to compile without v4, if it is worth
> > investigating this ?  It certainly fixes the error in fs/nfs/read.c,
> > but I also had:
> > 
> > fs/nfs/direct.c:86:29: error: field ‘ds_cinfo’ has incomplete type
> > 
> >  in 3e9e0ca3 which would still prevent me testing at least some of
> > these commits.  Seems to have been fixed *somewhere* in that series,
> > otherwise 4f97615d would not have compiled.  Any suggestions for
> > that ?  Alternatively would it be useful if I discovered which
> > commits are affected for ds_cinfo, or should I just follow the good
> > Dr.Pangloss and add V4 to my config ? ;-)
> 
> Doesn't 4f97615d19 fix the fs/nfs/direct.c problem too? It should.
> 
> Anyhow, if you can apply that on top of the commits that didn't compile,
> and then continue the bisection, that would be great. We definitely do
> want the !defined(CONFIG_NFS_V4) case to work in 3.5-final...
> 
 OK (I was assuming errors in different places were from different
causes).  I'll do that after I've rerun rc3 without NFS_V4 with
SUNRPC_DEBUG.  Thanks.

ĸen
-- 
das eine Mal als Tragödie, das andere Mal als Farce
