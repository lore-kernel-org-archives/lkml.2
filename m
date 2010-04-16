Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932537Ab0DPVTK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 17:19:10 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39683 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757887Ab0DPVTI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 17:19:08 -0400
Date: Fri, 16 Apr 2010 14:18:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>, Andreas Mohr <andi@lisas.de>,
       Jens Axboe <axboe@kernel.dk>, Minchan Kim <minchan.kim@gmail.com>,
       Linux Memory Management List <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Rik van Riel <riel@redhat.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Subject: Re: [PATCH] vmscan: page_check_references() check low order lumpy
 reclaim properly
Message-Id: <20100416141841.300d2361.akpm@linux-foundation.org>
In-Reply-To: <20100416115437.27AD.A69D9226@jp.fujitsu.com>
References: <20100415135031.D186.A69D9226@jp.fujitsu.com>
	<20100415051911.GA17110@localhost>
	<20100416115437.27AD.A69D9226@jp.fujitsu.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Apr 2010 12:16:18 +0900 (JST)
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> If vmscan is under lumpy reclaim mode, it have to ignore referenced bit
> for making contenious free pages. but current page_check_references()
> doesn't.
> 
> Fixes it.
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> ---
>  mm/vmscan.c |   32 +++++++++++++++++---------------
>  1 files changed, 17 insertions(+), 15 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 3ff3311..13d9546 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -77,6 +77,8 @@ struct scan_control {
>  
>  	int order;
>  
> +	int lumpy_reclaim;
> +

Needs a comment explaining its role, please.  Something like "direct
this reclaim run to perform lumpy reclaim"?

A clearer name might be "lumpy_relcaim_mode"?

Making it a `bool' would clarify things too.
