Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753617Ab1C2O4u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 10:56:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12765 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750846Ab1C2O4s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 10:56:48 -0400
Message-ID: <4D91F31A.7040600@redhat.com>
Date: Tue, 29 Mar 2011 11:56:26 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Red Hat/3.1.7-3.el6_0 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [PATCH 05/30] amd64_edac: Cleanup chipselect handling
References: <1297358133-14320-1-git-send-email-bp@amd64.org> <1297358133-14320-6-git-send-email-bp@amd64.org>
In-Reply-To: <1297358133-14320-6-git-send-email-bp@amd64.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 10-02-2011 15:15, Borislav Petkov escreveu:
> From: Borislav Petkov <borislav.petkov@amd.com>
> 
> Add a struct representing the DRAM chip select base/limit register
> pairs. Concentrate all CS handling in a single function. Also, add CS
> looping macros for cleaner, more readable code. While at it, adjust code
> to F15h. Finally, do smaller macro names cleanups (remove family names
> from register macros) and debug messages clarification.
> 
> No functional change.
> 
> Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>

Hi Borislav,

> --- a/drivers/edac/amd64_edac.h
> +++ b/drivers/edac/amd64_edac.h
> @@ -160,6 +160,14 @@
>  #define OFF false
>  
>  /*
> + * Create a contiguous bitmask starting at bit position @lo and ending at
> + * position @hi. For example
> + *
> + * GENMASK(21, 39) gives us the 64bit vector 0x000000ffffe00000.
> + */
> +#define GENMASK(lo, hi)			(((1ULL << ((hi) - (lo) + 1)) - 1) << (lo))
> +

This is a nice macro that could be useful outside amd64. It is probably a good
idea to move it to include/linux/bitops.h.

Cheers,
Mauro.
