Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754134Ab1HaGpl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 02:45:41 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:59754 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752735Ab1HaGpj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 02:45:39 -0400
Message-ID: <4E5DD88D.8050007@suse.cz>
Date: Wed, 31 Aug 2011 08:45:33 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Andi Kleen <ak@linux.intel.com>, Andi Kleen <andi@firstfloor.org>,
        linux-kernel@vger.kernel.org, eric.dumazet@gmail.com
Subject: Re: [PATCH 2/4] posix-timers: limit the number of posix timers per
 process
References: <1314661157-22173-1-git-send-email-andi@firstfloor.org> <1314661157-22173-2-git-send-email-andi@firstfloor.org> <20110830144407.acdae071.akpm@linux-foundation.org> <4E5D5EE6.3070708@linux.intel.com> <20110830152216.dffd3cc3.akpm@linux-foundation.org> <4E5D6893.5010505@linux.intel.com> <20110830160238.90eaa998.akpm@linux-foundation.org>
In-Reply-To: <20110830160238.90eaa998.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/31/2011 01:02 AM, Andrew Morton wrote:
> On Tue, 30 Aug 2011 15:47:47 -0700
> Andi Kleen<ak@linux.intel.com>  wrote:
>
>>
>>> Yes, deployment for new rlimits is a big PITA.  It would be sensible to
>>> modify the shells to take some anonymous numeric argument, so you could
>>> do
>>>
>>> 	ulimit 42 1000
>>>
>>> to set rlimit number 42 if your shell version doesn't understand the
>>> symbolic representation of more recent additions.  Who do I call?
>>
>> I guess sending a patch to the bash maintainers?
>>
>
> That would help ;)  And all the other shells :(
>
> It would be worth going back and taking another look at the writable
> /proc/<pid>/limits patches (http://lwn.net/Articles/365732/).  Why
> didn't that work get merged?

This turned out to be too heavy-weight. We ended up having prlimit64 
syscall. I.e. most of the pull request was merged. But not the 2 patches 
for writable /proc/.../limits.

With that syscall we might augment coreutils (or better kernel/tools to 
be updated properly) by a tool such as `prlimit', I think. Actually 
something I had when I was testing the syscall:
https://github.com/jirislaby/collected_sources/blob/master/lim/lim.c#L1

regards,
-- 
js
suse labs
