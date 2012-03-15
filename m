Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031401Ab2COAob (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 20:44:31 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:58844 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031239Ab2COAo2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 20:44:28 -0400
X-AuditID: 9c930179-b7b27ae000000e38-da-4f613b69b5ac
Message-ID: <4F613B68.2040004@lge.com>
Date: Thu, 15 Mar 2012 09:44:24 +0900
From: Namhyung Kim <namhyung.kim@lge.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: Arun Sharma <asharma@fb.com>
CC: Ingo Molnar <mingo@elte.hu>, Namhyung Kim <namhyung@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org,
        dsahern@gmail.com, ravitillo@lbl.gov, khandual@linux.vnet.ibm.com,
        robert.richter@amd.com, ming.m.lin@intel.com, vweaver1@eecs.utk.edu,
        andi@firstfloor.org
Subject: Re: [RFC] perf report: Implement symbol filtering on TUI
References: <20120306062546.GA622@elte.hu> <1331085470-32594-1-git-send-email-namhyung.kim@lge.com> <20120314231154.GA15986@dev3310.snc6.facebook.com>
In-Reply-To: <20120314231154.GA15986@dev3310.snc6.facebook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2012-03-15 8:11 AM, Arun Sharma wrote:
> On Wed, Mar 07, 2012 at 10:57:50AM +0900, Namhyung Kim wrote:
>> As Ingo requested, symbol filtering feature was missing on TUI.
>> Add 's' key to get input from user, and do simple filtering by
>> strstr(). To turn filtering off, just enter no name by pressing
>> 's' followed by ENTER.
>
> Why not do this for --stdio as well?
>
> perf report foo -g graph,0.5,caller -s inclusive --stdio
>
> will print only the callgraph under foo.
>
> This works better for me than:
>
> perf report -s parent -p ^c$ --stdio
>
>   -Arun

Thanks for reviewing and sending the patch.

However this was already fixed on my new patch set. Please see below:

https://lkml.org/lkml/2012/3/13/73


Thanks,
Namhyung


>
> index 94394f3..607b21b 100644
> --- a/tools/perf/builtin-report.c
> +++ b/tools/perf/builtin-report.c
> @@ -219,6 +219,8 @@ static int perf_evlist__tty_browse_hists(struct perf_evlist *evlist,
>   		struct hists *hists =&pos->hists;
>   		const char *evname = event_name(pos);
>
> +		hists->symbol_filter_str = rep->symbol_filter_str;
> +		hists__filter_by_symbol(hists);
>   		hists__fprintf_nr_sample_events(hists, evname, stdout);
>   		hists__fprintf(hists, NULL, false, true, 0, 0, stdout);
>   		fprintf(stdout, "\n\n");
>
>

