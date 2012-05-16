Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966194Ab2EPCev (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 22:34:51 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:47209 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759038Ab2EPCem (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 22:34:42 -0400
X-AuditID: 9c93016f-b7cecae000000e00-2f-4fb31236ecd0
From: Namhyung Kim <namhyung.kim@lge.com>
To: David Ahern <dsahern@gmail.com>
Cc: Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org,
        peterz@infradead.org, mingo@elte.hu, acme@redhat.com
Subject: Re: [PATCH v2 0/5] perf tools: add meta-data header support in pipe mode
References: <1337081295-10303-1-git-send-email-eranian@google.com>
	<87ehqkewom.fsf@sejong.aot.lge.com> <4FB30B52.7080104@gmail.com>
Date: Wed, 16 May 2012 11:32:31 +0900
In-Reply-To: <4FB30B52.7080104@gmail.com> (David Ahern's message of "Tue, 15
	May 2012 20:05:06 -0600")
Message-ID: <87txzgdfeo.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.95 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, 15 May 2012 20:05:06 -0600, David Ahern wrote:
> On 5/15/12 7:34 PM, Namhyung Kim wrote:
>> Hi, Stephane
>>
>> On Tue, 15 May 2012 13:28:10 +0200, Stephane Eranian wrote:
>>> This patch series adds meta-data support to perf record/report in pipe
>>> mode:
>>> 	perf record -o - foo | perf inject -b | perf report -i -
>>>
>>> We had meta-data (information about host configuration, perf tool version,...)
>>> in regular (file) mode but it was lacking in pipe mode. This patch series fixes
>>> this.
>>>
>>
>> In addition to this change, I think it'd be great if we keep this
>> meta-data somewhere for later use - I guess perf report and
>> annotate on TUI, at least, will need it too. Just a suggestion :).
>>
>> Thanks,
>> Namhyung
>>
>
> It is there -- see perf-report header. It gets dropped on pipe mode
> b/c the meta-data is in the header.
>
> David

Do you mean this?

struct perf_report {
	struct perf_tool	tool;
	struct perf_session	*session;
	char const		*input_name;
	bool			force, use_tui, use_gtk, use_stdio;
	bool			hide_unresolved;
	bool			dont_use_callchains;
	bool			show_full_info;
	bool			show_threads;
	bool			inverted_callchain;
	struct perf_read_values	show_threads_values;
	const char		*pretty_printing_style;
	symbol_filter_t		annotate_init;
	const char		*cpu_list;
	const char		*symbol_filter_str;
	DECLARE_BITMAP(cpu_bitmap, MAX_NR_CPUS);
};

Thanks,
Namhyung
