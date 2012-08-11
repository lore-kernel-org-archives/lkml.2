Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754756Ab2HKNOl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2012 09:14:41 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48394 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754260Ab2HKNOk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2012 09:14:40 -0400
Subject: Re: [PATCH 01/16] perf symbol: correct comment wrt kallsyms loading
From: Namhyung Kim <namhyung@kernel.org>
To: Cody P Schafer <cody@linux.vnet.ibm.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Matt Hellsley <matthltc@us.ibm.com>,
        David Hansen <dave@linux.vnet.ibm.com>
In-Reply-To: <1344637382-22789-2-git-send-email-cody@linux.vnet.ibm.com>
References: <1344637382-22789-1-git-send-email-cody@linux.vnet.ibm.com>
	 <1344637382-22789-2-git-send-email-cody@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 11 Aug 2012 22:14:33 +0900
Message-ID: <1344690873.2003.1.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012-08-10 (금), 15:22 -0700, Cody P Schafer:
> In kallsyms_parse() when calling process_symbol() (a callback argument
> to kallsyms_parse()), we pass start as both start & end (ie:
> start=start, end=start).
> 
> In map__process_kallsym_symbol(), the length is calculated as 'end - start + 1',
> making the length 1, not 0.
> 
> Essentially, start & end define an inclusive range.
> 

This seems not needed any more due to the patch #2, right?

Thanks,
Namhyung


> Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
> ---
>  tools/perf/util/symbol.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
> index f02de8a..891f83c 100644
> --- a/tools/perf/util/symbol.c
> +++ b/tools/perf/util/symbol.c
> @@ -605,7 +605,7 @@ int kallsyms__parse(const char *filename, void *arg,
>  
>  		/*
>  		 * module symbols are not sorted so we add all
> -		 * symbols with zero length and rely on
> +		 * symbols, setting length to 1, and rely on
>  		 * symbols__fixup_end() to fix it up.
>  		 */
>  		err = process_symbol(arg, symbol_name,



