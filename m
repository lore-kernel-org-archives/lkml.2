Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751186Ab1GVEZp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 00:25:45 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:41714 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741Ab1GVEZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 00:25:44 -0400
X-AuditID: b753bd60-a0a78ba0000050a4-ec-4e28fbc5f68f
X-AuditID: b753bd60-a0a78ba0000050a4-ec-4e28fbc5f68f
Message-ID: <4E28FBC2.7040208@hitachi.com>
Date: Fri, 22 Jul 2011 13:25:38 +0900
From: Akihiro Nagai <akihiro.nagai.hw@hitachi.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:5.0) Gecko/20110624 Thunderbird/5.0
MIME-Version: 1.0
To: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        yrl.pp-manager.tt@hitachi.com, Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH -tip v2 2/6] perf script: add magic word to indicate the
 failure of resolving symbols
References: <20110717093031.3447.52715.stgit@linux3> <20110717093051.3447.65080.stgit@linux3> <4E2308A9.5000706@gmail.com> <4E230E32.3010503@gmail.com> <4E27F32A.6010609@hitachi.com> <4E283A33.1010100@gmail.com>
In-Reply-To: <4E283A33.1010100@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/07/21 23:39), David Ahern wrote:
> On 07/21/2011 03:36 AM, Akihiro Nagai wrote
>>> Evidently I had the shift key down -- s/{}/[]/.  :-) And I see now, for
>>> dsoname you have [unknown] and for symname (unknown). Use the same for
>>> both. Since () is already used for separating dsoname, use [unknown] for
>>> both
>> At print_sample_start() in builtin-script.c, there is the code that
>> print "(unknown)"
>> when perf cannnot resolve the event name.
>>
>>      printf("%s: ", evname ? evname : "(unknown)");
>>
>> On the other hand, at hist_entry__dso_snprintf() in util/sort.c, there
>> is the code
>> prints "[unknown]" for unresolvable DSO name.
>>
>>      return repsep_snprintf(bf, size, "%-*s", width, "[unknown]");
>>
>> In addition, perf uses "[]" for DSO name for example "[kernel.kallsyms]".
>> So, I chose it. However, this specification is not easy for user-scripts.
>> Should I unify this expression?
>
> That was my thought -- to use the same for both dso and sym if it is
> unknown. And since DSO names are wrapped in () use "[unknown]" for both
> -- ie., right now the format is  "symname (dsoname)" (though kernel syms
> from kallsyms come out as "symname ([kernel.kallsyms])"). With an
> unknown it will be "[unknown] (dsoname)" or "[unknown] ([unknown])"
> which retains the number of fields in a uniquely parse-able way.
I agree.
In the next patch set, I'd like to unify the all expressions to "[unknown]".

Thank you.
>
> David
