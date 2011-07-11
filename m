Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757852Ab1GKPCw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 11:02:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22431 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757769Ab1GKPCv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 11:02:51 -0400
Date: Mon, 11 Jul 2011 11:02:33 -0400
From: David Teigland <teigland@redhat.com>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-kernel@vger.kernel.org, cluster-devel@redhat.com,
        Christine Caulfield <ccaulfie@redhat.com>,
        "Dr. David Alan Gilbert" <linux@treblig.org>
Subject: Re: [PATCH v3] fs, dlm: don't do pointless NULL check, use kzalloc
 and fix order of arguments
Message-ID: <20110711150233.GC14426@redhat.com>
References: <alpine.LNX.2.00.1107021957130.16316@swampdragon.chaosbits.net>
 <alpine.LNX.2.00.1107102252510.2818@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1107102252510.2818@swampdragon.chaosbits.net>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 10, 2011 at 10:54:31PM +0200, Jesper Juhl wrote:
> In fs/dlm/lock.c in the dlm_scan_waiters() function there are 3 small
> issues:
> 
> 1) There's no need to test the return value of the allocation and do a
> memset if is succeedes. Just use kzalloc() to obtain zeroed memory.
> 
> 2) Since kfree() handles NULL pointers gracefully, the test of
> 'warned' against NULL before the kfree() after the loop is completely
> pointless. Remove it.
> 
> 3) The arguments to kmalloc() (now kzalloc()) were swapped. Thanks to
> Dr. David Alan Gilbert for pointing this out.
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>

Thanks, I pushed this and a patch for the other swapped kmalloc to the
next branch.
Dave

