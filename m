Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754057Ab0HPPYh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 11:24:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21441 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751390Ab0HPPYh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 11:24:37 -0400
Date: Mon, 16 Aug 2010 12:24:10 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Kusanagi Kouichi <slash@ac.auone-net.jp>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf tools: Fix build error on read only source.
Message-ID: <20100816152410.GA13095@ghostprotocols.net>
References: <20100816124017.BE24D6AC03A@msa102.auone-net.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100816124017.BE24D6AC03A@msa102.auone-net.jp>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Aug 16, 2010 at 09:40:13PM +0900, Kusanagi Kouichi escreveu:
... 
> diff --git a/tools/perf/feature-tests.mak b/tools/perf/feature-tests.mak
> @@ -113,7 +113,5 @@ endef
>  # try-cc
>  # Usage: option = $(call try-cc, source-to-build, cc-options)
>  try-cc = $(shell sh -c						  \
> -	'TMP="$(TMPOUT).$$$$";			 		  \
> -	 echo "$(1)" |						  \
> -	 $(CC) -x c - $(2) -o "$$TMP" > /dev/null 2>&1 && echo y; \
> -	 rm -f "$$TMP"')
> +	'echo "$(1)" |						  \
> +	 $(CC) -x c - $(2) -o /dev/null > /dev/null 2>&1 && echo y')

Please read:

 f9af3a4c1f59753bdd5a49e3a34263005f96972e
 8b2c551f9635bf1c5c2d38de300137998915478f
 1703f2c321a8a531c393e137a82602e16c6061cb

To see why we can't use '-o /dev/null' like that.

- Arnaldo
