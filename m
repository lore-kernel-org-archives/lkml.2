Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756775Ab0JEVEr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 17:04:47 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46189 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752136Ab0JEVEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 17:04:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=wqn1aIDUb0A82ZzuaptdxOQxhXXi6zidIDGrhjMsFBlrbDEnZlRebdb6WEMaqYMhxU
         el+vCBUINuZcRe91FcjvFJdEHJuhR7TmMpBEvq0tjfCsl3FZh8cf9PdS0xqjTliUQjU5
         usYWAVQpX2urPsrAA6hKT4/seURz4k2MQpf9I=
Message-ID: <4CAB92E9.7060509@suse.cz>
Date: Tue, 05 Oct 2010 23:04:41 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.9) Gecko/20100914 SUSE/3.1.4 Thunderbird/3.1.4
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de,
        linux-kernel@vger.kernel.org
Subject: Re: + softirq-cleanup-preempt-check.patch added to -mm tree
References: <201010051905.o95J5BrS013873@imap1.linux-foundation.org> <20101005193833.GA16493@elte.hu>
In-Reply-To: <20101005193833.GA16493@elte.hu>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/05/2010 09:38 PM, Ingo Molnar wrote:
> 
> * akpm@linux-foundation.org <akpm@linux-foundation.org> wrote:
> 
>> +static inline void softirq_preempt_check(struct softirq_action *h,
>> +		int prev_count)
> 
> unnecessary linebreak.

How unnecessary is this linebreak:
$ wc -c
static inline void softirq_preempt_check(struct softirq_action *h, int
prev_count)
83

People, including me, still work with 80-col terminals. What I can
tolerate are undivided strings, because it sucks if one cannot grep for
anything from the log.

>> +	if (unlikely(prev_count != preempt_count())) {
> 
> should be something like:
> 
> 	if (prev_count == preempt_count())
> 		return;
> 
> then the rest will look cleaner as well.

Yeah, I thought about that, but it doesn't make sense. Sometime later if
someone would want to add another check there, they would have to put
all that stuff back. And also it doesn't help readability in any way.

>> +		printk(KERN_ERR "huh, entered softirq %td %s %pf with preempt_count %08x, exited with %08x?\n",
> 
> Could be pr_err().

It could, but I dislike those just because 'pr' doesn't mean 'print'
anymore and beginners are getting lost like never before. If it only was
print_err.

>> +			softirq_preempt_check(h, prev_count);
> 
> Please put 'debug' in the function name as i suggested - that way people 
> will only read it if they are interested in debug checks.
> 
> softirq_debug_check() would be perfect. (which might even grow new 
> checks in the future)

Actually, not that perfect. Before I renamed the function to
softirq_preempt_check, it looked like to me: Hmm, there is a debug
check. What does it check?

With softirq_preempt_check, it does exactly what the name says. And
'check' says, it's just a some kind of sanity test. At least to me.

thanks,
-- 
js
suse labs
