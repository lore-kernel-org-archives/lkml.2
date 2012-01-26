Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753186Ab2AZQ7R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 11:59:17 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:1405 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753134Ab2AZQ7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 11:59:16 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 26 Jan 2012 08:58:32 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Felipe Balbi <balbi@ti.com>,
        "David Gibson (david@gibson.dropbear.id.au)" 
	<david@gibson.dropbear.id.au>,
        "jdl@jdl.com" <jdl@jdl.com>
CC: "mmarek@suse.cz" <mmarek@suse.cz>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
Date: Thu, 26 Jan 2012 08:58:31 -0800
Subject: RE: [PATCH] scripts: dtc: fix compile warnings
Thread-Topic: [PATCH] scripts: dtc: fix compile warnings
Thread-Index: AczcHHx0AYQG9lJkRvCOSsJbxRKw/QALw4FQ
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF178CB8233B@HQMAIL01.nvidia.com>
References: <1327576807-19216-1-git-send-email-balbi@ti.com>
In-Reply-To: <1327576807-19216-1-git-send-email-balbi@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q0QGxOLA012686

Felipe Balbi wrote at Thursday, January 26, 2012 4:20 AM:
> Fix following compile warnings:
> 
> scripts/dtc/flattree.c: In function â€˜flat_read_mem_reserveâ€™:
> scripts/dtc/flattree.c:700:14: warning: variable â€˜pâ€™ set but not used
> 	[-Wunused-but-set-variable]
> 
> scripts/dtc/dtc.c: In function â€˜mainâ€™:
> scripts/dtc/dtc.c:104:17: warning: variable â€˜checkâ€™ set but not used
> 	[-Wunused-but-set-variable]
> 
> Signed-off-by: Felipe Balbi <balbi@ti.com>

I think you want to send this to the upstream dtc maintainers; I've CC'd
them on this mail.

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

-- 
nvpublic

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
