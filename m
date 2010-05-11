Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754894Ab0EKMbt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 08:31:49 -0400
Received: from www.tglx.de ([62.245.132.106]:36589 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752724Ab0EKMbr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 08:31:47 -0400
Date: Tue, 11 May 2010 14:30:24 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, tglx@linuxtronix.de,
       mingo@elte.hu, davem@davemloft.net, lethal@linux-sh.org
Subject: Re: [PATCH 05/25] lmb: Factor the lowest level alloc function
In-Reply-To: <1273484339-28911-6-git-send-email-benh@kernel.crashing.org>
Message-ID: <alpine.LFD.2.00.1005111428470.3401@localhost.localdomain>
References: <1273484339-28911-1-git-send-email-benh@kernel.crashing.org> <1273484339-28911-2-git-send-email-benh@kernel.crashing.org> <1273484339-28911-3-git-send-email-benh@kernel.crashing.org> <1273484339-28911-4-git-send-email-benh@kernel.crashing.org>
 <1273484339-28911-5-git-send-email-benh@kernel.crashing.org> <1273484339-28911-6-git-send-email-benh@kernel.crashing.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 May 2010, Benjamin Herrenschmidt wrote:
>  
> @@ -396,33 +406,24 @@ u64 __init __lmb_alloc_base(u64 size, u64 align, u64 max_addr)
>  	if (max_addr == LMB_ALLOC_ANYWHERE)
>  		max_addr = LMB_REAL_LIMIT;
>  
> +	/* Pump up max_addr */
> +	if (max_addr == LMB_ALLOC_ANYWHERE)
> +		max_addr = ~(u64)0;
> +	

  That if is pretty useless as you set max_addr to LMB_REAL_LIMIT
  right above.

Thanks,

	tglx
