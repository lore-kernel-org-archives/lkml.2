Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032870Ab2CST4V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 15:56:21 -0400
Received: from mail-we0-f194.google.com ([74.125.82.194]:35502 "EHLO
	mail-we0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032756Ab2CST4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 15:56:15 -0400
Date: Mon, 19 Mar 2012 20:56:11 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, Colin Walters <walters@verbum.org>,
        Namhyung Kim <namhyung@gmail.com>, Namhyung Kim <namhyung.kim@lge.com>,
        Paul Mackerras <paulus@samba.org>, Pekka Enberg <penberg@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, arnaldo.melo@gmail.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [GIT PULL 0/3] perf/core fixes and improvements
Message-ID: <20120319195611.GA6347@gmail.com>
References: <1332184368-1655-1-git-send-email-acme@infradead.org>
 <20120319194725.GA31940@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120319194725.GA31940@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@kernel.org> wrote:

> diff --git a/tools/perf/config/utilities.mak b/tools/perf/config/utilities.mak
> index 8046182..68cf795 100644
> --- a/tools/perf/config/utilities.mak
> +++ b/tools/perf/config/utilities.mak
> @@ -183,6 +183,8 @@ _gea_err  = $(if $(1),$(error Please set '$(1)' appropriately))
>  # Usage: option = $(call try-cc, source-to-build, cc-options)
>  try-cc = $(shell sh -c						  \
>  	'TMP="$(OUTPUT)$(TMPOUT).$$$$";				  \
> +	 echo "$(1)" > test.$$$$.c;					  \
> +	 echo $(CC) -x c test.$$$$.c $(2) -o "$$TMP" > test.$$$$.sh;		  \
>  	 echo "$(1)" |						  \
>  	 $(CC) -x c - $(2) -o "$$TMP" > /dev/null 2>&1 && echo y; \
>  	 rm -f "$$TMP"')

So, instead of this hack we'd like to output the build failure 
that gcc gives, when 'make V=1' is specified or so.

Thanks,

	Ingo
