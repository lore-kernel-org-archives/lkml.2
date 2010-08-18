Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751670Ab0HRMka (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 08:40:30 -0400
Received: from casper.infradead.org ([85.118.1.10]:34589 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750797Ab0HRMk3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 08:40:29 -0400
Subject: Re: [PATCH] perf tools: Fix build error on read only source.
From: Peter Zijlstra <peterz@infradead.org>
To: Kusanagi Kouichi <slash@ac.auone-net.jp>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20100818123713.1F02414C03B@msa103.auone-net.jp>
References: <20100817181835.GA21083@ghostprotocols.net>
	 <20100818123713.1F02414C03B@msa103.auone-net.jp>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 18 Aug 2010 14:40:24 +0200
Message-ID: <1282135224.1926.3936.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-08-18 at 21:37 +0900, Kusanagi Kouichi wrote:

> With POSIX shell patch, $(OUTPUT) has not been created yet when it is
> used by try-cc. This fixes the issue anyway.
> 
> diff --git a/tools/perf/Makefile b/tools/perf/Makefile
> index dcb9700..5b1c12b 100644
> --- a/tools/perf/Makefile
> +++ b/tools/perf/Makefile
> @@ -281,6 +281,7 @@ endif
> 
>  -include feature-tests.mak
> 
> +$(shell mkdir -p $(OUTPUT) 2> /dev/null)
>  ifeq ($(call try-cc,$(SOURCE_HELLO),-Werror -fstack-protector-all),y)
>  	CFLAGS := $(CFLAGS) -fstack-protector-all
>  endif


So you're wanting to provide a non-existing O=foo ?

I don't think we should, simply bail when it doesn't exist, kernel
builds do the same:

# make O=plop-build bzImage
/bin/sh: line 0: cd: plop-build: No such file or directory
Makefile:117: *** output directory "plop-build" does not exist.  Stop.

