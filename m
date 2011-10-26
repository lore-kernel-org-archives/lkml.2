Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933199Ab1JZN5O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 09:57:14 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:30741 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932247Ab1JZN5N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 09:57:13 -0400
Date: Wed, 26 Oct 2011 09:56:59 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: xen-devel@lists.xensource.com, david.vrabel@citrix.com
Subject: Re: [PATCH] MMU bug-fixes in generic code that are mostly used by
 Xen.
Message-ID: <20111026135659.GC31609@phenom.dumpdata.com>
References: <1319573279-13867-1-git-send-email-konrad.wilk@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1319573279-13867-1-git-send-email-konrad.wilk@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090206.4EA811B4.005C,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 25, 2011 at 04:07:56PM -0400, Konrad Rzeszutek Wilk wrote:
> I was wondering if you could help. I've this bug-fix:
>  [PATCH 1/3] x86/paravirt: PTE updates in k(un)map_atomic need to be
> 
> that you picked up some time ago in your tree and then dropped. I am not sure why it
> was dropped but perhaps it is b/c I also had that patch in my linux-next and your tool
> decided to drop it. Anyhow, was wondering if you would be OK giving it your
> Ack or just pulling it in your tree for 3.2.
> 
> These two:
>  [PATCH 2/3] xen: use generic functions instead of xen_{alloc,
>  [PATCH 3/3] xen: map foreign pages for shared rings by updating the
> 
> remove what git commit d2fe97c3315a6a406540f74651e7430d9d51e671
> 	Author: David Vrabel <david.vrabel@citrix.com>
> 	Date:   Thu Sep 29 16:53:32 2011 +0100
> 
> 	    xen: map foreign pages for shared rings by updating the PTEs directly
> 
> added in 3.1 with a more selective way instead of using the big hammer.
> 
> I was wondering if you would be OK ACK-ing those two or sticking them
> in your tree for 3.2.

Grrr.. Don't stick them in your tree. I forgot that they are dependent on two
other patches to both blkback and netback - otherwise compile errors gallore ensures.

I can:
 1). Stick the other two patches (blkback + netback) in my tree. And chase down the
     sub-maintainers to get an Ack for it to go through my tree (got one Ack already).
     And then stick these two patches on top of it (with your Ack of course).
 2). Get the other two patches in via the other maintainers and once they are in the
     Linus's tree, then ask for you to pull this one. This might take though lot 
     longer to orchestrate correctly.
 3). Ask you to pick all of those patches :-)
