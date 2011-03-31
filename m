Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759362Ab1CaVsx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 17:48:53 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36573 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759102Ab1CaVsw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 17:48:52 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: 2.6.38.2 breaks suspend to disk
Date: Thu, 31 Mar 2011 23:48:53 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.38+; KDE/4.6.0; x86_64; ; )
Cc: Michael Leun <lkml20101129@newton.leun.net>,
        Yinghai Lu <yinghai@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Greg Kroah-Hartman" <gregkh@suse.de>,
        Mike Pagano <mpagano@gentoo.org>
References: <20110330203215.0a1a41a7@xenia.leun.net> <20110331090524.07ad0069@xenia.leun.net> <alpine.DEB.2.00.1103311546480.16492@kaball-desktop>
In-Reply-To: <alpine.DEB.2.00.1103311546480.16492@kaball-desktop>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103312348.53678.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, March 31, 2011, Stefano Stabellini wrote:
> On Thu, 31 Mar 2011, Michael Leun wrote:
> > Nope, unfortunately this does not change anything (neither when
> > applying ontop of the tree resulting from bisecting, nor ontop
> > 2.6.38.2).
> > 
> > Just to make shure there was no mistake when bisecting I did
> > 
> > patch -R -p1 <~/linux-2.6.38.y.git-ff518ea26654e05d325d996f6e3a7f5f569cc2d5.txt
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

Acked-by: Rafael J. Wysocki <rjw@sisk.pl>

Peter, Ingo, please regard this as urgent, it breaks -stable.

Thanks,
Rafael


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
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 

