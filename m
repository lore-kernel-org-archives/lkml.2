Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756669Ab0J0GH5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 02:07:57 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:65001 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752713Ab0J0GHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 02:07:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=HuTl6WLuqfU6HVZn2sR3QvPnLdjEhgo2E3oXUIPpp1elt6VdHs4+YVybbSVWvhaXx4
         65sDfQeywYZ2scAwZ9FbK3YGBVBvS3Hwa0/LYGSES/VFFT4eSX1hcQRTEaEOMm46lBZM
         pVlIxDs+Lhb6lqhS2vp+UJMNYO7p+Juh1Bq4M=
Subject: Re: [PATCH] x86-32: Allocate irq stacks seperate from percpu area
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Brian Gerst <brgerst@gmail.com>
Cc: tj@kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, mingo@elte.hu
In-Reply-To: <1288158182-1753-1-git-send-email-brgerst@gmail.com>
References: <AANLkTinnc3vBSmewf7ixuOSDYxG+5VNiGaB-vSrDNRiO@mail.gmail.com>
	 <1288158182-1753-1-git-send-email-brgerst@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 27 Oct 2010 08:07:50 +0200
Message-ID: <1288159670.2652.181.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 27 octobre 2010 à 01:43 -0400, Brian Gerst a écrit :
> The percpu allocator cannot handle alignments larger than one page.
> Allocate the irq stacks seperately, and only keep the pointers as
> percpu data.
> 
> Signed-off-by: Brian Gerst <brgerst@gmail.com>

>  
> -	irqctx = &per_cpu(hardirq_stack, cpu);
> +	irqctx = (union irq_ctx *)__get_free_pages(THREAD_FLAGS, THREAD_ORDER);

Hmm, then we lose NUMA affinity for stacks.



