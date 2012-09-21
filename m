Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756215Ab2IUHYJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 03:24:09 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:26951 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755333Ab2IUHYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 03:24:07 -0400
Date: Fri, 21 Sep 2012 10:23:59 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Zhenzhong Duan <zhenzhong.duan@oracle.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-mm@kvack.org, Dan Magenheimer <dan.magenheimer@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        levinsasha928@gmail.com, Feng Jin <joe.jin@oracle.com>
Subject: Re: mm: frontswap: fix a wrong if condition in frontswap_shrink
Message-ID: <20120921072359.GB13767@mwanda>
References: <505BDF34.3080905@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <505BDF34.3080905@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 21, 2012 at 11:29:56AM +0800, Zhenzhong Duan wrote:
> pages_to_unuse is set to 0 to unuse all frontswap pages
> But that doesn't happen since a wrong condition in frontswap_shrink
> cancels it.
> 
> Signed-off-by: Zhenzhong Duan <zhenzhong.duan@oracle.com>
> ---
>  mm/frontswap.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/frontswap.c b/mm/frontswap.c
> index 6b3e71a..db2a86f 100644
> --- a/mm/frontswap.c
> +++ b/mm/frontswap.c
> @@ -275,7 +275,7 @@ static int __frontswap_shrink(unsigned long target_pages,
>  	if (total_pages <= target_pages) {
>  		/* Nothing to do */
>  		*pages_to_unuse = 0;
> -		return 0;
> +		return 1;
>  	}

This function used to return 0 or an error code.  Could we add a
comment at the top saying what the return values mean.

regards,
dan carpenter

