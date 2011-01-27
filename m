Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753703Ab1A0Iut (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 03:50:49 -0500
Received: from smtp1-g21.free.fr ([212.27.42.1]:55870 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752243Ab1A0Ius (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 03:50:48 -0500
Message-ID: <4D4131DE.3080309@free.fr>
Date: Thu, 27 Jan 2011 09:50:38 +0100
From: Daniel Lezcano <daniel.lezcano@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Li Zefan <lizf@cn.fujitsu.com>, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, libvir-list@redhat.com
Subject: Re: [PATCH] cgroup : remove the ns_cgroup
References: <1295948388-15108-1-git-send-email-daniel.lezcano@free.fr>	<20110126161837.43830756.akpm@linux-foundation.org>	<4D40C5A3.4070703@cn.fujitsu.com> <20110126174513.c2a20fff.akpm@linux-foundation.org>
In-Reply-To: <20110126174513.c2a20fff.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/27/2011 02:45 AM, Andrew Morton wrote:
> On Thu, 27 Jan 2011 09:08:51 +0800 Li Zefan<lizf@cn.fujitsu.com>  wrote:
>
>> Andrew Morton wrote:
>>> On Tue, 25 Jan 2011 10:39:48 +0100
>>> Daniel Lezcano<daniel.lezcano@free.fr>  wrote:
>>>
>>>> This patch removes the ns_cgroup as suggested in the following thread:
>>> I had this patch queued up in September last year, but dropped it.  Why
>>> did I do that?
>> Because you wanted to wait for some time for users (if any) to notice this
>> coming change.
>>
>> Author: Daniel Lezcano<daniel.lezcano@free.fr>
>> Date:   Wed Oct 27 15:33:38 2010 -0700
>>
>>      cgroup: notify ns_cgroup deprecated
>>
>>      The ns_cgroup will be removed very soon.  Let's warn, for this version,
>>      ns_cgroup is deprecated.
>>
>>      Make ns_cgroup and clone_children exclusive.  If the clone_children is set
>>      and the ns_cgroup is mounted, let's fail with EINVAL when the ns_cgroup
>>      subsys is created (a printk will help the user to understand why the
>>      creation fails).
>>
>>      Update the feature remove schedule file with the deprecated ns_cgroup.
>>
>>      Signed-off-by: Daniel Lezcano<daniel.lezcano@free.fr>
>>      Acked-by: Paul Menage<menage@google.com>
>>      Signed-off-by: Andrew Morton<akpm@linux-foundation.org>
>>      Signed-off-by: Linus Torvalds<torvalds@linux-foundation.org>
> ooh, that was clever of me.
>
> Here is the text which was missing from the changelog:
>
>    This is a userspace-visible change.  Commit 45531757b45c ("cgroup:
>    notify ns_cgroup deprecated") (merged into 2.6.27) caused the kernel
>    to emit a printk warning users that the feature is planned for
>    removal.  Since that time we have heard from XXX users who were
>    affected by this.
>
> Please provide XXX.

Ok, AFAIK nobody makes use of the ns_cgroup except the LXC userspace 
tools which I maintain and where
the backward compatibility with the ns_cgroup and the clone_children 
flag is already implemented.
Since today nobody seems to be affected by this.

I Cc'ed the libvirt mailing list.

> How do we know that 2.6.37->2.6.38 is long enough?  Will any major
> distros be released containing this warning in that timeframe?  I doubt
> it.

Hmm, maybe it is too short but I don't think someone will complain about 
this feature removal.
Google chromium is using the namespaces, hence a lot of cgroup is 
created on the system. The vsftpd and some pam modules uses the 
namespaces too.
I won't be surprised if one of these applications fails with 'clone' 
returning EEXIST ...

