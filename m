Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759670Ab2EVCRL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 22:17:11 -0400
Received: from mga09.intel.com ([134.134.136.24]:5177 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759654Ab2EVCRI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 22:17:08 -0400
MIME-Version: 1.0
In-Reply-To: <87d35x6pzv.fsf@xmission.com>
References: <1337284200-1838-1-git-send-email-auke-jan.h.kok@intel.com>
	<87havchd14.fsf@xmission.com>
	<CABsxX9J+KVSbxVahg-iVsfeNDEM_H8+MrcBBejjCZFrcNCxwtA@mail.gmail.com>
	<87d35x6pzv.fsf@xmission.com>
Date: Tue, 22 May 2012 02:17:06 +0000
Message-ID: <CABsxX9JC0vDkxOOwBrzZ10=ZJHfmPL-1+MakZ1PP15htvvQfCA@mail.gmail.com>
Subject: Re: [PATCH] Trace event for capable().
From: "Kok, Auke-jan H" <auke-jan.h.kok@intel.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Serge Hallyn <serge.hallyn@canonical.com>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        Eric Paris <eparis@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 22, 2012 at 12:03 AM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
> "Kok, Auke-jan H" <auke-jan.h.kok@intel.com> writes:
>
>> On Fri, May 18, 2012 at 11:59 PM, Eric W. Biederman
>> <ebiederm@xmission.com> wrote:
>>> Auke Kok <auke-jan.h.kok@intel.com> writes:
>>>
>>> > Add a simple trace event for capable().
>>> >
>>> > There's been a lot of discussion around capable(), and there
>>> > are plenty of tools to help reduce capabilities' usage from
>>> > userspace. A major gap however is that it's almost impossible
>>> > to see or verify which bits are requested from either userspace
>>> > or in the kernel.
>>> >
>>> > This patch adds a minimal tracer that will print out which
>>> > CAPs are requested and whether the request was granted.
>>>
>>> A small comment assigned from the other issues.
>>>
>>> current->pid for anything going to userspace is broken,
>>> and in fact current->pid should be killed on of these days.
>>>
>>> Which pid namespace is your tracer running in?
>>
>> init - I currently have no need for namespaces myself at all, and, as I replied
>> to Serge and Eric already - I'll see if I can fis up the tracer with their
>> suggestions.
>
> Thanks.
>
> A quick read of perf_event_open shows that the syscall is allowed by
> unprivileged users in any context if sysctl_perf_event_paranoid is
> set properly.  So it looks like the perf code needs to handle namespaces
> properly if we are going to be reporting namespaced values like uid
> and pids.  Even if no one cares today what about next week?

I thought about dropping current->pid from this patch entirely and referring
to the comm+pid combination that is already printed in the event log.

That avoids the issue entirely on one side, and defers the problem with
namespaces entirely to the perf code, where it should probably be solved
in a consistend way anyway.

Would that be an appropriate solution, or do you think it's preferable to
fix the trace event to properly annotate namespaces? I'm slanting towards
just dropping current->pid from this patch for now.

Auke

>
> Eric
