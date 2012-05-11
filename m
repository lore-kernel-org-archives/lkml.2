Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758979Ab2EKCMa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 22:12:30 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:48894 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758485Ab2EKCM3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 22:12:29 -0400
X-AuditID: 9c93016f-b7cecae000000e00-b2-4fac75895266
From: Namhyung Kim <namhyung.kim@lge.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH] perf top: Fix a race in callchain handling
References: <1336231388-12347-1-git-send-email-namhyung@gmail.com>
	<1336242167.2463.138.camel@laptop>
	<20120505235319.GB2150@infradead.org>
	<1336271107.1534.12.camel@leonhard>
	<20120506183212.GB2485@infradead.org>
	<878vh4srmh.fsf@sejong.aot.lge.com>
Date: Fri, 11 May 2012 11:10:59 +0900
In-Reply-To: <878vh4srmh.fsf@sejong.aot.lge.com> (Namhyung Kim's message of
	"Mon, 07 May 2012 10:32:22 +0900")
Message-ID: <87vck3ii18.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.95 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, 07 May 2012 10:32:22 +0900, Namhyung Kim wrote:
> On Sun, 6 May 2012 15:32:12 -0300, Arnaldo Carvalho de Melo wrote:
>> Em Sun, May 06, 2012 at 11:25:07AM +0900, Namhyung Kim escreveu:
>>> 2012-05-05 (토), 20:53 -0300, Arnaldo Carvalho de Melo:
>>> > I'm looking how to get that fixed with Peter concerns addressed.
>>> 
>>> I guess it's gonna be a non-trivial job. As far as I can see, the hists
>>> code can handle up to two concurrent threads regardless of the callchain
>>> cursor problem. And also guess that other areas of libperf also doesn't
>>> support the true concurrency, right?
>>
>> Right, but making it even less concurrent is something we should avoid
>> 8-)
>>
>> How about this one instead? At least we would be able to, concurrently,
>> process multiple, unrelated hists:
>
> I thought about it before, but it still cannot protect it from accessing
> a hists by multiple concurrent threads. IOW if two threads call the
> function to a same hists at the same time, ->callchain_collapse_cursor
> would still get the race problem - so crashed.
>
> I guess callchain_cursor should be thread-local, eventually. No need to
> make it hist-local IMHO.
>

So, any thoughts?

Thanks,
Namhyung
