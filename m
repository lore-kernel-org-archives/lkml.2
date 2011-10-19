Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753243Ab1JSDDI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 23:03:08 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:54493 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753033Ab1JSDDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 23:03:07 -0400
Message-ID: <4E9E3DE6.6040600@gmail.com>
Date: Tue, 18 Oct 2011 21:03:02 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH] perf ui browser: Honour the xterm colors
References: <1318974247-6683-1-git-send-email-acme@infradead.org> <1318974247-6683-7-git-send-email-acme@infradead.org> <4E9E082D.8040403@gmail.com> <20111018235133.GA3494@ghostprotocols.net> <20111019011233.GB3494@ghostprotocols.net> <20111019024124.GA4596@ghostprotocols.net>
In-Reply-To: <20111019024124.GA4596@ghostprotocols.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 10/18/2011 08:41 PM, Arnaldo Carvalho de Melo wrote:
> Em Tue, Oct 18, 2011 at 11:12:33PM -0200, Arnaldo Carvalho de Melo escreveu:
>> Em Tue, Oct 18, 2011 at 09:51:33PM -0200, Arnaldo Carvalho de Melo escreveu:
>>> Em Tue, Oct 18, 2011 at 05:13:49PM -0600, David Ahern escreveu:
>>>> Using gnome3 with Fedora 15 these last 2 color sets don't look so good.
>>>> The 'black' background is not really black - more of a gray'ish look and
>>  
>>> Yeah, I also noticed that libslang's "black" is kinda like a
>>> bright black, really strange, I need to figure this out and also how to
>>> get the colors currently set in the terminal to get this finally like
>>> --stdio.
>>
>> https://bugzilla.redhat.com/show_bug.cgi?id=426948
>>
>> I know need to continue reading to figure out how to overcome this, as
>>
>> -Out to bed now tho :-)-
> 
> Ok, the following patch, that I pushed to my perf/core branch, does the
> trick...

Indeed it does. Much better color contrasts -- for me anyways.

David


> 
> _Out to bed now really :-)_
> 
> - Arnaldo
> 
> --------------------------
> 
> perf ui browser: Honour the xterm colors
> 
> So slang after all _has_ a 'default' color, call me color blind. Change
> the default to it.
> 
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Mike Galbraith <efault@gmx.de>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Stephane Eranian <eranian@google.com>
> Cc: Tom Zanussi <tzanussi@gmail.com>
> Link: http://lkml.kernel.org/n/tip-1dfxivxv0jhwldpds3v4zla2@git.kernel.org
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> ---
>  tools/perf/util/ui/browser.c |   10 +++++-----
>  1 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/tools/perf/util/ui/browser.c b/tools/perf/util/ui/browser.c
> index 976b957..06fc9eb 100644
> --- a/tools/perf/util/ui/browser.c
> +++ b/tools/perf/util/ui/browser.c
> @@ -439,19 +439,19 @@ static struct ui_browser__colorset {
>  		.colorset = HE_COLORSET_TOP,
>  		.name	  = "top",
>  		.fg	  = "red",
> -		.bg	  = "black",
> +		.bg	  = "default",
>  	},
>  	{
>  		.colorset = HE_COLORSET_MEDIUM,
>  		.name	  = "medium",
>  		.fg	  = "green",
> -		.bg	  = "black",
> +		.bg	  = "default",
>  	},
>  	{
>  		.colorset = HE_COLORSET_NORMAL,
>  		.name	  = "normal",
> -		.fg	  = "brightgreen",
> -		.bg	  = "black",
> +		.fg	  = "default",
> +		.bg	  = "default",
>  	},
>  	{
>  		.colorset = HE_COLORSET_SELECTED,
> @@ -463,7 +463,7 @@ static struct ui_browser__colorset {
>  		.colorset = HE_COLORSET_CODE,
>  		.name	  = "code",
>  		.fg	  = "blue",
> -		.bg	  = "black",
> +		.bg	  = "default",
>  	},
>  	{
>  		.name = NULL,
