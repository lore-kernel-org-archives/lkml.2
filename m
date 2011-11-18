Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757480Ab1KRKFx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 05:05:53 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:18519 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755163Ab1KRKFw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 05:05:52 -0500
Message-ID: <4EC62DF7.6000805@parallels.com>
Date: Fri, 18 Nov 2011 14:05:43 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alan Cox <alan@linux.intel.com>, Roland McGrath <roland@hack.frob.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, Cyrill Gorcunov <gorcunov@openvz.org>,
        James Bottomley <jbottomley@parallels.com>
Subject: Re: [PATCH 3/3] pids: Make it possible to clone tasks with given
 pids
References: <4EC4F2FB.408@parallels.com> <4EC4F348.6020101@parallels.com> <20111117183605.GA20552@redhat.com>
In-Reply-To: <20111117183605.GA20552@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/17/2011 10:36 PM, Oleg Nesterov wrote:
> My previous objection was wrong, I should try to find something else ;)
> 
> On 11/17, Pavel Emelyanov wrote:
>>
>> +static int set_pidmap(struct pid_namespace *pid_ns, int pid)
>> +{
>> +	int offset;
>> +	struct pidmap *map;
>> +
>> +	/*
>> +	 * When creating a new pid namespace we must make its init
>> +	 * have pid == 1 in it.
>> +	 */
>> +	if (pid_ns->child_reaper == NULL)
>> +		return 0;
>> +
>> +	/*
>> +	 * Don't allow to create a task with a pid which has recently
>> +	 * belonged to some other (dead already) task. Only init (of
>> +	 * a freshly created namespace) and his clones can do this.
>> +	 */
>> +	if (pid_ns->last_pid != 1)
>> +		return -EPERM;
>> +
>> +	map = &pid_ns->pidmap[pid/BITS_PER_PAGE];
> 
> probably we should check that map < PIDMAP_ENTRIES ?

Yes, you're right here. The checks for given pid being correct are required. Will fix.

> Oleg.

Thanks,
Pavel
