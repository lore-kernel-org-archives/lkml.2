Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935586Ab2JXUlS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 16:41:18 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:44002 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934471Ab2JXUlR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 16:41:17 -0400
Date: Thu, 25 Oct 2012 00:41:13 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Pavel Emelyanov <xemul@parallels.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH -mm] procfs: add VmFlags field in smaps output v3
Message-ID: <20121024204113.GZ30983@moon>
References: <20121024122730.GO30983@moon>
 <20121024133652.39ede022.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121024133652.39ede022.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2012 at 01:36:52PM -0700, Andrew Morton wrote:
> > ...
> >
> > +	for_each_set_bit(i, &vma->vm_flags, BITS_PER_LONG) {
> 
> for_each_set_bit() seems to be rather sucky.  Going back to 
> 
> --- a/fs/proc/task_mmu.c~a-fix
> +++ a/fs/proc/task_mmu.c
> @@ -568,10 +568,11 @@ static void show_smap_vma_flags(struct s
>  	size_t i;
>  
>  	seq_puts(m, "VmFlags: ");
> -	for_each_set_bit(i, &vma->vm_flags, BITS_PER_LONG) {
> -		seq_printf(m, "%c%c ",
> -			   mnemonics[i][0],
> -			   mnemonics[i][1]);
> +	for (i = 0; i < BITS_PER_LONG; i++) {
> +		if (vma->vm_flags & (1UL << i)) {
> +			seq_printf(m, "%c%c ",
> +				   mnemonics[i][0], mnemonics[i][1]);
> +		}
>  	}
>  	seq_putc(m, '\n');
>  }
> 
> saves 41 bytes.  That's rather a lot for such a small code sequence.

OK, bits-per-long is not a big value here, neither the function is time
critical one, so thanks!
