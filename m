Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752916Ab2GXJS1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 05:18:27 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:54817 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751496Ab2GXJS0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 05:18:26 -0400
X-AuditID: 9c93016f-b7b08ae00000790d-60-500e685c4d48
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>, Jiri Olsa <jolsa@redhat.com>,
        Ulrich Drepper <drepper@gmail.com>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [RFC/PATCHSET 00/12] perf report: Add support to event group viewing (v1)
References: <1343120493-23059-1-git-send-email-namhyung@kernel.org>
Date: Tue, 24 Jul 2012 18:13:00 +0900
In-Reply-To: <1343120493-23059-1-git-send-email-namhyung@kernel.org> (Namhyung
	Kim's message of "Tue, 24 Jul 2012 18:01:21 +0900")
Message-ID: <87sjch5xpf.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.97 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Jul 2012 18:01:21 +0900, Namhyung Kim wrote:
> Hi all,
>
> This is a patchset to support event grouping on perf report.
>
> It depends on other patches like refactoring hist print [1],
> processing file header feature [2] and (obviously) Jiri's event group
> management [3]. All of this need to be reviewed though. ;)
>
> The basic idea is move group member's hist entries to a leader, and
> sort/collapse them on the leader's tree. The leader will have all of
> group members' stat in it. The output is sorted by the leader's period
> and in turn first child and so on.
>
> To use it, 'perf record' should group events when recording. And then
> perf report parses the saved command line and reconstruct the group
> relation. Currently only the '-e { event1,event2 }' syntax is supported
> (i.e. --group option is *NOT* supported) to make things easy. But it'd
> not be that hard to support --group also.
>
> But I think re-using event parsing routine (at least, in its current
> form) has some problems especially if perf report will not run on the
> same machine that runs perf record. I cannot find a better way than
> extending/changing the perf file format to let perf record know about

s/perf record/perf report/

Thanks,
Namhyung
