Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760744Ab2EKQ0A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 12:26:00 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63136 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756722Ab2EKQZ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 12:25:58 -0400
From: Namhyung Kim <namhyung@gmail.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Namhyung Kim <namhyung.kim@lge.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH] perf top: Fix a race in callchain handling
References: <1336231388-12347-1-git-send-email-namhyung@gmail.com>
	<1336242167.2463.138.camel@laptop>
	<20120505235319.GB2150@infradead.org>
	<1336271107.1534.12.camel@leonhard>
	<20120506183212.GB2485@infradead.org>
	<878vh4srmh.fsf@sejong.aot.lge.com>
	<87vck3ii18.fsf@sejong.aot.lge.com>
	<20120511150111.GA2485@infradead.org>
Date: Sat, 12 May 2012 01:25:48 +0900
In-Reply-To: <20120511150111.GA2485@infradead.org> (Arnaldo Carvalho de Melo's
	message of "Fri, 11 May 2012 12:01:11 -0300")
Message-ID: <87boluwupf.fsf@gmail.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, 11 May 2012 12:01:11 -0300, Arnaldo Carvalho de Melo wrote:
> Em Fri, May 11, 2012 at 11:10:59AM +0900, Namhyung Kim escreveu:
>> On Mon, 07 May 2012 10:32:22 +0900, Namhyung Kim wrote:
>> > I thought about it before, but it still cannot protect it from accessing
>> > a hists by multiple concurrent threads. IOW if two threads call the
>> > function to a same hists at the same time, ->callchain_collapse_cursor
>> > would still get the race problem - so crashed.
>> >
>> > I guess callchain_cursor should be thread-local, eventually. No need to
>> > make it hist-local IMHO.
>> 
>> So, any thoughts?
>
> Can you try writing a patch using TLS?
>

Well, I can do it, but I still think the current patch is just enough
for now though. My concern is the TLS might make perf less portable
especially for embedded systems which are not using glibc.

Anyway I'll give it a spin as you ask.

Thanks,
Namhyung
