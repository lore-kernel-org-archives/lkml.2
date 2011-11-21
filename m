Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755900Ab1KURAi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 12:00:38 -0500
Received: from mx01.sz.bfs.de ([194.94.69.103]:24074 "EHLO mx01.sz.bfs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751842Ab1KURAh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 12:00:37 -0500
Message-ID: <4ECA83B3.6040000@bfs.de>
Date: Mon, 21 Nov 2011 18:00:35 +0100
From: walter harms <wharms@bfs.de>
Reply-To: wharms@bfs.de
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; de; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Dmitry Kasatkin <dmitry.kasatkin@intel.com>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [patch] mpi/mpi-mpow: NULL dereference on allocation failure
References: <20111121145056.GB19092@elgon.mountain>
In-Reply-To: <20111121145056.GB19092@elgon.mountain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Am 21.11.2011 15:50, schrieb Dan Carpenter:
> We can't call mpi_free() on the elements if the first kzalloc() fails.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> diff --git a/lib/mpi/mpi-mpow.c b/lib/mpi/mpi-mpow.c
> index 4cc7593..7328d0d 100644
> --- a/lib/mpi/mpi-mpow.c
> +++ b/lib/mpi/mpi-mpow.c
> @@ -73,7 +73,7 @@ int mpi_mulpowm(MPI res, MPI *basearray, MPI *exparray, MPI m)
>  
>  	G = kzalloc((1 << k) * sizeof *G, GFP_KERNEL);
>  	if (!G)
> -		goto nomem;
> +		goto err_out;
>  
>  	/* and calculate */
>  	tmp = mpi_alloc(mpi_get_nlimbs(m) + 1);
> @@ -129,5 +129,6 @@ nomem:
>  	for (i = 0; i < (1 << k); i++)
>  		mpi_free(G[i]);
>  	kfree(G);
> +err_out:
>  	return rc;
>  }

the patch is ok
but is there any reason *not* to use a more nice name that 'G'
something more descriptive perhaps ?

re,
 wh


