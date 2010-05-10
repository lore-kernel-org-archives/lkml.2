Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753686Ab0EJPkS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 11:40:18 -0400
Received: from www.tglx.de ([62.245.132.106]:59570 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753102Ab0EJPkQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 11:40:16 -0400
Date: Mon, 10 May 2010 17:39:48 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, tglx@linuxtronix.de,
       mingo@elte.hu, davem@davemloft.net, lethal@linux-sh.org
Subject: Re: [PATCH 03/25] lmb: Introduce for_each_lmb() and new accessors,
 and use it
In-Reply-To: <1273484339-28911-4-git-send-email-benh@kernel.crashing.org>
Message-ID: <alpine.LFD.2.00.1005101735560.3401@localhost.localdomain>
References: <1273484339-28911-1-git-send-email-benh@kernel.crashing.org> <1273484339-28911-2-git-send-email-benh@kernel.crashing.org> <1273484339-28911-3-git-send-email-benh@kernel.crashing.org> <1273484339-28911-4-git-send-email-benh@kernel.crashing.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 May 2010, Benjamin Herrenschmidt wrote:
>  
> +#define for_each_lmb(lmb_type, region)					\
> +	for (reg = lmb.lmb_type.regions;				\
> +	     region < (lmb.lmb_type.regions + lmb.lmb_type.cnt);	\
> +	     region++)
> +

Can you please make this:

#define for_each_lmb(lmb_type, region, __iter)				\
	for (__iter = lmb.lmb_type.regions;				\
	     region < (lmb.lmb_type.regions + lmb.lmb_type.cnt);	\
	     region++)

so we do not have the iterator name hardcoded inside the macro body.

Thanks,

	tglx

