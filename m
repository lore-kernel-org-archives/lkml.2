Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754111Ab0KNIZL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 03:25:11 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:46598 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753944Ab0KNIZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 03:25:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=DFDCNxcWnNJOot6Q8C9j9aaNuJQDq9KAczBBrl/A3PRjuCbbZuwwA3mGj1lA0TwoOI
         TqcoTtBEdk4LxGdQfAgZvpQEGKgeLaMlMNqnvjp5fIE/nbsUD1zfq764zmX28PLAz+XT
         0Eo2h/NVkoZ9wKi1HchMdK93VERgSryZ1gWEU=
Date: Sun, 14 Nov 2010 10:25:02 +0200
From: Mika Westerberg <mika.westerberg@iki.fi>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] ARM: memblock: convert reserve_crashkernel() to
	use memblock
Message-ID: <20101114082502.GA19331@gw.healthdatacare.com>
References: <cover.1289292124.git.mika.westerberg@iki.fi> <07f23b6e32b1ee64287dc53803890052df6546f3.1289292124.git.mika.westerberg@iki.fi> <20101113130700.GA26105@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101113130700.GA26105@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 13, 2010 at 01:07:00PM +0000, Russell King - ARM Linux wrote:
> On Tue, Nov 09, 2010 at 11:06:13AM +0200, Mika Westerberg wrote:
> >  static void __init reserve_crashkernel(void)
> >  {
> >  	unsigned long long crash_size, crash_base;
> > -	unsigned long long total_mem;
> >  	int ret;
> >  
> > -	total_mem = get_total_mem();
> > -	ret = parse_crashkernel(boot_command_line, total_mem,
> > +	/* this is necessary because of memblock_phys_mem_size() */
> > +	memblock_analyze();
> 
> I think you need to check with the memblock people whether its legal to
> call memblock_analyze() multiple times.  What do other arches do for
> this?

At least powerpc and sh do it like the above.

> Secondly, when paging_init() returns, bootmem has been initialized, and
> memory taken from bootmem to feed the zone allocators.  This memory is
> not registered back into memblock.  Allocations from memblock after
> paging_init() has returned will lead to overlaps with bootmem, and
> therefore corruption.

Ok.

> So, this code is better off left as-is, rather than trying to convert it
> to what mistakenly appears "the latest thing".

Yeah, sounds like it wasn't such a good idea. Please ignore this
patch then.

Thanks,
MW
