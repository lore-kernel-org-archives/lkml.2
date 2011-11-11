Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758084Ab1KKROD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 12:14:03 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:10836 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753570Ab1KKROB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 12:14:01 -0500
Message-ID: <4EBD57D4.1060503@parallels.com>
Date: Fri, 11 Nov 2011 21:13:56 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Glauber Costa <glommer@parallels.com>, Nathan Lynch <ntl@pobox.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Serge Hallyn <serue@us.ibm.com>, Daniel Lezcano <dlezcano@fr.ibm.com>
Subject: Re: [PATCH 3/3] pids: Make it possible to clone tasks with given
 pids
References: <20111110184654.GA1006@redhat.com> <20111110185603.GA1757@redhat.com> <4EBCF4E7.4090002@parallels.com> <20111111152532.GA22640@redhat.com> <4EBD461E.1000106@parallels.com> <CAOS58YOW5KpP3OJDd5PqsMUg6PicnLW6jH_5Hb7WGPsnCYXGBw@mail.gmail.com> <CAOS58YOS77+WZt19qu_72DPgEPdwTdkD88J6RNR4a3x0h-2Qkw@mail.gmail.com> <4EBD4ACB.2070001@parallels.com> <20111111162200.GA24737@google.com> <4EBD522E.2000203@parallels.com> <20111111170244.GB24737@google.com>
In-Reply-To: <20111111170244.GB24737@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11/2011 09:02 PM, Tejun Heo wrote:
> Hello,
> 
> On Fri, Nov 11, 2011 at 08:49:50PM +0400, Pavel Emelyanov wrote:
>> 1 cpu 500k forks                                         - 37s
> 
> That's ~14k forks per sec.  Do you still think you need parallel
> forking?
> 
>> 2 cpus on different cores 500k forks on each in parallel - 39s
>> 4 cpus on different cores 500k forks on each in parallel - 41s
>>
>> 8 cpus 500k forks on each in parallel                    - 1m5s
>>
>> So the fork() scaling seems quite good to me.
> 
> Yeah, looks pretty good actually.  Hmmm, this is on a single socket w/
> shared cache where cacheline bouncing is quite cheap, right?  Also,
> how are those forking processes related?  On multiple sockets, it's
> gonna scale worse.  Dunno how much tho.
> 
> At any rate, if you do the rest in paralllel, whether forking is
> parallel or not is immaterial.  Let's just do something least
> intrusive.

Hm, so intrusiveness is your main concern here, I see.

OK, let's assume we go with sysctl setting the last_pid.

One of the major concerns with previous attempts have been - someone creates 
a process with a pid that was in use by some app recently and screws things 
up with pid reuse. My approach solves this, how can sysctl handle it? Allowing 
the last_pid change by the CAP_SYA_ADMIN only is not an option, since people
are looking forward to non-root restore.

> Thanks.
> 

