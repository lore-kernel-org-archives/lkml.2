Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753802Ab2FSBGq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 21:06:46 -0400
Received: from mtaout01-winn.ispmail.ntl.com ([81.103.221.47]:39353 "EHLO
	mtaout01-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753492Ab2FSBGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 21:06:45 -0400
Date: Tue, 19 Jun 2012 02:06:41 +0100
From: Ken Moffat <zarniwhoop@ntlworld.com>
To: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: nfs3 problem with -rc{2,3} : blame
Message-ID: <20120619010641.GA22288@milliways>
References: <20120617200700.GA15348@milliways>
 <1340026956.2451.9.camel@lade.trondhjem.org>
 <1340027134.2451.12.camel@lade.trondhjem.org>
 <20120618141854.GA7962@milliways>
 <1340031234.2451.13.camel@lade.trondhjem.org>
 <20120618160005.GA10169@milliways>
 <20120618200525.GA15654@milliways>
 <20120618215323.GA17561@milliways>
 <1340057002.20570.31.camel@lade.trondhjem.org>
 <20120618221052.GA18341@milliways>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120618221052.GA18341@milliways>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Cloudmark-Analysis: v=1.1 cv=JvdXmxIgLJv2/GthKqHpGJEEHukvLcvELVXUanXFreg= c=1 sm=0 a=wom5GMh1gUkA:10 a=3oYqF3-p60YA:10 a=uObrxnre4hsA:10 a=IkcTkHD0fZMA:10 a=JDjsHSkAAAAA:8 a=LdyvC2AGxxKvA2f9IZgA:9 a=QEXdDO2ut3YA:10 a=Hf6muOzgCGQA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 18, 2012 at 11:10:52PM +0100, Ken Moffat wrote:
> On Mon, Jun 18, 2012 at 10:03:24PM +0000, Myklebust, Trond wrote:
> > 
> > Doesn't 4f97615d19 fix the fs/nfs/direct.c problem too? It should.
> > 
> > Anyhow, if you can apply that on top of the commits that didn't compile,
> > and then continue the bisection, that would be great. We definitely do
> > want the !defined(CONFIG_NFS_V4) case to work in 3.5-final...
> > 
>  OK (I was assuming errors in different places were from different
> causes).  I'll do that after I've rerun rc3 without NFS_V4 with
> SUNRPC_DEBUG.  Thanks.

Bisection now points to:

6d74743b088d116e31fe1b73f47e782ee2016b94 is the first bad commit
commit 6d74743b088d116e31fe1b73f47e782ee2016b94
Author: Trond Myklebust <Trond.Myklebust@netapp.com>
Date:   Mon Apr 30 13:27:31 2012 -0400

    NFS: Simplify O_DIRECT page referencing
    
    The O_DIRECT code shouldn't need to hold 2 references to each
page. The
    reference held by the struct nfs_page should suffice.
    
    Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
    Cc: Fred Isaman <iisaman@netapp.com>

 I was going to revert that from 3.5.0-rc3 to confirm that my
problem with backups was gone, and then give it more extended
testing to prove firefox downloads were ok, but 6 of 11 hunks
failed, the code has changed and I'm not familiar with it.

 So, for the moment I'm not 100% sure that this is indeed the
problem.

ĸen
-- 
das eine Mal als Tragödie, das andere Mal als Farce
