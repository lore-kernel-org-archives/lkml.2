Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754464Ab0KWOcr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 09:32:47 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:62855 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754390Ab0KWOcq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 09:32:46 -0500
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=5TQY8I8Kl2YA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=meVymXHHAAAA:8 a=9uamZqxSF9G24ghAwREA:9 a=wK7iuLBAKb91OBHKzHbYHNqAuwIA:4 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCHv2 1/2] ftrace: ignore any ftrace.o in C version of
 recordmcount
From: Steven Rostedt <rostedt@goodmis.org>
To: Rabin Vincent <rabin@rab.in>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        jreiser@BitWagon.com
In-Reply-To: <1290521691-5101-1-git-send-email-rabin@rab.in>
References: <1290454387.30543.304.camel@gandalf.stny.rr.com>
	 <1290521691-5101-1-git-send-email-rabin@rab.in>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 23 Nov 2010 09:32:45 -0500
Message-ID: <1290522765.30543.307.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do you want to push these through the arm tree. It may be easier that
way.

You can add my:

Acked-by: Steven Rostedt <rostedt@goodmis.org>

to both patches.

-- Steve


On Tue, 2010-11-23 at 19:44 +0530, Rabin Vincent wrote:
> arch/arm/kernel/ftrace.c references mcount like kernel/tracing/ftrace.c,
> so change the exclusion filter to match any ftrace.o.
> 
> Signed-off-by: Rabin Vincent <rabin@rab.in>
> ---
>  scripts/recordmcount.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/scripts/recordmcount.c b/scripts/recordmcount.c
> index f2f32ee..ac6e51c 100644
> --- a/scripts/recordmcount.c
> +++ b/scripts/recordmcount.c
> @@ -357,7 +357,7 @@ do_file(char const *const fname)
>  int
>  main(int argc, char const *argv[])
>  {
> -	const char ftrace[] = "kernel/trace/ftrace.o";
> +	const char ftrace[] = "/ftrace.o";
>  	int ftrace_size = sizeof(ftrace) - 1;
>  	int n_error = 0;  /* gcc-4.3.0 false positive complaint */
>  


