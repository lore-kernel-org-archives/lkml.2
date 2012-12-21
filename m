Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751745Ab2LUJRB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 04:17:01 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:54409 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417Ab2LUJQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 04:16:48 -0500
X-AuditID: 9c93016f-b7b54ae000000e9e-b0-50d428fe3b78
From: Namhyung Kim <namhyung@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Pekka Enberg <penberg@kernel.org>
Subject: Re: [PATCH 6/6] perf annotate: Add --gtk option
References: <1356078018-31905-1-git-send-email-namhyung@kernel.org>
	<1356078018-31905-7-git-send-email-namhyung@kernel.org>
	<20121221083205.GA15226@liondog.tnic>
Date: Fri, 21 Dec 2012 18:16:46 +0900
In-Reply-To: <20121221083205.GA15226@liondog.tnic> (Borislav Petkov's message
	of "Fri, 21 Dec 2012 09:32:05 +0100")
Message-ID: <878v8repdt.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Boris,

On Fri, 21 Dec 2012 09:32:05 +0100, Borislav Petkov wrote:
> On Fri, Dec 21, 2012 at 05:20:18PM +0900, Namhyung Kim wrote:
>> Now we have GTK2 implementation, add a new --gtk option to use it.
>> 
>> Cc: Pekka Enberg <penberg@kernel.org>
>> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
>> ---
>>  tools/perf/Documentation/perf-annotate.txt | 4 ++++
>>  tools/perf/builtin-annotate.c              | 5 ++++-
>>  2 files changed, 8 insertions(+), 1 deletion(-)
>> 
>> diff --git a/tools/perf/Documentation/perf-annotate.txt b/tools/perf/Documentation/perf-annotate.txt
>> index c8ffd9fd5c6a..482e1f753127 100644
>> --- a/tools/perf/Documentation/perf-annotate.txt
>> +++ b/tools/perf/Documentation/perf-annotate.txt
>> @@ -66,6 +66,10 @@ OPTIONS
>>  	used. This interfaces starts by centering on the line with more
>>  	samples, TAB/UNTAB cycles through the lines with more samples.
>>  
>> +--gtk:: Use the GTK interface. Use of --gtk requires (but not uses) a tty,
>
> What does that even mean?
>
> * it requires one but doesn't use it by default
>
> * it requires one but if none is present, falls back to stdio
>
> * it simply checks for tty presence and uses something completely different
>
> * something else
>
> ?

Hmm.. sorry for the unclear message.  I just copied description of --tui
option and failed to make it clear. :/

Current setup_browser() code checks the stdin to be a tty and if not it
assumes piping to other commands so set the use_browser to 0 (stdio) and
disables GTK output.

Maybe we can change this behavior for --gtk case.


>> @@ -307,6 +308,8 @@ int cmd_annotate(int argc, const char **argv, const char *prefix __maybe_unused)
>>  		use_browser = 0;
>>  	else if (annotate.use_tui)
>>  		use_browser = 1;
>> +	else if (annotate.use_gtk)
>> +		use_browser = 2;
>
> Btw, acme, those use_browser values could use proper defines like:
>
> #define PERF_BROWSER_NONE	0
> #define PERF_BROWSER_TUI	1
> #define PERF_BROWSER_GTK	2
>
> or even an enum or whatever else comes natural in perf-speak.

Looks good, will change in the next spin.

Thanks,
Namhyung
