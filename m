Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756826Ab0KVSDJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 13:03:09 -0500
Received: from cantor.suse.de ([195.135.220.2]:53138 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756753Ab0KVSDD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 13:03:03 -0500
Date: Mon, 22 Nov 2010 09:59:09 -0800
From: Greg KH <gregkh@suse.de>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
        Ingo Molnar <mingo@elte.hu>, kexec@lists.infradead.org,
        Cliff Wickman <cpw@sgi.com>, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable-review@kernel.org,
        alan@lxorguk.ukuu.org.uk
Subject: Re: [Stable-review] [08/45] mm, x86: Saving vmcore with non-lazy
 freeing of vmas
Message-ID: <20101122175909.GB18867@suse.de>
References: <20101119214410.087440440@clark.site>
 <1290219372.3818.113.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290219372.3818.113.camel@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 20, 2010 at 02:16:12AM +0000, Ben Hutchings wrote:
> On Fri, 2010-11-19 at 13:42 -0800, Greg KH wrote:
> > 2.6.32-stable review patch.  If anyone has any objections, please let us know.
> > 
> > ------------------
> > 
> > From: Cliff Wickman <cpw@sgi.com>
> > 
> > commit 3ee48b6af49cf534ca2f481ecc484b156a41451d upstream.
> > 
> > During the reading of /proc/vmcore the kernel is doing
> > ioremap()/iounmap() repeatedly. And the buildup of un-flushed
> > vm_area_struct's is causing a great deal of overhead. (rb_next()
> > is chewing up most of that time).
> > 
> > This solution is to provide function set_iounmap_nonlazy(). It
> > causes a subsequent call to iounmap() to immediately purge the
> > vma area (with try_purge_vmap_area_lazy()).
> > 
> > With this patch we have seen the time for writing a 250MB
> > compressed dump drop from 71 seconds to 44 seconds.
> [...]
> 
> Useful, but it doesn't seem to meet the criteria for stable updates.

I disagree, it's a major speedup, and an obvious bugfix for the problem.

thanks,

greg k-h
