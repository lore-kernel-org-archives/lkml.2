Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752218Ab2AQHSF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 02:18:05 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:60242 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752142Ab2AQHSD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 02:18:03 -0500
X-AuditID: 9c93016f-b7c20ae000005067-5a-4f1520a7e222
Message-ID: <4F1520A6.7070908@lge.com>
Date: Tue, 17 Jan 2012 16:17:58 +0900
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

Hi,

2012-01-17 11:01 AM, David Daney wrote:
> From: David Daney<david.daney@cavium.com>
>
> When building on my Debian/mips system, util/util.c fails to build
> because commit 1aed2671738785e8f5aea663a6fda91aa7ef59b5 (perf kvm: Do
> guest-only counting by default) indirectly includes stdio.h before the
> feature selection in util.h is done.  This prevents _GNU_SOURCE in
> util.h from enabling the declaration of getline(), from now second
> inclusion of stdio.h, and the build is broken.

I've experienced similar problem wrt pwrite() last week. The fix was 
simply removing ctype.h from inclusion for my case.


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

Among other things, ctype.h isn't needed at all since util.h redefines 
all of ctype macros anyway. I've posted a patch which removes ctype.h 
inclusions as Ingo's suggestion.

https://lkml.org/lkml/2012/1/16/510


Thanks,
Namhyung Kim
