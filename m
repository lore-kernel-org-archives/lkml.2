Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752358Ab1F2FOj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 01:14:39 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:33162 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987Ab1F2FOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 01:14:34 -0400
X-AuditID: b753bd60-a46c9ba000003bac-ec-4e0ab4b7f276
X-AuditID: b753bd60-a46c9ba000003bac-ec-4e0ab4b7f276
Message-ID: <4E0AB4B5.9040305@hitachi.com>
Date: Wed, 29 Jun 2011 14:14:29 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.18) Gecko/20110616 Thunderbird/3.1.11
MIME-Version: 1.0
To: David Ahern <dsahern@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        yrl.pp-manager.tt@hitachi.com, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH -tip 10/13] [RESEND]perf probe: Warn when more than two
 lines are given
References: <20110627072626.6528.41792.stgit@fedora15> <20110627072733.6528.82721.stgit@fedora15> <4E09E21A.8060202@gmail.com>
In-Reply-To: <4E09E21A.8060202@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/06/28 23:15), David Ahern wrote:
> 
> 
> On 06/27/2011 01:27 AM, Masami Hiramatsu wrote:
>> Print warning which warns only the last specified --line option is valid.
>>
>> Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
>> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
>> Cc: Paul Mackerras <paulus@samba.org>
>> Cc: Ingo Molnar <mingo@elte.hu>
>> Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
>> ---
>>
>>  tools/perf/builtin-probe.c |   11 ++++++++---
>>  1 files changed, 8 insertions(+), 3 deletions(-)
>>
>> diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
>> index 2c0e64d..4f3460a 100644
>> --- a/tools/perf/builtin-probe.c
>> +++ b/tools/perf/builtin-probe.c
>> @@ -134,10 +134,15 @@ static int opt_show_lines(const struct option *opt __used,
>>  {
>>  	int ret = 0;
>>  
>> -	if (str)
>> -		ret = parse_line_range_desc(str, &params.line_range);
>> -	INIT_LIST_HEAD(&params.line_range.line_list);
>> +	if (!str)
>> +		return 0;
>> +
>> +	if (params.show_lines)
>> +		pr_warning("Warning: more than two --line option are"
>> +			   " detected. Only last option is valid.\n");
> 
> This detects a second --line option, but your warning suggests two
> --line options are ok. Should that warning be "more than one --line
> option is"

Oops! Right, thank you!

> 
>>  	params.show_lines = true;
>> +	ret = parse_line_range_desc(str, &params.line_range);
>> +	INIT_LIST_HEAD(&params.line_range.line_list);
>>  
>>  	return ret;
>>  }


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
