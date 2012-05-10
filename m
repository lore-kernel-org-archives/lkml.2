Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754434Ab2EJCqO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 22:46:14 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:53350 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754179Ab2EJCqN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 22:46:13 -0400
Message-ID: <1336617972.1905.22.camel@joe2Laptop>
Subject: Re: [PATCH RESEND 1/3] printk: convert byte-buffer to
 variable-length record buffer
From: Joe Perches <joe@perches.com>
To: Kay Sievers <kay@vrfy.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
        Sasha Levin <levinsasha928@gmail.com>,
        Greg Kroah-Hartmann <greg@kroah.com>, linux-kernel@vger.kernel.org
Date: Wed, 09 May 2012 19:46:12 -0700
In-Reply-To: <1336617173.25027.4.camel@mop>
References: <1336004953.4240.9.camel@mop>
	 <CA+1xoqdCk9FcqdLEvwgHtfrauNh=s0dDwcpaJimMC_H83N=_5w@mail.gmail.com>
	 <1336475689.1179.12.camel@mop>
	 <CA+55aFwbQTq_f7p2j-eu8-hVpiZ1Uf2MCU7R+DDWHimiVbcScg@mail.gmail.com>
	 <CA+1xoqcAjEh5LT42NpjoE0998KUecY6EWQp4FM0_CY8MPyLmbQ@mail.gmail.com>
	 <CA+55aFzVs0GLpNVUBHtLRuc8uQc=WKd8ajeVWsffbNvxSQvB4Q@mail.gmail.com>
	 <CA+55aFzgXzFs9z-5ViQ4=4hhtOtK=CBHGxNX_dsXQV9mn1qANg@mail.gmail.com>
	 <20120509070710.GA29981@gmail.com>
	 <CAPXgP11evyQQKNDaa00R7qsOFy5Xk-utN1w9OgB4y6NxLZG=UA@mail.gmail.com>
	 <1336611278.728.9.camel@mop>
	 <CA+55aFyrrH0jJV--L=ugt0YK7pT+jmhjvt_WRWyenyiroN97zg@mail.gmail.com>
	 <1336617173.25027.4.camel@mop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-10 at 04:32 +0200, Kay Sievers wrote:
> --- a/kernel/printk.c
[]
> @@ -1295,20 +1296,16 @@ asmlinkage int vprintk_emit(int facility
>  		case '0' ... '7':
>  			if (level == -1)
>  				level = text[1] - '0';
> -			text += 3;
> -			textlen -= 3;
> -			break;
> -		case 'c':	/* KERN_CONT */
> -			cont = true;
>  		case 'd':	/* KERN_DEFAULT */
> +			prefix = true;
> +		case 'c':	/* KERN_CONT */

trivia:

Please add /* fallthrough */ comment lines
so it shows the "missing" breaks are intentional.


