Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751559Ab1CPDu3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 23:50:29 -0400
Received: from eu1sys200aog113.obsmtp.com ([207.126.144.135]:34032 "EHLO
	eu1sys200aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750981Ab1CPDuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 23:50:25 -0400
Message-ID: <4D803353.7030004@st.com>
Date: Wed, 16 Mar 2011 09:19:39 +0530
From: viresh kumar <viresh.kumar@st.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Shiraz HASHIM <shiraz.hashim@st.com>
Subject: Re: [PATCH 02/13] plat-spear: use list_move() instead of list_del()/list_add()
 combination
References: <1300229605-14499-1-git-send-email-kirill@shutemov.name> <1300229605-14499-2-git-send-email-kirill@shutemov.name>
In-Reply-To: <1300229605-14499-2-git-send-email-kirill@shutemov.name>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/16/2011 04:23 AM, Kirill A. Shutemov wrote:
> Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
> Cc: Viresh Kumar <viresh.kumar@st.com>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: linux-arm-kernel@lists.infradead.org
> ---
>  arch/arm/plat-spear/clock.c |    4 +---
>  1 files changed, 1 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm/plat-spear/clock.c b/arch/arm/plat-spear/clock.c
> index ee4f90e..1d24faf 100644
> --- a/arch/arm/plat-spear/clock.c
> +++ b/arch/arm/plat-spear/clock.c
> @@ -267,9 +267,7 @@ static void change_parent(struct clk *cclk, struct clk *pclk)
>  	unsigned long flags;
>  
>  	spin_lock_irqsave(&clocks_lock, flags);
> -	list_del(&cclk->sibling);
> -	list_add(&cclk->sibling, &pclk->children);
> -
> +	list_move(&cclk->sibling, &pclk->children);
>  	cclk->pclk = pclk;
>  	spin_unlock_irqrestore(&clocks_lock, flags);
>  }

Acked-by: Viresh Kumar <viresh.kumar@st.com>

-- 
viresh
