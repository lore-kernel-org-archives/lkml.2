Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754578Ab2CYAiI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2012 20:38:08 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40104 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753338Ab2CYAiG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2012 20:38:06 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] scripts: dtc: fix compile warnings
To: Felipe Balbi <balbi@ti.com>, swarren@nvidia.com
Cc: mmarek@suse.cz, devicetree-discuss@lists.ozlabs.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>
In-Reply-To: <1327576807-19216-1-git-send-email-balbi@ti.com>
References: <1327576807-19216-1-git-send-email-balbi@ti.com>
Date: Sat, 24 Mar 2012 17:38:03 -0700
Message-Id: <20120325003803.225FE3E0140@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Jan 2012 13:20:07 +0200, Felipe Balbi <balbi@ti.com> wrote:
> Fix following compile warnings:
> 
> scripts/dtc/flattree.c: In function ‘flat_read_mem_reserve’:
> scripts/dtc/flattree.c:700:14: warning: variable ‘p’ set but not used
> 	[-Wunused-but-set-variable]
> 
> scripts/dtc/dtc.c: In function ‘main’:
> scripts/dtc/dtc.c:104:17: warning: variable ‘check’ set but not used
> 	[-Wunused-but-set-variable]
> 
> Signed-off-by: Felipe Balbi <balbi@ti.com>

Need to instead update dtc to the latest sources from the upstream dtc
repository.  I've not had time to do it; would you like to take a
look?

g.

> ---
>  scripts/dtc/dtc.c      |    5 +----
>  scripts/dtc/flattree.c |    2 --
>  2 files changed, 1 insertions(+), 6 deletions(-)
> 
> diff --git a/scripts/dtc/dtc.c b/scripts/dtc/dtc.c
> index 451c92d..2ef5e2e 100644
> --- a/scripts/dtc/dtc.c
> +++ b/scripts/dtc/dtc.c
> @@ -101,7 +101,7 @@ int main(int argc, char *argv[])
>  	const char *outform = "dts";
>  	const char *outname = "-";
>  	const char *depname = NULL;
> -	int force = 0, check = 0, sort = 0;
> +	int force = 0, sort = 0;
>  	const char *arg;
>  	int opt;
>  	FILE *outf = NULL;
> @@ -143,9 +143,6 @@ int main(int argc, char *argv[])
>  		case 'f':
>  			force = 1;
>  			break;
> -		case 'c':
> -			check = 1;
> -			break;
>  		case 'q':
>  			quiet++;
>  			break;
> diff --git a/scripts/dtc/flattree.c b/scripts/dtc/flattree.c
> index ead0332..28d0b23 100644
> --- a/scripts/dtc/flattree.c
> +++ b/scripts/dtc/flattree.c
> @@ -697,7 +697,6 @@ static struct reserve_info *flat_read_mem_reserve(struct inbuf *inb)
>  {
>  	struct reserve_info *reservelist = NULL;
>  	struct reserve_info *new;
> -	const char *p;
>  	struct fdt_reserve_entry re;
>  
>  	/*
> @@ -706,7 +705,6 @@ static struct reserve_info *flat_read_mem_reserve(struct inbuf *inb)
>  	 *
>  	 * First pass, count entries.
>  	 */
> -	p = inb->ptr;
>  	while (1) {
>  		flat_read_chunk(inb, &re, sizeof(re));
>  		re.address  = fdt64_to_cpu(re.address);
> -- 
> 1.7.8.2
> 
> _______________________________________________
> devicetree-discuss mailing list
> devicetree-discuss@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/devicetree-discuss

-- 
Grant Likely, B.Sc, P.Eng.
Secret Lab Technologies,Ltd.
