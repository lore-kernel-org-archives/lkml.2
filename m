Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751369Ab1KENeM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Nov 2011 09:34:12 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:61447 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750959Ab1KENeL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Nov 2011 09:34:11 -0400
Date: Sat, 5 Nov 2011 09:33:53 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: david.vrabel@citrix.com, davem@davemloft.net, axboe@kernel.dk,
        akpm@linux-foundation.org
Subject: Re: [GIT PULL] (xen) stable/vmalloc-3.2 for Linux 3.2-rc0
Message-ID: <20111105133352.GA4406@phenom.dumpdata.com>
References: <20111029191212.GA28939@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111029191212.GA28939@phenom.dumpdata.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4EB53B4A.009D,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 29, 2011 at 03:12:12PM -0400, Konrad Rzeszutek Wilk wrote:
> Hey Linus,
> 
> Please git pull the following git branch:
> 
> git pull git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen stable/vmalloc-3.2

Ping?

> 
> wherein:
> #stable/vmalloc-3.2 is based on git commit a102a9ece5489e1718cd7543aa079082450ac3a2
> (Linux 3.1-rc8): and it does three major things:
>  a). make the backend driver use the API provided by xenbus module instead of its
>      own handling (which was duplicated across backends),
>  b). removes dead code (ia64),
>  c). lays out the groundwork for removing the 'vmalloc_sync_all' patch
>      that was added in v3.1 as a bug-fix.
> 
> Note: The patches touch other maintainers trees and I've gotten
> Acks from them to do this as one patchset instead of cutting it in
> small pieces and parceling out.
> 
> Note2: The git history is a bit fresh (4 days old) in the branch b/c
> I've edited the git commits to add axboe and davem's Ack-by.
> 
> David Vrabel (3):
>       xen: use generic functions instead of xen_{alloc, free}_vm_area()
>       block: xen-blkback: use API provided by xenbus module to map rings
>       net: xen-netback: use API provided by xenbus module to map rings
> 
>  arch/ia64/include/asm/xen/grant_table.h |   29 -----------
>  arch/ia64/xen/grant-table.c             |   62 ------------------------
>  arch/x86/include/asm/xen/grant_table.h  |    7 ---
>  arch/x86/xen/grant-table.c              |    2 +-
>  drivers/block/xen-blkback/common.h      |    5 +--
>  drivers/block/xen-blkback/xenbus.c      |   54 +++------------------
>  drivers/net/xen-netback/common.h        |   11 ++--
>  drivers/net/xen-netback/netback.c       |   80 +++++++------------------------
>  drivers/xen/xenbus/xenbus_client.c      |    6 +-
>  include/xen/grant_table.h               |    1 -
>  10 files changed, 34 insertions(+), 223 deletions(-)


