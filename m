Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754164Ab1DUUhn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 16:37:43 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:14527 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752150Ab1DUUhm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 16:37:42 -0400
Message-ID: <4DB09590.1040709@caviumnetworks.com>
Date: Thu, 21 Apr 2011 13:37:36 -0700
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, Sam Ravnborg <sam@ravnborg.org>,
        Joe Perches <joe@perches.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        BorislavPetkov <bp@alien8.de>
Subject: Re: annoying new gcc 4.6.0 warnings.
References: <20110421192117.GA14249@redhat.com> <BANLkTi=srdq69ZG8pWbzWOZLX5KX48DcbQ@mail.gmail.com> <4DB087EC.1010205@caviumnetworks.com> <1303415086.24766.84.camel@Joe-Laptop> <20110421195801.GA15126@redhat.com> <20110421200836.GA31709@merkur.ravnborg.org> <20110421202713.GA19425@redhat.com>
In-Reply-To: <20110421202713.GA19425@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 21 Apr 2011 20:37:41.0871 (UTC) FILETIME=[F62B7FF0:01CC0063]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/21/2011 01:27 PM, Dave Jones wrote:
> On Thu, Apr 21, 2011 at 10:08:36PM +0200, Sam Ravnborg wrote:
>
>   >  My gcc (4.3.2) barfed over -Wno-unused-but-set-variable.
>   >  So your patch needs to check if the option is supported.
>
> I don't have a gcc older than 4.4.0. Can you try this ?
>
> 	Dave
> --
>
> Disable the new -Wunused-but-set-variable that was added in gcc 4.6.0
> It produces more false positives than useful warnings.
>
> This can still be enabled using W=1
>
> Signed-off-by: Dave Jones<davej@redhat.com>
>
> diff --git a/Makefile b/Makefile
> index b967b96..29e16f2 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -559,6 +559,8 @@ ifndef CONFIG_CC_STACKPROTECTOR
>   KBUILD_CFLAGS += $(call cc-option, -fno-stack-protector)
>   endif
>
> +KBUILD_CFLAGS += $(call cc-option, -Wno-unused-but-set-variable)
> +
>   ifdef CONFIG_FRAME_POINTER
>   KBUILD_CFLAGS	+= -fno-omit-frame-pointer -fno-optimize-sibling-calls
>   else
> diff --git a/scripts/Makefile.build b/scripts/Makefile.build
> index d5f925a..30627ab 100644
> --- a/scripts/Makefile.build
> +++ b/scripts/Makefile.build
> @@ -79,6 +79,7 @@ KBUILD_EXTRA_WARNINGS += -Wpointer-arith
>   KBUILD_EXTRA_WARNINGS += -Wredundant-decls
>   KBUILD_EXTRA_WARNINGS += -Wshadow
>   KBUILD_EXTRA_WARNINGS += -Wswitch-default
> +KBUILD_EXTRA_WARNINGS += -Wunused-but-set-variable

Well I didn't test it, but presumably if you need the $(call cc-option, 
-Wno-unused-but-set-variable), you would need similar here.

David Daney
