Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937681Ab0CPKKk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 06:10:40 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:50584 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937644Ab0CPKKi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 06:10:38 -0400
Date: Tue, 16 Mar 2010 11:10:31 +0100
From: Ingo Molnar <mingo@elte.hu>
To: T??r??k Edwin <edwintorok@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
       linux-kernel@vger.kernel.org,
       =?unknown-8bit?B?RnLDqWTDqXJpYw==?= Weisbecker 
	<fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH] perf: install into /usr/local by default.
Message-ID: <20100316101031.GL7961@elte.hu>
References: <4B9F3EEC.7050104@gmail.com>
 <1268733435-30225-1-git-send-email-edwintorok@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1268733435-30225-1-git-send-email-edwintorok@gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* T??r??k Edwin <edwintorok@gmail.com> wrote:

> It was confusing to install into $(HOME)/bin, especially since there was
> no documentation mentioning where perf gets installed by default.
> So install to /usr/local by default, as other programs do, and allow users to
> override the install location by specifying the prefix explicitly.
> 
> Signed-off-by: T??r??k Edwin <edwintorok@gmail.com>
> ---
>  tools/perf/Makefile |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/tools/perf/Makefile b/tools/perf/Makefile
> index 2e7fa3a..8e8c199 100644
> --- a/tools/perf/Makefile
> +++ b/tools/perf/Makefile
> @@ -216,7 +216,7 @@ STRIP ?= strip
>  # runtime figures out where they are based on the path to the executable.
>  # This can help installing the suite in a relocatable way.
>  
> -prefix = $(HOME)
> +prefix = /usr/local
>  bindir_relative = bin
>  bindir = $(prefix)/$(bindir_relative)
>  mandir = share/man

Btw., we inherited that default prefix from the Git project.

Is there a way to get it into ~/bin/ if the user does not have permission to 
/usr/local ? (i.e. doesnt run it as root)

That's a really convenient aspect of doing a 'make install' as user. (Which i 
tend to do in most cases)

	Ingo
