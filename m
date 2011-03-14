Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754109Ab1CNTDU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 15:03:20 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:57789 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752622Ab1CNTDT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 15:03:19 -0400
X-Authority-Analysis: v=1.1 cv=3uSaImBeuprzHBlOOPjkqgu+7PcxSRW0m2Aphm9Zmck= c=1 sm=0 a=iMvQkSxJFt0A:10 a=kj9zAlcOel0A:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=0azM3ZO7AAAA:8 a=LXL8el5rAAAA:8 a=VwQbUJbxAAAA:8 a=W0vUJOdyAAAA:8 a=7PSp9R2_uQSBB1YfzdYA:9 a=BilKzY3hmkxFlOOV5TMA:7 a=CUmyqJQIiDaEFd6xOh4KtYkLEvwA:4 a=CjuIK1q_8ugA:10 a=QWUP6kA11rEA:10 a=x8gzFH9gYPwA:10 a=BGWj8ct6lkoA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Date: Mon, 14 Mar 2011 15:03:17 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Jesper Juhl <jj@chaosbits.net>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH][rfc] Use int as return type of main in
 arch/x86/boot/main.c
Message-ID: <20110314190317.GA20259@home.goodmis.org>
References: <alpine.LNX.2.00.1103132257430.9985@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1103132257430.9985@swampdragon.chaosbits.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 13, 2011 at 11:00:09PM +0100, Jesper Juhl wrote:
> I believe the return type of main should always be 'int'.

But this is not userspace, it is called from assmebly in header.S:

 # Jump to C code (should not return)
 calll	main

We don't care what main returns. If it does return anything, then it
dies:

# Setup corrupt somehow...
setup_bad:
        movl    $setup_corrupt, %eax
        calll   puts
        # Fall through...

        .globl  die
        .type   die, @function
die:
        hlt
        jmp     die


-- Steve

> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> ---
>  main.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/boot/main.c b/arch/x86/boot/main.c
> index 40358c8..4b80da8 100644
> --- a/arch/x86/boot/main.c
> +++ b/arch/x86/boot/main.c
> @@ -125,7 +125,7 @@ static void init_heap(void)
>  	}
>  }
>  
> -void main(void)
> +int main(void)
>  {
>  	/* First, copy the boot header into the "zeropage" */
>  	copy_boot_params();
> @@ -175,4 +175,6 @@ void main(void)
>  
>  	/* Do the last things and invoke protected mode */
>  	go_to_protected_mode();
> +
> +	return 0;
>  }
> 
> 
> -- 
> Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
> Plain text mails only, please.
> Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
