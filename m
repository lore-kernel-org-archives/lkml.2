Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754427Ab0DDOe4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Apr 2010 10:34:56 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:51351 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753364Ab0DDOeu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Apr 2010 10:34:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=pwFCbniCq/3X3T6e6PogaDVG6bWwg7tCmHK62d2jsQum59dt/j1VuAJY/sAdyA1wXR
         is81lLjvgxOb0blrzqVE8PmZvLTRbk85gx7dcmHZB3oY3U+/x2c4dfolejDYHxc8OdFV
         wwnwQf/cFUsi4nNCLdRTsSSIwe44GUf3S8yK4=
Date: Sun, 4 Apr 2010 16:34:43 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, h.mitake@gmail.com,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH] Swap including order of util.h and string.h of
	util/string.c
Message-ID: <20100404143441.GA5608@nowhere>
References: <1270368798-27232-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1270368798-27232-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 04, 2010 at 05:13:18PM +0900, Hitoshi Mitake wrote:
> Current util/string.c includes headers in this order: string.h, util.h
> But this causes build error because __USE_GNU definition
> is needed for strndup() definition like this,
> % make -j
> touch .perf.dev.null
>     CC util/string.o
> cc1: warnings being treated as errors
> util/string.c: In function ‘argv_split’:
> util/string.c:171: error: implicit declaration of function ‘strndup’
> util/string.c:171: error: incompatible implicit declaration of built-in function ‘strndup’


Thanks, I've queued it as I have the same problem and I'm
about to send a perf/core queue.



> 
> So this patch swaps order of including headers.
> util.h defines _GNU_SOURCE, and /usr/include/features.h defines __USE_GNU as 1
> if _GNU_SOURCE is defined.
> 
> Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> ---
>  tools/perf/util/string.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/tools/perf/util/string.c b/tools/perf/util/string.c
> index d438924..0409fc7 100644
> --- a/tools/perf/util/string.c
> +++ b/tools/perf/util/string.c
> @@ -1,5 +1,5 @@
> -#include "string.h"
>  #include "util.h"
> +#include "string.h"
>  
>  #define K 1024LL
>  /*
> -- 
> 1.6.5.2
> 

