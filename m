Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753463Ab2KTPVB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 10:21:01 -0500
Received: from [93.179.225.50] ([93.179.225.50]:48915 "EHLO shrek.podlesie.net"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751600Ab2KTPU7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 10:20:59 -0500
Date: Tue, 20 Nov 2012 16:20:55 +0100
From: Krzysztof Mazur <krzysiek@podlesie.net>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: Alan Cox <alan@linux.intel.com>, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: vt: regression caused by "Fix line garbage in virtual.."
Message-ID: <20121120152055.GA5684@shrek.podlesie.net>
References: <20121118110523.GA12094@shrek.podlesie.net>
 <20121119113828.5a66f112@bob.linux.org.uk>
 <20121119202149.46fc89c4@armhf>
 <20121119211553.GA29907@shrek.podlesie.net>
 <20121120095421.1d4dfa5e@armhf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121120095421.1d4dfa5e@armhf>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 20, 2012 at 09:54:21AM +0100, Jean-Francois Moine wrote:
> Thanks for testing. This time, the fix was easy.
> 
> But anyway, as it seems that my patch fixes only the Cubox machine and
> as we are still using a kernel 3.5 with specific patches, the fix may
> be delayed.
> 
> --->8 ---
> --- a/drivers/tty/vt/vt.c
> +++ b/drivers/tty/vt/vt.c
> @@ -539,25 +539,25 @@
>  {
>  	unsigned short *p = (unsigned short *) vc->vc_pos;
>  
> -	scr_memmovew(p + nr, p, vc->vc_cols - vc->vc_x);
> +	scr_memmovew(p + nr, p, (vc->vc_cols - vc->vc_x) * 2);
>  	scr_memsetw(p, vc->vc_video_erase_char, nr * 2);
>  	vc->vc_need_wrap = 0;
>  	if (DO_UPDATE(vc))
>  		do_update_region(vc, (unsigned long) p,
> -			(vc->vc_cols - vc->vc_x) / 2 + 1);
> +			vc->vc_cols - vc->vc_x);
>  }
>  
>  static void delete_char(struct vc_data *vc, unsigned int nr)
>  {
>  	unsigned short *p = (unsigned short *) vc->vc_pos;
>  
> -	scr_memcpyw(p, p + nr, vc->vc_cols - vc->vc_x - nr);
> +	scr_memcpyw(p, p + nr, (vc->vc_cols - vc->vc_x - nr) * 2);
>  	scr_memsetw(p + vc->vc_cols - vc->vc_x - nr, vc->vc_video_erase_char,
>  			nr * 2);
>  	vc->vc_need_wrap = 0;
>  	if (DO_UPDATE(vc))
>  		do_update_region(vc, (unsigned long) p,
> -			(vc->vc_cols - vc->vc_x) / 2);
> +			vc->vc_cols - vc->vc_x);
>  }
>  
>  static int softcursor_original;

Tested-by: Krzysztof Mazur <krzysiek@podlesie.net>

Thanks,

Krzysiek
