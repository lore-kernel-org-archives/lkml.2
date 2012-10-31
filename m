Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755201Ab2JaHSU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 03:18:20 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:47940 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752836Ab2JaHST (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 03:18:19 -0400
X-AuditID: 9c930197-b7c0bae00000042f-e1-5090d0b89a65
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: David Ahern <dsahern@gmail.com>, linux-kernel@vger.kernel.org,
        mingo@kernel.org, peterz@infradead.org, fweisbec@gmail.com
Subject: Re: [PATCH 1/9] perf python: add ui stubs file
References: <1351528309-87705-1-git-send-email-dsahern@gmail.com>
	<1351528309-87705-2-git-send-email-dsahern@gmail.com>
	<87a9v4777t.fsf@sejong.aot.lge.com> <508FE808.2030306@gmail.com>
	<20121030155338.GA28061@ghostprotocols.net>
Date: Wed, 31 Oct 2012 16:18:16 +0900
In-Reply-To: <20121030155338.GA28061@ghostprotocols.net> (Arnaldo Carvalho de
	Melo's message of "Tue, 30 Oct 2012 08:53:38 -0700")
Message-ID: <871ugf5cuf.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Oct 2012 08:53:38 -0700, Arnaldo Carvalho de Melo wrote:
> Em Tue, Oct 30, 2012 at 08:45:28AM -0600, David Ahern escreveu:
>> On 10/30/12 1:24 AM, Namhyung Kim wrote:
>> >On Mon, 29 Oct 2012 10:31:41 -0600, David Ahern wrote:
>> >>stdio based implementations of ui_xxxx based functions for the python
>> >>library. Needed for patch 3 - consolidating open counters method.
>
>> >How about adding ui/util.c to the python-ext-sources?
>
>> Handles some of the ui_xxxx functions, but still missing some
>> symbols -- verbose, eprintf, ui__error_paranoid. The point of the
>> python_stubs.c was a short term solution for the ui handlers.
>> Arnaldo had some ideas on what is really needed.
>
> Yes, and that is something like what Namhyung did for perf_target, i.e.
> don't call ui__ stuff from the evsel/evlist classes but use a
> perf_evlist__strerror, merge perf_evlist__open_counters() with
> perf_evlist__open(), use just perf_evlist__open() everywhere, so that
> all tools get the fallbacks for features not present in older kernels,
> etc.

Yeah, it'd be better definitely.  But the problem is we might emit
warnings even in the internal fallback loop.  Not sure how to handle it
with this approach.

Thanks,
Namhyung
