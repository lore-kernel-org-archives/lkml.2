Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753743Ab2FKGQL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 02:16:11 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:50316 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127Ab2FKGQJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 02:16:09 -0400
X-AuditID: 9c930197-b7b5dae000004b23-30-4fd58d28a38e
Message-ID: <4FD58D28.2030808@kernel.org>
Date: Mon, 11 Jun 2012 15:16:08 +0900
From: Minchan Kim <minchan@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel.mm,gmane.linux.kernel
To: Sasha Levin <levinsasha928@gmail.com>
CC: dan.magenheimer@oracle.com, konrad.wilk@oracle.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 09/10] mm: frontswap: split out function to clear a
 page out
References: <1339325468-30614-1-git-send-email-levinsasha928@gmail.com> <1339325468-30614-10-git-send-email-levinsasha928@gmail.com>
In-Reply-To: <1339325468-30614-10-git-send-email-levinsasha928@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/10/2012 07:51 PM, Sasha Levin wrote:

> Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
> ---
>  mm/frontswap.c |   15 +++++++++------
>  1 files changed, 9 insertions(+), 6 deletions(-)
> 
> diff --git a/mm/frontswap.c b/mm/frontswap.c
> index 7da55a3..c056f6e 100644
> --- a/mm/frontswap.c
> +++ b/mm/frontswap.c
> @@ -120,6 +120,12 @@ void __frontswap_init(unsigned type)
>  }
>  EXPORT_SYMBOL(__frontswap_init);
>  
> +static inline void __frontswap_clear(struct swap_info_struct *sis, pgoff_t offset)
> +{
> +	frontswap_clear(sis, offset);
> +	atomic_dec(&sis->frontswap_pages);
> +}


Nipick:
Strange, Normally, NOT underscore function calls underscore function.
But this is opposite. :(

-- 
Kind regards,
Minchan Kim
