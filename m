Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759241Ab2CFVrl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 16:47:41 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:62080 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759117Ab2CFVrh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 16:47:37 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of koct9i@gmail.com designates 10.204.155.143 as permitted sender) smtp.mail=koct9i@gmail.com; dkim=pass header.i=koct9i@gmail.com
Message-ID: <4F5685E9.4010900@openvz.org>
Date: Wed, 07 Mar 2012 01:47:21 +0400
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120217 Firefox/10.0.2 Iceape/2.7.2
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: Re: [PATCH bisected regression] sched: rebuild sched domains at suspend/resume
References: <20120306204357.13169.90791.stgit@zurg> <1331067743.11248.333.camel@twins>
In-Reply-To: <1331067743.11248.333.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Wed, 2012-03-07 at 00:45 +0400, Konstantin Khlebnikov wrote:
>> This is fix for suspend/resume regression introduced in commit 8f2f748b0656
>> ("CPU hotplug, cpusets, suspend: Don't touch cpusets during suspend/resume")
>> Without this patch suspend always hangs on my thinkpad x220 (2 x CPU * HT).
>>
>> cpuset_update_active_cpus() not only juggles with bits in cpusets,
>> it also calls sched-domains rebuilding after all.
>>
>> This patch restores sched-domain rebuilds, as it was before that commit.
>
> This changelog also completely fails to explain what the problem was and
> how this patch sorts it without re-introducing the problems 8f2f748b0656
> was supposed to fix.

That patch removes cpuset bits clearing on suspend/resume cycle. My patch doesn't clear them too.
I don't know why these domain rebuilds are required, so I just returned them back.

>
> I'd rather revert the 'fix' and think about this more (its been broken
> pretty much forever anyway) than tinker on top like this.

Ok, "rc" isn't the best time that.
