Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752940Ab2FRQAL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 12:00:11 -0400
Received: from mtaout01-winn.ispmail.ntl.com ([81.103.221.47]:27595 "EHLO
	mtaout01-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752390Ab2FRQAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 12:00:09 -0400
Date: Mon, 18 Jun 2012 17:00:05 +0100
From: Ken Moffat <zarniwhoop@ntlworld.com>
To: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: nfs3 problem with -rc{2,3}
Message-ID: <20120618160005.GA10169@milliways>
References: <20120617200700.GA15348@milliways>
 <1340026956.2451.9.camel@lade.trondhjem.org>
 <1340027134.2451.12.camel@lade.trondhjem.org>
 <20120618141854.GA7962@milliways>
 <1340031234.2451.13.camel@lade.trondhjem.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1340031234.2451.13.camel@lade.trondhjem.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Cloudmark-Analysis: v=1.1 cv=JvdXmxIgLJv2/GthKqHpGJEEHukvLcvELVXUanXFreg= c=1 sm=0 a=wom5GMh1gUkA:10 a=IxJ0d4kOqokA:10 a=uObrxnre4hsA:10 a=IkcTkHD0fZMA:10 a=P6JkxrBpAAAA:8 a=VwQbUJbxAAAA:8 a=wK9NL2YzwCEALBBK80wA:9 a=QEXdDO2ut3YA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 18, 2012 at 02:53:56PM +0000, Myklebust, Trond wrote:
> On Mon, 2012-06-18 at 15:18 +0100, Ken Moffat wrote:
> > On Mon, Jun 18, 2012 at 01:45:35PM +0000, Myklebust, Trond wrote:
> > > > 
> > > > Is this a problem with the client or with the server, and have you tried
> > > > seeing if the fixes that were merged into -rc3 help?
> > > 
> > > Doh... Ignore the second half of the above sentence. error=ENOCOFFEE.
> > > 
> > > I would still like to know whether this is a client or server issue
> > > (i.e. whether a downgrade of one or the other to 3.4 fixes the problem).
> > 
> >  It's the client - the server is still running 3.0.
> 
> OK. You said you had bisected this down to 15 patches? Can you please
> tell me which ones?
> 
 Here's the current log:
git bisect start
# bad: [cfaf025112d3856637ff34a767ef785ef5cf2ca9] Linux 3.5-rc2
git bisect bad cfaf025112d3856637ff34a767ef785ef5cf2ca9
# good: [76e10d158efb6d4516018846f60c2ab5501900bc] Linux 3.4
git bisect good 76e10d158efb6d4516018846f60c2ab5501900bc
# good: [3813d4024a75562baf77d3907fb6afbf8f9c8232] Merge tag
# 'ia64-3.5-merge' of git://git.kernel.or
g/pub/scm/linux/kernel/git/aegl/linux
git bisect good 3813d4024a75562baf77d3907fb6afbf8f9c8232
# good: [5723aa993d83803157c22327e90cd59e3dcbe879] x86: use the new
# generic strnlen_user() function
git bisect good 5723aa993d83803157c22327e90cd59e3dcbe879
# bad: [a70f35af4e49f87ba4b6c4b30220fbb66cd74af6] Merge branch
# 'for-3.5/drivers' of git://git.kernel.dk/linux-block
git bisect bad a70f35af4e49f87ba4b6c4b30220fbb66cd74af6
# bad: [53f2c4a8fd882009a2a75c5b72d6898c0808616e] Merge tag
# 'nfs-for-3.5-1' of
# git://git.linux-nfs.org/projects/trondmy/linux-nfs
git bisect bad 53f2c4a8fd882009a2a75c5b72d6898c0808616e
# good: [84a442b9a16ee69243ce7fce5d6f6f9c3fbdee68] Merge tag 'dt2'
# of git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc
git bisect good 84a442b9a16ee69243ce7fce5d6f6f9c3fbdee68
# bad: [cc0a98436820b161b595b8cc1d2329bcf7328107] NFSv4: Add
# debugging printks to state manager
git bisect bad cc0a98436820b161b595b8cc1d2329bcf7328107
# skip: [db8333519187d5974cf2ff33910c893bf8727d9f] NFS: Let mount
# data parsing set the NFS version
git bisect skip db8333519187d5974cf2ff33910c893bf8727d9f
# skip: [486aa699ffb6ec28adbc147326d62ac9294de8dc] NFS: Create a new
# nfs_try_mount()
git bisect skip 486aa699ffb6ec28adbc147326d62ac9294de8dc
# bad: [8d197a568fc337c66729b289c7fa0f28c14ba5ac] NFS: Always trust
# the PageUptodate flag when we have a delegation
git bisect bad 8d197a568fc337c66729b289c7fa0f28c14ba5ac
# skip: [1763da1234cba663b849476d451bdccac5147859] NFS: rewrite
# directio write to use async coalesce code
git bisect skip 1763da1234cba663b849476d451bdccac5147859
# skip: [df0117481cd94dbb8970f4be9d05b0568fa09ab1] NFS: Prevent
# garbage cinfo->ds from leaking out
git bisect skip df0117481cd94dbb8970f4be9d05b0568fa09ab1
# good: [6c75dc0d498caa402fb17b1bf769835a9db875c8] NFS: merge _full
# and _partial write rpc_ops
git bisect good 6c75dc0d498caa402fb17b1bf769835a9db875c8
# skip: [b58fee2189b17719c846f65ffe9483c2814e6605] NFS:
# pnfs_pageio_init_read() and init_write() need an extra argument
git bisect skip b58fee2189b17719c846f65ffe9483c2814e6605
# skip: [9533da2979757258d3fd5429d830a297013d69ed] NFS: remove
# unused wb_complete field from struct nfs_page
git bisect skip 9533da2979757258d3fd5429d830a297013d69ed
# skip: [2671bfc3beb44e70636bd0208274426db57f73b5] NFS: Remove
# secinfo knowledge out of the generic client
git bisect skip 2671bfc3beb44e70636bd0208274426db57f73b5
# skip: [1825a0d08f22463e5a8f4b1636473efd057a3479] NFS: prepare
# coalesce testing for directio
git bisect skip 1825a0d08f22463e5a8f4b1636473efd057a3479

 I'm just about to resume, to see if I can get anywhere - the rc2
version built fine, so I'm guessing that some more of the remaining
versions will also build.  Not sure which commits are still
outstanding.

ĸen
-- 
das eine Mal als Tragödie, das andere Mal als Farce
