Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932361Ab1KDPZR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 11:25:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1591 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755416Ab1KDPZP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 11:25:15 -0400
Message-ID: <4EB403C0.9030503@redhat.com>
Date: Fri, 04 Nov 2011 10:24:48 -0500
From: David Smith <dsmith@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Pedro Alves <pedro@codesourcery.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC PATCH v2] Tracepoint: add exec tracepoint
References: <4EB2BA74.5070207@redhat.com> <201111041208.38163.pedro@codesourcery.com>
In-Reply-To: <201111041208.38163.pedro@codesourcery.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/04/2011 07:08 AM, Pedro Alves wrote:

> On Thursday 03 November 2011 15:59:48, David Smith wrote:
>> +                               if (depth == 0) {
>> +                                       trace_sched_process_exec(current, bprm);
>>                                         ptrace_event(PTRACE_EVENT_EXEC,
>>                                                         old_pid);
>> +                               }
> 
> Won't tracepoints be interested in the old pid as well?  Or does bprm
> carry that info?  That was only recently added to the ptrace event,
> which probably postdates your original patch.


Looking back at commit bb188d7 and the reasons why 'old_pid' was added,
it seems like a good idea to go ahead and add 'old_pid' to the
tracepoint as well.

v3 coming up...

Thanks for looking at this.

-- 
David Smith
dsmith@redhat.com
Red Hat
http://www.redhat.com
256.217.0141 (direct)
256.837.0057 (fax)
