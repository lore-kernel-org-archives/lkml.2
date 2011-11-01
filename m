Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754565Ab1KAMlx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 08:41:53 -0400
Received: from mx01.sz.bfs.de ([194.94.69.103]:40840 "EHLO mx01.sz.bfs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754313Ab1KAMlw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 08:41:52 -0400
X-Greylist: delayed 557 seconds by postgrey-1.27 at vger.kernel.org; Tue, 01 Nov 2011 08:41:51 EDT
Message-ID: <4EAFE6DF.8030403@bfs.de>
Date: Tue, 01 Nov 2011 13:32:31 +0100
From: walter harms <wharms@bfs.de>
Reply-To: wharms@bfs.de
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; de; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
        "Mark A. Grondona" <mgrondona@llnl.gov>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [patch] edac: sb_edac: add sanity check to silence static checker
References: <20111101062852.GA19020@elgon.mountain>
In-Reply-To: <20111101062852.GA19020@elgon.mountain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Am 01.11.2011 07:28, schrieb Dan Carpenter:
> I assume the the check on if (limit <= prv) prevents n_tads from
> actually reaching MAX_TAD.  The problem with that is that it relies
> on the hardware returning the right value and Smatch complains that
> if it doesn't we could have a buffer overflow.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> Feel free to ignore this patch if you want.  I don't have very stong
> feelings about this either way.
> 
> diff --git a/drivers/edac/sb_edac.c b/drivers/edac/sb_edac.c
> index 7a402bf..ebf386c 100644
> --- a/drivers/edac/sb_edac.c
> +++ b/drivers/edac/sb_edac.c
> @@ -970,6 +970,12 @@ static int get_memory_error_data(struct mem_ctl_info *mci,
>  			break;
>  		prv = limit;
>  	}
> +	if (n_tads == MAX_TAD) {
> +		sprintf(msg, "Could not discover the memory channel");

why the sprintf() ? can you not simply:
	edac_mc_handle_ce_no_info(mci,"Could not discover the memory channel");
		
	re,
 	 wh
> +		edac_mc_handle_ce_no_info(mci, msg);
> +		return -EINVAL;
> +	}
> +
>  	ch_way = TAD_CH(reg) + 1;
>  	sck_way = TAD_SOCK(reg) + 1;
>  	/*
