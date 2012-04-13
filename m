Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753081Ab2DMOQ0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 10:16:26 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55031 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751631Ab2DMOQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 10:16:24 -0400
Message-ID: <4F8834F5.9040605@gmail.com>
Date: Fri, 13 Apr 2012 08:15:17 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>
CC: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] perf, tool: Force guest machine definition option
References: <1334233262-5679-1-git-send-email-jolsa@redhat.com> <1334233262-5679-2-git-send-email-jolsa@redhat.com> <4F86E965.4010506@gmail.com> <20120413113207.GB3384@m.brq.redhat.com> <4F881A62.8060109@gmail.com> <20120413124129.GC3384@m.brq.redhat.com>
In-Reply-To: <20120413124129.GC3384@m.brq.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/13/12 6:41 AM, Jiri Olsa wrote:
> I get same error even on acme's urgent branch.. do you mean
> below one?  It fixes the guest machine lookup for mmap event.
>
> perf kvm: Finding struct machine fails for PERF_RECORD_MMAP
> commit 7fb0a5ee8889488f7568ffddffeb66ddeb50917e
> Author: Nikunj A. Dadhania<nikunj@linux.vnet.ibm.com>
> Date:   Mon Apr 9 13:52:23 2012 +0530

That's the one I was referring to.

>
> In my case it looks like for some reason the guest buildid DSO
> is not stored in record phase (no hits maybe?), so report won't
> create guest machine record at all and get NULL machine.

I see now -- different problem, but similar in that it's an mmap event 
and the pid is 0.

I need to take my daughter to school and won't get back to this for a 
while but what I am seeing is that on perf-record mmap events are 
generated with pid set to DEFAULT_GUEST_KERNEL_ID = 0 
(machines__create_guest_kernel_maps).

On the report side a machine has not been created for pid of 0, so the 
look up in perf_session__find_machine_for_cpumode fails.

David
