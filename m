Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750948Ab2INEDQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 00:03:16 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:29269 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769Ab2INEDO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 00:03:14 -0400
X-AuditID: cbfee61b-b7f826d000005fb5-ed-5052ac8135e6
From: kgene@kernel.org
To: "'Julia Lawall'" <Julia.Lawall@lip6.fr>,
        "'Ben Dooks'" <ben-linux@fluff.org>
Cc: kernel-janitors@vger.kernel.org, "'Russell King'" <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1347478135-744-1-git-send-email-Julia.Lawall@lip6.fr>
In-reply-to: <1347478135-744-1-git-send-email-Julia.Lawall@lip6.fr>
Subject: RE: [PATCH] arch/arm/mach-s3c24xx/mach-h1940.c: delete double
 assignment
Date: Fri, 14 Sep 2012 13:03:12 +0900
Message-id: <01a201cd922d$dc49a550$94dceff0$@org>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac2RHOAw1W2JFnMSToSCaF5aI0q3GQAZZx6w
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrELMWRmVeSWpSXmKPExsVy+t9jQd3GNUEBBkvu8FtsvSVtcXnXHDaL
	Gef3MTkwe3zeJBfAGMVlk5Kak1mWWqRvl8CVcefvPPaCGZwVO/YdZGlgXM7excjJISFgInHi
	6A9GCFtM4sK99WxdjFwcQgLTGSUOrG2Fcv4ySnS+v8LcxcjBwQZUNfWJNEiDsICWxMItTSwg
	toiAj8Stw++YQOqZBbYzSjy9u4gZJCEk4CQx+1oj2AZOAWeJf/cOskA0B0tc29UCdgWLgKrE
	0Re3mUBsXgFDietb17JC2IISPybfA6tnBlq2fudxJghbXmLzmrdg90gIqEs8+qsLcYORxO2z
	l6HKRST2vXjHOIFReBaSSbOQTJqFZNIsJC0LGFlWMYqmFiQXFCel5xrpFSfmFpfmpesl5+du
	YgSH/DPpHYyrGiwOMQpwMCrx8EawBgUIsSaWFVfmHmKU4GBWEuG11QYK8aYkVlalFuXHF5Xm
	pBYfYpTmYFES5xX+FBggJJCeWJKanZpakFoEk2Xi4JRqYNT/WavgZzS/2LX+vIO17t5viyy6
	Dl4ULtwqUn9jfejpL9Urp/ExKz0qmXSCjdF0Jff22QxP7ZtC2pd2zMv07pFM7e0y3jS3aEbN
	qy0vlVgO7DDfUW7BlOrTFPVtIrtSoGX2252vJZYfEGjp2XDjtvq55q1tvjdjWR4WWV6xr9Nq
	ZHjbf/nXdCWW4oxEQy3mouJEAIJ1D6N1AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Julia Lawall wrote:
> 
> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> Delete successive assignments to the same location.
> 
> A simplified version of the semantic match that finds this problem is as
> follows: (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @@
> expression i;
> @@
> 
> *i = ...;
>  i = ...;
> // </smpl>
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> ---
> Not compiled, and this may change the behavior of the code.  Without this
> change, check_gpio2 could possibly be used uninitialized later.
> 
>  arch/arm/mach-s3c24xx/mach-h1940.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm/mach-s3c24xx/mach-h1940.c b/arch/arm/mach-
> s3c24xx/mach-h1940.c
> index bb8d008..477778c 100644
> --- a/arch/arm/mach-s3c24xx/mach-h1940.c
> +++ b/arch/arm/mach-s3c24xx/mach-h1940.c
> @@ -380,7 +380,7 @@ int h1940_led_blink_set(unsigned gpio, int state,
>  	default:
>  		blink_gpio = S3C2410_GPA(3);
>  		check_gpio1 = S3C2410_GPA(1);
> -		check_gpio1 = S3C2410_GPA(7);
> +		check_gpio2 = S3C2410_GPA(7);
>  		break;
>  	}
> 
Applied, thanks.

K-Gene <kgene@kernel.org>

