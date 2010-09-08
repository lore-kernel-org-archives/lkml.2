Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755605Ab0IHVSp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 17:18:45 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:37412 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755388Ab0IHVSk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 17:18:40 -0400
Date: Wed, 8 Sep 2010 17:18:35 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
Cc: Kyle McMartin <kyle@mcmartin.ca>, Helge Deller <deller@gmx.de>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Akinobu Mita <akinobu.mita@gmail.com>, linux-parisc@vger.kernel.org,
        linux-kernel@vger.kernel.org, vamos-dev@i4.informatik.uni-erlangen.de
Subject: Re: [PATCH 03/14] arch/parisc: Removing undead ifdef CONFIG_PA20
Message-ID: <20100908211835.GG24791@bombadil.infradead.org>
References: <cover.1283782698.git.qy03fugy@stud.informatik.uni-erlangen.de>
 <27caeba6c5aeb0e5fffb339479ad1c87a1ec7ca3.1283782701.git.qy03fugy@stud.informatik.uni-erlangen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <27caeba6c5aeb0e5fffb339479ad1c87a1ec7ca3.1283782701.git.qy03fugy@stud.informatik.uni-erlangen.de>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 06, 2010 at 04:36:06PM +0200, Christian Dietrich wrote:
> The CONFIG_PA20 ifdef isn't necessary at this point, because it is
> checked in an outer ifdef level already and has no effect here.
> 

Looks good, applied, thanks.
-- Kyle

> Signed-off-by: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
> ---
>  arch/parisc/kernel/unaligned.c |    3 ---
>  1 files changed, 0 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/parisc/kernel/unaligned.c b/arch/parisc/kernel/unaligned.c
> index 92d977b..234e368 100644
> --- a/arch/parisc/kernel/unaligned.c
> +++ b/arch/parisc/kernel/unaligned.c
> @@ -619,15 +619,12 @@ void handle_unaligned(struct pt_regs *regs)
>  		flop=1;
>  		ret = emulate_std(regs, R2(regs->iir),1);
>  		break;
> -
> -#ifdef CONFIG_PA20
>  	case OPCODE_LDD_L:
>  		ret = emulate_ldd(regs, R2(regs->iir),0);
>  		break;
>  	case OPCODE_STD_L:
>  		ret = emulate_std(regs, R2(regs->iir),0);
>  		break;
> -#endif
>  	}
>  #endif
>  	switch (regs->iir & OPCODE3_MASK)
> -- 
> 1.7.0.4
> 
> 
