Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753560Ab1ATR5T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 12:57:19 -0500
Received: from smtp103.prem.mail.ac4.yahoo.com ([76.13.13.42]:28326 "HELO
	smtp103.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753256Ab1ATR5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 12:57:18 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: gkKHwsMVM1m7XZH3g48AQkKGEjIDho66CrsVz_jZkFz4oP7
 MkwA68DPdamu_l7lEPgnNolOKZdb9ZCrv88WUI2EOinkH5JMQr7dSCdvzH_G
 AA5P6kfjmhEsseSLOAaE2REErUMsz6OxpUqn2gBgUSKakng2jrnUbtopESPH
 uR0CEI5mZJdloirgQhbzd7DMNFat0GtVQPEZa4HXgkIIRBkdLWdaFbJqOv_d
 V73nijLwS2n_nEkoe3jBcsA2ZGliI3DLKrEDQ
X-Yahoo-Newman-Property: ymail-3
Date: Thu, 20 Jan 2011 11:30:35 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Minchan Kim <minchan.kim@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Mel Gorman <mel@csn.ul.ie>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH 1/3] When migrate_pages returns 0, all pages must have
 been released
In-Reply-To: <f60d811fd1abcb68d40ac19af35881d700a97cd2.1295539829.git.minchan.kim@gmail.com>
Message-ID: <alpine.DEB.2.00.1101201130100.10695@router.home>
References: <f60d811fd1abcb68d40ac19af35881d700a97cd2.1295539829.git.minchan.kim@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Jan 2011, Minchan Kim wrote:

> diff --git a/mm/migrate.c b/mm/migrate.c
> index 46fe8cc..7d34237 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -772,6 +772,7 @@ uncharge:
>  unlock:
>  	unlock_page(page);
>
> +move_newpage:
>  	if (rc != -EAGAIN) {
>   		/*
>   		 * A page that has been migrated has all references
> @@ -785,8 +786,6 @@ unlock:
>  		putback_lru_page(page);
>  	}
>
> -move_newpage:
> -
>  	/*
>  	 * Move the new page to the LRU. If migration was not successful
>  	 * then this will free the page.
>

What does this do? Not covered by the description.


