Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754870Ab1GKUSR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 16:18:17 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:27762 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753977Ab1GKUSQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 16:18:16 -0400
Date: Mon, 11 Jul 2011 22:18:14 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: David Teigland <teigland@redhat.com>
cc: linux-kernel@vger.kernel.org, cluster-devel@redhat.com,
        Christine Caulfield <ccaulfie@redhat.com>,
        "Dr. David Alan Gilbert" <linux@treblig.org>
Subject: Re: [PATCH v3] fs, dlm: don't do pointless NULL check, use kzalloc
 and fix order of arguments
In-Reply-To: <20110711150233.GC14426@redhat.com>
Message-ID: <alpine.LNX.2.00.1107112217440.10944@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1107021957130.16316@swampdragon.chaosbits.net> <alpine.LNX.2.00.1107102252510.2818@swampdragon.chaosbits.net> <20110711150233.GC14426@redhat.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Jul 2011, David Teigland wrote:

> On Sun, Jul 10, 2011 at 10:54:31PM +0200, Jesper Juhl wrote:
> > In fs/dlm/lock.c in the dlm_scan_waiters() function there are 3 small
> > issues:
> > 
> > 1) There's no need to test the return value of the allocation and do a
> > memset if is succeedes. Just use kzalloc() to obtain zeroed memory.
> > 
> > 2) Since kfree() handles NULL pointers gracefully, the test of
> > 'warned' against NULL before the kfree() after the loop is completely
> > pointless. Remove it.
> > 
> > 3) The arguments to kmalloc() (now kzalloc()) were swapped. Thanks to
> > Dr. David Alan Gilbert for pointing this out.
> > 
> > Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> 
> Thanks, I pushed this and a patch for the other swapped kmalloc to the
> next branch.
> Dave
> 
Ok, thanks, then I won't bother updating my patch with that other kmalloc.

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

