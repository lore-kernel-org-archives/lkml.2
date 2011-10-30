Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934249Ab1J3QnQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Oct 2011 12:43:16 -0400
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:60569 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755686Ab1J3QnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Oct 2011 12:43:14 -0400
Message-ID: <4EAD7E9F.6050709@xenotime.net>
Date: Sun, 30 Oct 2011 09:43:11 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [RESEND] media: tea5764: reconcile Kconfig symbol and
 macro
References: <1319976530.14409.17.camel@x61.thuisdomein>
In-Reply-To: <1319976530.14409.17.camel@x61.thuisdomein>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/30/11 05:08, Paul Bolle wrote:
> The Kconfig symbol RADIO_TEA5764_XTAL is unused. The code does use a
> RADIO_TEA5764_XTAL macro, but does that rather peculiar. But there seems
> to be a way to keep both. (The easiest way out would be to rip out both
> the Kconfig symbol and the macro.)
> 
> Note there's also a module parameter 'use_xtal' to influence all this.

It's curious that the module parameter is only available when the driver
is builtin (=y) but not built as a loadable module (=m):

config RADIO_TEA5764_XTAL
	bool "TEA5764 crystal reference"
	depends on RADIO_TEA5764=y
	default y

> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> I didn't dare to submit this a trivial patch. This is still untested. By
> the way, is xtal a common abbreviation of crystal?

Yes, it is.

Acked-by: Randy Dunlap <rdunlap@xenotime.net>

Thanks.

>  drivers/media/radio/radio-tea5764.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/media/radio/radio-tea5764.c b/drivers/media/radio/radio-tea5764.c
> index 95ddcc4..db20904 100644
> --- a/drivers/media/radio/radio-tea5764.c
> +++ b/drivers/media/radio/radio-tea5764.c
> @@ -128,8 +128,10 @@ struct tea5764_write_regs {
>  	u16 rdsbbl;				/* PAUSEDET & RDSBBL */
>  } __attribute__ ((packed));
>  
> -#ifndef RADIO_TEA5764_XTAL
> +#ifdef CONFIG_RADIO_TEA5764_XTAL
>  #define RADIO_TEA5764_XTAL 1
> +#else
> +#define RADIO_TEA5764_XTAL 0
>  #endif
>  
>  static int radio_nr = -1;


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
