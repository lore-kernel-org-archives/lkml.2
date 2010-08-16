Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754196Ab0HPOKW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 10:10:22 -0400
Received: from esgaroth.petrovitsch.at ([78.47.184.11]:6322 "EHLO
	esgaroth.petrovitsch.priv.at" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750965Ab0HPOKV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 10:10:21 -0400
X-DKIM: Sendmail DKIM Filter v2.8.3 unknown-host o7GE9Mxb015118
Subject: Re: [PATCH] perf tools: Don't use brace expansion.
From: Bernd Petrovitsch <bernd@petrovitsch.priv.at>
To: Kusanagi Kouichi <slash@ac.auone-net.jp>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20100816124101.1829415C039@msa104.auone-net.jp>
References: <20100816124101.1829415C039@msa104.auone-net.jp>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 16 Aug 2010 16:09:21 +0200
Message-ID: <1281967761.17267.6.camel@thorin>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
X-DCC-dcc1-Metrics: esgaroth.petrovitsch.priv.at; whitelist
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-08-16 at 21:41 +0900, Kusanagi Kouichi wrote:
> DASH doesn't support brace expansion.
> 
> Signed-off-by: Kusanagi Kouichi <slash@ac.auone-net.jp>
> ---
>  tools/perf/Makefile |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/perf/Makefile b/tools/perf/Makefile
> index 41abb90..8fa851b 100644
> --- a/tools/perf/Makefile
> +++ b/tools/perf/Makefile
> @@ -157,8 +157,10 @@ all::
>  #
>  # Define NO_DWARF if you do not want debug-info analysis feature at all.
>  
> -$(shell sh -c 'mkdir -p $(OUTPUT)scripts/{perl,python}/Perf-Trace-Util/' 2> /dev/null)
> -$(shell sh -c 'mkdir -p $(OUTPUT)util/{ui/browsers,scripting-engines}/' 2> /dev/null)
> +$(shell sh -c 'mkdir -p $(OUTPUT)scripts/perl/Perf-Trace-Util/' 2> /dev/null)
> +$(shell sh -c 'mkdir -p $(OUTPUT)scripts/python/Perf-Trace-Util/' 2> /dev/null)
> +$(shell sh -c 'mkdir -p $(OUTPUT)util/ui/browsers/' 2> /dev/null)
> +$(shell sh -c 'mkdir -p $(OUTPUT)util/scripting-engines/' 2> /dev/null)
>  $(shell sh -c 'mkdir $(OUTPUT)bench' 2> /dev/null)
>  
>  $(OUTPUT)PERF-VERSION-FILE: .FORCE-PERF-VERSION-FILE

The other solution is to use standard-make features like in
mkdir -p $(foreach d,ui/browsers scripting-engines,$(OUTPUT)util/$(d)/) 2> /dev/null

Is there actually a specific reason for the 
$(shell sh -c '...')
around?
It looks superflous.

	Bernd
-- 
Bernd Petrovitsch                  Email : bernd@petrovitsch.priv.at
                     LUGA : http://www.luga.at

