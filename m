Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932255Ab1FGSXA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 14:23:00 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:11889 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932240Ab1FGSW7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 14:22:59 -0400
Message-ID: <4DEE6C82.4000901@caviumnetworks.com>
Date: Tue, 07 Jun 2011 11:22:58 -0700
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: David Daney <ddaney.cavm@gmail.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: Re: [PATCH 2/3] kprobes/trace: Fix kprobe selftest for gcc 4.6
References: <20110607170740.235441001@goodmis.org>	 <20110607170827.295368694@goodmis.org>  <4DEE6903.9010501@gmail.com> <1307470377.9218.3.camel@gandalf.stny.rr.com>
In-Reply-To: <1307470377.9218.3.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 07 Jun 2011 18:22:58.0343 (UTC) FILETIME=[ED6D4370:01CC253F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/07/2011 11:12 AM, Steven Rostedt wrote:
> On Tue, 2011-06-07 at 11:08 -0700, David Daney wrote:
>
>>> -static int kprobe_trace_selftest_target(int a1, int a2, int a3,
>>> -					int a4, int a5, int a6)
>>> +/*
>>> + * Can't be static, otherwise gcc might optimize this to
>>> + * not be in the kallsyms table.
>>> + */
>>
>> Could you make it '__used' instead?
>>
>
> I can try, but the problem is not that the function itself is being
> optimized out. It looks like its being turned into anonymous text. That
> is, it optimized out the symbol name, not the code itself.
>

Really it is no big deal either way.  Just a thought I had.

David Daney
