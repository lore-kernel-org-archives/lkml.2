Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753762Ab1BHBGQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 20:06:16 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:52628 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753133Ab1BHBGP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 20:06:15 -0500
X-AuditID: b753bd60-a24c5ba0000066fd-0f-4d509704e526
X-AuditID: b753bd60-a24c5ba0000066fd-0f-4d509704e526
Message-ID: <4D5096F7.7040206@hitachi.com>
Date: Tue, 08 Feb 2011 10:05:59 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        2nddept-manager@sdl.hitachi.co.jp,
        Borislav Petkov <borislav.petkov@amd.com>,
        Denis Kirjanov <dkirjanov@kernel.org>,
        Franck Bui-Huu <fbuihuu@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "H . Peter Anvin" <hpa@zytor.com>, Kyle McMartin <kyle@redhat.com>,
        Michael Witten <mfwitten@gmail.com>, Mike Galbraith <efault@gmx.de>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, Tom Zanussi <tzanussi@gmail.com>
Subject: Re: [PATCH 0/9] perf/core improvements and fixes
References: <1297090812-10782-1-git-send-email-acme@infradead.org> <20110207150640.GA20053@elte.hu> <20110207162916.GB4470@ghostprotocols.net> <20110207173653.GC4470@ghostprotocols.net>
In-Reply-To: <20110207173653.GC4470@ghostprotocols.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/02/08 2:36), Arnaldo Carvalho de Melo wrote:
> Em Mon, Feb 07, 2011 at 02:29:16PM -0200, Arnaldo Carvalho de Melo escreveu:
>> Em Mon, Feb 07, 2011 at 04:06:40PM +0100, Ingo Molnar escreveu:
>>> * Arnaldo Carvalho de Melo <acme@infradead.org> wrote:
>>>> Masami Hiramatsu (4):
>>>>   perf probe: Add bitfield member support
>>>
>>> hm, the perf probe bits do not build on 32-bit:
>>>
>>> util/probe-finder.c: In function ‘convert_variable_type’:
>>> util/probe-finder.c:881: error: format ‘%lu’ expects type ‘long unsigned int’, but argument 6 has type ‘unsigned int’
>>> util/probe-finder.c:881: error: format ‘%lu’ expects type ‘long unsigned int’, but argument 6 has type ‘unsigned int’
>>> make: *** [util/probe-finder.o] Error 1
>>> make: *** Waiting for unfinished jobs....
>>
>> I already reworked this and force pushed, see:
>>
>> http://git.kernel.org/?p=linux/kernel/git/acme/linux-2.6.git;a=commitdiff;h=2b4f8985a2c2309852d20d16d3589eba15b64c4e
>>
>> [ committer note: Fixed up '%lu' use for return of die_get_byte_size (int) ]
> 
> Argh, I used '%d', which is ok on 32-bit, but then, breaks 64-bit, i.e.
> the right format is '%zd' since the expression is '... / sizeof(foo)',
> test built on both 64 and 32 bit, this time around it seems final.
> 
> Just give it some time to go from master to git.k.o.

Oops, thanks Arnaldo and Ingo!
BTW, is there any good way to build 32bit perf on x86-64?

-- 
Masami HIRAMATSU
2nd Dept. Linux Technology Center
Hitachi, Ltd., Systems Development Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
