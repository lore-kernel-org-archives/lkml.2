Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752934Ab0L2NZU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Dec 2010 08:25:20 -0500
Received: from cantor.suse.de ([195.135.220.2]:49897 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752681Ab0L2NZT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Dec 2010 08:25:19 -0500
Date: Wed, 29 Dec 2010 14:25:17 +0100
From: Michal Marek <mmarek@suse.cz>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Jesper Juhl <jj@chaosbits.net>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] gen_init_cpio: Avoid race between call to stat() and
 call to open()
Message-ID: <20101229132517.GB15139@sepie.suse.cz>
References: <alpine.LNX.2.00.1012242125170.28973@swampdragon.chaosbits.net>
 <4D151FCC.4060202@pobox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D151FCC.4060202@pobox.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 24, 2010 at 05:33:48PM -0500, Jeff Garzik wrote:
> On 12/24/2010 03:28 PM, Jesper Juhl wrote:
> >Hi,
> >
> >In usr/gen_init_cpio.c::cpio_mkfile() a call to stat() is made based on
> >pathname, subsequently the file is open()'ed and then the value of the
> >initial stat() call is used to allocate a buffer. This is not safe since
> >the file may change between the call to stat() and the call to open().
> >Safer to just open() the file and then do fstat() using the filedescriptor
> >returned by open.
> >
> >
> >Signed-off-by: Jesper Juhl<jj@chaosbits.net>
> 
> Acked-by: Jeff Garzik <jgarzik@redhat.com>

Looks like an academic issue to me, but the kernel should promote good
programming practices :). Applied to kbuild-2.6.git#kbuild, thanks.

Michal
