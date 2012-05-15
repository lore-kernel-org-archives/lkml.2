Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758293Ab2EOAmH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 20:42:07 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:55290 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752796Ab2EOAmF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 20:42:05 -0400
X-AuditID: 9c93016f-b7cecae000000e00-07-4fb1a659e8c7
From: Namhyung Kim <namhyung.kim@lge.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC 0/5] perf tools: Minimalistic build without libelf dependency
References: <1336979424-17206-1-git-send-email-namhyung.kim@lge.com>
	<20120514092207.GC27980@gmail.com>
Date: Tue, 15 May 2012 09:40:21 +0900
In-Reply-To: <20120514092207.GC27980@gmail.com> (Ingo Molnar's message of
	"Mon, 14 May 2012 11:22:07 +0200")
Message-ID: <87obpq1dl6.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.95 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, 14 May 2012 11:22:07 +0200, Ingo Molnar wrote:
> * Namhyung Kim <namhyung.kim@lge.com> wrote:
>
>> Hi,
>> 
>> NOTE: This is a RFC patchset and it contains a lot of rough edges
>> and ugly codes.
>> 
>> Current build procedure of perf tools requires a couple of external
>> libraries. Although most of them are optional, elfutils' libelf is
>> mandatory for resolving symbols and build-id of the binaries being
>> profiled. For some reason, it makes embedded guys' life harder who
>> want to build and run perf tools on their boards.
>
> Yeah, and this is a very useful patchset from that perspective.
>

Glad to hear that :).


>> This patch set tries to fix the problem by letting the perf could
>> be built without libelf. The initial intent was just providing
>> perf record command to gather performance events interested on the
>> system and copies the data to development box to be used by perf
>> report for analysis.
>> 
>> However it's changed to have most of perf commands as is because
>> perf can resolve kernel symbols without libelf and many of perf
>> commands deal (mostly) with kernel events - so no need to restrict
>> capability of perf tools. Therefore, the end result is not so
>> minimalistic in fact and only thing it cannot do is "perf probe".
>>
>> And then I realized that the perf record needs to know about the
>> build-id's anyway :(. So I implemented a poor man's version of elf
>> parser only for parsing the build-id info.
>> 
>> To build a minimal perf tools, pass MINIMAL=1 to make. The perf
>> report will not display symbol names:
>
> Could we make this automatic when the required elf libraries are 
> not present?
>

Yes, I think it's doable.

Thanks,
Namhyung
