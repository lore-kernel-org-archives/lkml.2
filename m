Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755747Ab1FVJud (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 05:50:33 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59022 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752837Ab1FVJuc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 05:50:32 -0400
Date: Wed, 22 Jun 2011 11:50:23 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Robert Richter <robert.richter@amd.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf tools: Don't corrupt PERF-VERSION-FILE with make
 debug
Message-ID: <20110622095023.GB18277@elte.hu>
References: <1308585228-3982-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1308585228-3982-1-git-send-email-robert.richter@amd.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Robert Richter <robert.richter@amd.com> wrote:

> When running make with debug option -d the PERF-VERSION-FILE gets
> corrupted because make is noisy:
> 
>  PERF-VERSION-FILE:2: *** missing separator.  Stop.
> 
> Fixing this by not passing the make flags in the MAKEFLAGS environment
> variable to the sub-make that generates the version string.
> 
> Signed-off-by: Robert Richter <robert.richter@amd.com>
> ---
>  tools/perf/util/PERF-VERSION-GEN |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/tools/perf/util/PERF-VERSION-GEN b/tools/perf/util/PERF-VERSION-GEN
> index 9c5fb4d..ad73300 100755
> --- a/tools/perf/util/PERF-VERSION-GEN
> +++ b/tools/perf/util/PERF-VERSION-GEN
> @@ -23,7 +23,7 @@ if test -d ../../.git -o -f ../../.git &&
>  then
>  	VN=$(echo "$VN" | sed -e 's/-/./g');
>  else
> -	VN=$(make -sC ../.. kernelversion)
> +	VN=$(MAKEFLAGS= make -sC ../.. kernelversion)

Yeah, and this has been fixed recently, via:

  37aa9a2eb4d9: perf: clear out make flags when calling kernel make kernelver

Thanks,

	Ingo
