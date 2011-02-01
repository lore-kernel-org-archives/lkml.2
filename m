Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752705Ab1BAT24 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 14:28:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:25525 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751608Ab1BAT2z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 14:28:55 -0500
Date: Tue, 1 Feb 2011 17:28:08 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, eranian@google.com,
        linux-kernel@vger.kernel.org, tzanussi@gmail.com, efault@gmx.de,
        peterz@infradead.org, fweisbec@gmail.com, tglx@linutronix.de,
        mingo@elte.hu, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] perf top: Introduce slang based TUI
Message-ID: <20110201192808.GD25544@ghostprotocols.net>
References: <new-submission> <tip-c0443df1b69b59675fc6790e0ddce87c8ca00abf@git.kernel.org> <4D48562B.20006@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4D48562B.20006@kernel.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Feb 01, 2011 at 10:51:23AM -0800, Yinghai Lu escreveu:
> On 02/01/2011 01:20 AM, tip-bot for Arnaldo Carvalho de Melo wrote:
> > +	slsmg_write_nstring(width >= syme->map->dso->long_name_len ?
> > +				syme->map->dso->long_name :
> > +				syme->map->dso->short_name, width);
> 
> 
> need update macro for that calling
> 
> [PATCH] perf: fix compiling for perf top tui
> 
> util/ui/browsers/top.c: In function ‘perf_top_browser__write’:
> util/ui/browsers/top.c:60:2: error: cast to pointer from integer of different size
> util/ui/browsers/top.c:60:2: error: comparison between pointer and integer
> util/ui/browsers/top.c:60:2: error: passing argument 1 of ‘SLsmg_write_nstring’ discards qualifiers from pointer target type
> /usr/include/slang.h:1728:16: note: expected ‘char *’ but argument is of type ‘const char *’
> make: *** [util/ui/browsers/top.o] Error 1
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>

Good catch, why I didn't got this here is a mistery... anyway, applying,
thanks,

- Arnaldo
 
> ---
>  tools/perf/util/ui/libslang.h |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> Index: linux-2.6/tools/perf/util/ui/libslang.h
> ===================================================================
> --- linux-2.6.orig/tools/perf/util/ui/libslang.h
> +++ linux-2.6/tools/perf/util/ui/libslang.h
> @@ -13,11 +13,11 @@
>  
>  #if SLANG_VERSION < 20104
>  #define slsmg_printf(msg, args...) \
> -	SLsmg_printf((char *)msg, ##args)
> +	SLsmg_printf((char *)(msg), ##args)
>  #define slsmg_write_nstring(msg, len) \
> -	SLsmg_write_nstring((char *)msg, len)
> +	SLsmg_write_nstring((char *)(msg), len)
>  #define sltt_set_color(obj, name, fg, bg) \
> -	SLtt_set_color(obj,(char *)name, (char *)fg, (char *)bg)
> +	SLtt_set_color(obj,(char *)(name), (char *)(fg), (char *)(bg))
>  #else
>  #define slsmg_printf SLsmg_printf
>  #define slsmg_write_nstring SLsmg_write_nstring
