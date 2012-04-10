Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758279Ab2DJRg4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 13:36:56 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:26692 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758201Ab2DJRgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 13:36:53 -0400
X-Authority-Analysis: v=2.0 cv=P4S4d18u c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=aePz6BwZM4EA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=57SyGIRnAAAA:8 a=xN61-rc27NUIA-8W27EA:9 a=SigRJGNdTXJYITi8_uEA:7 a=PUjeQqilurYA:10 a=TIV7c6GJmisA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1334079411.23924.221.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 2/7] parse-events: Fix printk_cmp()
From: Steven Rostedt <rostedt@goodmis.org>
To: Namhyung Kim <namhyung.kim@lge.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Borislav Petkov <bp@alien8.de>, David Ahern <dsahern@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Tue, 10 Apr 2012 13:36:51 -0400
In-Reply-To: <1333940074-19052-3-git-send-email-namhyung.kim@lge.com>
References: <1333940074-19052-1-git-send-email-namhyung.kim@lge.com>
	 <1333940074-19052-3-git-send-email-namhyung.kim@lge.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-04-09 at 11:54 +0900, Namhyung Kim wrote:
> The printk_cmp function should use printk_map instead of func_map.
> Also rename the variables for consistency.
> 
> Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
> ---
>  parse-events.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/parse-events.c b/parse-events.c
> index 5214771..f90af1a 100644
> --- a/parse-events.c
> +++ b/parse-events.c
> @@ -507,12 +507,12 @@ struct printk_list {
>  
>  static int printk_cmp(const void *a, const void *b)
>  {
> -	const struct func_map *fa = a;
> -	const struct func_map *fb = b;
> +	const struct printk_map *pa = a;
> +	const struct printk_map *pb = b;
>  
> -	if (fa->addr < fb->addr)
> +	if (pa->addr < pb->addr)
>  		return -1;
> -	if (fa->addr > fb->addr)
> +	if (pa->addr > pb->addr)

Ouch! This worked only because the first item in both func_map and
printk_map happened to be addr (of the same size).

-- Steve

>  		return 1;
>  
>  	return 0;


