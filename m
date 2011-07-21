Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751980Ab1GUOjv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 10:39:51 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:50800 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742Ab1GUOju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 10:39:50 -0400
Message-ID: <4E283A33.1010100@gmail.com>
Date: Thu, 21 Jul 2011 08:39:47 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Akihiro Nagai <akihiro.nagai.hw@hitachi.com>
CC: Arnaldo Carvalho de Melo <acme@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        yrl.pp-manager.tt@hitachi.com, Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH -tip v2 2/6] perf script: add magic word to indicate the
 failure of resolving symbols
References: <20110717093031.3447.52715.stgit@linux3> <20110717093051.3447.65080.stgit@linux3> <4E2308A9.5000706@gmail.com> <4E230E32.3010503@gmail.com> <4E27F32A.6010609@hitachi.com>
In-Reply-To: <4E27F32A.6010609@hitachi.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/21/2011 03:36 AM, Akihiro Nagai wrote
>> Evidently I had the shift key down -- s/{}/[]/.  :-) And I see now, for
>> dsoname you have [unknown] and for symname (unknown). Use the same for
>> both. Since () is already used for separating dsoname, use [unknown] for
>> both
> At print_sample_start() in builtin-script.c, there is the code that
> print "(unknown)"
> when perf cannnot resolve the event name.
> 
>     printf("%s: ", evname ? evname : "(unknown)");
> 
> On the other hand, at hist_entry__dso_snprintf() in util/sort.c, there
> is the code
> prints "[unknown]" for unresolvable DSO name.
> 
>     return repsep_snprintf(bf, size, "%-*s", width, "[unknown]");
> 
> In addition, perf uses "[]" for DSO name for example "[kernel.kallsyms]".
> So, I chose it. However, this specification is not easy for user-scripts.
> Should I unify this expression?

That was my thought -- to use the same for both dso and sym if it is
unknown. And since DSO names are wrapped in () use "[unknown]" for both
-- ie., right now the format is  "symname (dsoname)" (though kernel syms
from kallsyms come out as "symname ([kernel.kallsyms])"). With an
unknown it will be "[unknown] (dsoname)" or "[unknown] ([unknown])"
which retains the number of fields in a uniquely parse-able way.

David
