Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964953Ab1CaQEu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 12:04:50 -0400
Received: from serv04.lahn.de ([213.239.197.57]:51694 "EHLO serv04.lahn.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964909Ab1CaQEt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 12:04:49 -0400
Date: Thu, 31 Mar 2011 17:53:55 +0200
From: Michael Leun <lkml20101129@newton.leun.net>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: Yinghai Lu <yinghai@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@suse.de>, Mike Pagano <mpagano@gentoo.org>
Subject: Re: 2.6.38.2 breaks suspend to disk
Message-ID: <20110331175355.5bdc03fd@xenia.leun.net>
In-Reply-To: <alpine.DEB.2.00.1103311546480.16492@kaball-desktop>
References: <20110330203215.0a1a41a7@xenia.leun.net>
	<4D940DD0.7000704@kernel.org>
	<20110331090524.07ad0069@xenia.leun.net>
	<alpine.DEB.2.00.1103311546480.16492@kaball-desktop>
Organization: Not Organized
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.1; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Mar 2011 15:48:44 +0100
Stefano Stabellini <stefano.stabellini@eu.citrix.com> wrote:

> On Thu, 31 Mar 2011, Michael Leun wrote:
> > Nope, unfortunately this does not change anything (neither when
> > applying ontop of the tree resulting from bisecting, nor ontop
> > 2.6.38.2).
> > 
> > Just to make shure there was no mistake when bisecting I did
> > 
> > patch -R -p1
> > <~/linux-2.6.38.y.git-ff518ea26654e05d325d996f6e3a7f5f569cc2d5.txt
> > 
> > and then indeed it worked again.
> 
> This patch fixes it for me.
> 
> 
> ---
> 
> save cr4 to mmu_cr4_features at boot time
> 
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> 
> diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
> index 5a0484a..0943eb2 100644
> --- a/arch/x86/kernel/setup.c
> +++ b/arch/x86/kernel/setup.c
> @@ -891,6 +891,7 @@ void __init setup_arch(char **cmdline_p)
>  		max_low_pfn = max_pfn;
>  
>  	high_memory = (void *)__va(max_pfn * PAGE_SIZE - 1) + 1;
> +	mmu_cr4_features = read_cr4();
>  #endif
>  
>  	/*
> 

Confirmed - fixes it for me too. Thanks.

-- 
MfG,

Michael Leun

