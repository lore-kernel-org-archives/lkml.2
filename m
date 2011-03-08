Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756826Ab1CHXqZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 18:46:25 -0500
Received: from smtp12.ono.com ([62.42.230.20]:20909 "EHLO resmaa12.ono.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756473Ab1CHXqY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 18:46:24 -0500
X-Greylist: delayed 349 seconds by postgrey-1.27 at vger.kernel.org; Tue, 08 Mar 2011 18:46:24 EST
Date: Wed, 9 Mar 2011 00:40:33 +0100
From: JA =?ISO-8859-1?B?TWFnYWxs824=?= <jamagallon@ono.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] nfsd: wrong index used in inner loop
Message-ID: <20110309004033.54ff1945@werewolf.home>
In-Reply-To: <4D76A06A.4090405@gmail.com>
References: <4D76A06A.4090405@gmail.com>
X-Mailer: Claws Mail 3.7.8cvs57 (GTK+ 2.22.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 08 Mar 2011 22:32:26 +0100, roel <roel.kluin@gmail.com> wrote:

> Index i was already used in the outer loop
> 

Is this as serious as it looks ?
Is it worth tho flag your own loved distro to hurry on a kernel
patch ?

TIA

> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
>  fs/nfsd/nfs4xdr.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> Not 100% sure this one is needed but it looks suspicious.
> 
> diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
> index 1275b86..615f0a9 100644
> --- a/fs/nfsd/nfs4xdr.c
> +++ b/fs/nfsd/nfs4xdr.c
> @@ -1142,7 +1142,7 @@ nfsd4_decode_create_session(struct nfsd4_compoundargs *argp,
>  
>  	u32 dummy;
>  	char *machine_name;
> -	int i;
> +	int i, j;
>  	int nr_secflavs;
>  
>  	READ_BUF(16);
> @@ -1215,7 +1215,7 @@ nfsd4_decode_create_session(struct nfsd4_compoundargs *argp,
>  			READ_BUF(4);
>  			READ32(dummy);
>  			READ_BUF(dummy * 4);
> -			for (i = 0; i < dummy; ++i)
> +			for (j = 0; j < dummy; ++j)
>  				READ32(dummy);
>  			break;
>  		case RPC_AUTH_GSS:
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


-- 
J.A. Magallon <jamagallon()ono!com>     \               Software is like sex:
                                         \         It's better when it's free
