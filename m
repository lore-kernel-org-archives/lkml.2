Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751791Ab0KGVtI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 16:49:08 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:54281 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759Ab0KGVtG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 16:49:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=iASpE12jyQq82boGNA3dCba8pBE/AYvYxM5i9NRRTCFS/yFqPEDXvyu4Y8YhVebRFq
         aBCLfgqgfLFEUBzYR+K/q9Pr6nNvYJCbh19Rm54d0Qoykcaemt6/i/OayUdashpeD3s5
         4qlw/lK4WsM1EjifthebXhJ07VwlBq+cKvrG8=
Date: Sun, 7 Nov 2010 22:49:02 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] perf, ui: Eliminate stack-smashing protection compiler
	complain
Message-ID: <20101107214900.GE11134@nowhere>
References: <20101106084724.GA5956@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20101106084724.GA5956@lenovo>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 06, 2010 at 11:47:24AM +0300, Cyrill Gorcunov wrote:
>  The gcc complains on Yes, No being allocated from stack space. Make
> them conts to feel compiler happy.
> 
>  |    CC util/ui/util.o
>  | cc1: warnings being treated as errors
>  | util/ui/util.c: In function ‘ui__dialog_yesno’:
>  | util/ui/util.c:108: error: not protecting function: no buffer at least 8 bytes long
>  | make: *** [util/ui/util.o] Error 1
> 
> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
> CC: Arnaldo Carvalho de Melo <acme@redhat.com>
> CC: Frédéric Weisbecker <fweisbec@gmail.com>
> CC: Ingo Molnar <mingo@elte.hu>
> ---



I hope we can finally queue this one fix, the warning is there
for a while now, and this patch looks quite sensible :)



> 
> Since it seems only me who has such error I presume ssp-buffer-size=8 set
> for mine local version of gcc (gcc version 4.3.3 (Ubuntu 4.3.3-5ubuntu4))
> 
>  tools/perf/util/ui/util.c |    5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> Index: linux-2.6.git/tools/perf/util/ui/util.c
> =====================================================================
> --- linux-2.6.git.orig/tools/perf/util/ui/util.c
> +++ linux-2.6.git/tools/perf/util/ui/util.c
> @@ -104,9 +104,10 @@ out_destroy_form:
>  	return rc;
>  }
>  
> +static const char yes[] = "Yes", no[] = "No";
>  bool ui__dialog_yesno(const char *msg)
>  {
>  	/* newtWinChoice should really be accepting const char pointers... */
> -	char yes[] = "Yes", no[] = "No";
> -	return newtWinChoice(NULL, yes, no, (char *)msg) == 1;
> +	return newtWinChoice(NULL, (char *)yes, (char *)no, (char *)msg) == 1;
>  }

