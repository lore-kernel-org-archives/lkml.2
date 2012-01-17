Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752316Ab2AQHZt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 02:25:49 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:44931 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752259Ab2AQHZp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 02:25:45 -0500
X-AuditID: 9c93016f-b7c20ae000005067-36-4f152276263a
Message-ID: <4F152276.2020403@lge.com>
Date: Tue, 17 Jan 2012 16:25:42 +0900
From: Namhyung Kim <namhyung.kim@lge.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: David Daney <ddaney.cavm@gmail.com>
CC: linux-kernel@vger.kernel.org, David Daney <david.daney@cavium.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Joerg Roedel <joerg.roedel@amd.com>, namhyung@gmail.com
Subject: Re: [PATCH] perf: Fix broken build by rearranging some #includes
References: <1326765685-7686-1-git-send-email-ddaney.cavm@gmail.com>
In-Reply-To: <1326765685-7686-1-git-send-email-ddaney.cavm@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, again.

2012-01-17 11:01 AM, David Daney wrote:
> From: David Daney<david.daney@cavium.com>
>
> When building on my Debian/mips system, util/util.c fails to build
> because commit 1aed2671738785e8f5aea663a6fda91aa7ef59b5 (perf kvm: Do
> guest-only counting by default) indirectly includes stdio.h before the
> feature selection in util.h is done.  This prevents _GNU_SOURCE in
> util.h from enabling the declaration of getline(), from now second
> inclusion of stdio.h, and the build is broken.
>
> There is another breakage in util/evsel.c caused by include ordering,
> but I didn't fully track down the commit that caused it.
>
> Since the #include situation is a little convoluted throughout perf, I
> did the following:
>
> 1) Always include util/util.h before all other include files.
>
> 2) Remove all #define _GNU_SOURCE, as it is already done in util.h.
>
> 3) Remove all #undef _GNU_SOURCE, as they don't do what a naive person
>     might expect (or much of anything for that matter) and clutter up
>     the source.
>
> 4) #include ctype.h in util.h, so that ctype things have uniform
>     definitions throughout perf.
>
> 5) Remove #define of _FILE_OFFSET_BITS where util/util.h is already
>     providing it.
>
> This gives me a clean build on x86_64 (fc12) and mips (Debian).

Instead of reordering, how about adding -D_GNU_SOURCE on Makefile and 
removing the line from util.h? If util.h would always be included at 
first, the end result should be same, right? And this way, we don't need 
to care about the ordering anymore.


Thanks,
Namhyung
