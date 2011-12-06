Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932933Ab1LFELK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 23:11:10 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:48757 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932877Ab1LFELI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 23:11:08 -0500
Date: Mon, 5 Dec 2011 23:11:03 -0500 (EST)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
cc: Tejun Heo <tj@kernel.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Russell King <rmk@arm.linux.org.uk>
Subject: Re: linux-next: manual merge of the memblock tree with the arm
 tree
In-Reply-To: <20111206141816.628d9fc4ab58e23eb9fc63f0@canb.auug.org.au>
Message-ID: <alpine.LFD.2.02.1112052310160.2357@xanadu.home>
References: <20111206141816.628d9fc4ab58e23eb9fc63f0@canb.auug.org.au>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Dec 2011, Stephen Rothwell wrote:

> Hi Tejun,
> 
> [Tejun, I know you told me about these, but I am reporting them anyway
> just for completeness.]
> 
> Today's linux-next merge of the memblock tree got a conflict in
> arch/arm/mm/init.c between commit 27a3f0e91bed ("ARM: sort the meminfo
> array earlier") from the arm tree and commit 0dac7e2d90aa ("memblock:
> Kill memblock_init()") from the memblock tree.
> 
> Just context changes.  I fixed it up (see below) and can carry the fix as
> necessary.

The fix looks trivially correct.


> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> 
> diff --cc arch/arm/mm/init.c
> index 786addd,7c38474..0000000
> --- a/arch/arm/mm/init.c
> +++ b/arch/arm/mm/init.c
> @@@ -310,7 -331,8 +311,6 @@@ void __init arm_memblock_init(struct me
>   {
>   	int i;
>   
> - 	memblock_init();
>  -	sort(&meminfo.bank, meminfo.nr_banks, sizeof(meminfo.bank[0]), meminfo_cmp, NULL);
>  -
>   	for (i = 0; i < mi->nr_banks; i++)
>   		memblock_add(mi->bank[i].start, mi->bank[i].size);
>   
> 
