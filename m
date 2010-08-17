Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753946Ab0HQM5q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 08:57:46 -0400
Received: from msa105.auone-net.jp ([61.117.18.165]:49717 "EHLO
	msa105.auone-net.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752891Ab0HQM5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 08:57:45 -0400
Date: Tue, 17 Aug 2010 21:57:38 +0900
From: Kusanagi Kouichi <slash@ac.auone-net.jp>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf tools: Fix build error on read only source.
References: <20100816124017.BE24D6AC03A@msa102.auone-net.jp>
 <20100816152410.GA13095@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100816152410.GA13095@ghostprotocols.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Message-Id: <20100817125738.AD0386FC03B@msa105.auone-net.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-08-16 12:24:10 -0300, Arnaldo Carvalho de Melo wrote:
> Em Mon, Aug 16, 2010 at 09:40:13PM +0900, Kusanagi Kouichi escreveu:
> ... 
> > diff --git a/tools/perf/feature-tests.mak b/tools/perf/feature-tests.mak
> > @@ -113,7 +113,5 @@ endef
> >  # try-cc
> >  # Usage: option = $(call try-cc, source-to-build, cc-options)
> >  try-cc = $(shell sh -c						  \
> > -	'TMP="$(TMPOUT).$$$$";			 		  \
> > -	 echo "$(1)" |						  \
> > -	 $(CC) -x c - $(2) -o "$$TMP" > /dev/null 2>&1 && echo y; \
> > -	 rm -f "$$TMP"')
> > +	'echo "$(1)" |						  \
> > +	 $(CC) -x c - $(2) -o /dev/null > /dev/null 2>&1 && echo y')
> 
> Please read:
> 
>  f9af3a4c1f59753bdd5a49e3a34263005f96972e
>  8b2c551f9635bf1c5c2d38de300137998915478f
>  1703f2c321a8a531c393e137a82602e16c6061cb
> 
> To see why we can't use '-o /dev/null' like that.
> 
> - Arnaldo

I see. I will try another way.
