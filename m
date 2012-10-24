Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756242Ab2JXJYe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 05:24:34 -0400
Received: from casper.infradead.org ([85.118.1.10]:57637 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752516Ab2JXJYd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 05:24:33 -0400
Message-ID: <1351070644.13456.49.camel@twins>
Subject: Re: + procfs-add-vmflags-field-in-smaps-output-v3-fix-2.patch added
 to -mm tree
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: akpm@linux-foundation.org, xemul@parallels.com, sfr@canb.auug.org.au,
        LKML <linux-kernel@vger.kernel.org>
Date: Wed, 24 Oct 2012 11:24:04 +0200
In-Reply-To: <20121024084515.GB30983@moon>
References: <20121023220300.1185C200057@hpza10.eem.corp.google.com>
	 <20121024084515.GB30983@moon>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-10-24 at 12:45 +0400, Cyrill Gorcunov wrote:
>         for (i = 0; i < BITS_PER_LONG; i++) {
> -               if (vma->vm_flags & (1 << i))
> +               if (vma->vm_flags & (1ul << i)) {

	for_each_set_bit(i, &vma->vm_flags, BITS_PER_LONG) {

>                         seq_printf(m, "%c%c ",
>                                    mnemonics[i].l[0],
>                                    mnemonics[i].l[1]);
> +               }
>         } 
