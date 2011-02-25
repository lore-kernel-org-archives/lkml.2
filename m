Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755022Ab1BYLqV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 06:46:21 -0500
Received: from mail.in-telegence.net ([83.125.45.125]:56968 "EHLO
	amg.in-telegence.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751928Ab1BYLqU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 06:46:20 -0500
X-CTCH-RefID: str=0001.0A0B020B.4D679688.02E0,ss=1,fgs=0
Message-ID: <4D679688.7020503@in-telegence.net>
Date: Fri, 25 Feb 2011 12:46:16 +0100
From: Dominik Klein <dk@in-telegence.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.13) Gecko/20101207 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Vivek Goyal <vgoyal@redhat.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        libvir-list@redhat.com
Subject: Re: Is it a workqueue related issue in 2.6.37 (Was: Re: [libvirt]
 blkio cgroup [solved])
References: <4D63BA3B.7070809@in-telegence.net> <20110222152426.GD28269@redhat.com> <20110222190953.GF28269@redhat.com> <4D650D7E.4050908@in-telegence.net> <4D662248.6040405@in-telegence.net> <20110224142303.GA18494@redhat.com> <20110224143105.GL7840@htj.dyndns.org> <4D66720E.70102@in-telegence.net> <20110224151701.GQ7840@htj.dyndns.org> <4D67591F.10105@in-telegence.net> <20110225112936.GH24828@htj.dyndns.org>
In-Reply-To: <20110225112936.GH24828@htj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

>> This was taken with 2.6.37 plus the patch you mentioned on a Dell R815
>> with 2 12 core AMD Opteron 6174 CPUs. If you need any more information,
>> please let me know.
> 
> Hmmm... well, I have no idea what you were trying to do 

Long story short: I have a couple of virtual machines. Some of them have
blkio throttle configured, some don't. To simulate whether the
throttling works, I start
dd if=/dev/zero of=testfile bs=1M count=1500
in each guest simultaneously.

The result is that from that point, no i/o is happening any more. You
see the result in the trace.

With 2.6.37 (also tried .1 and .2) it does not work but end up like I
documented. With 2.6.38-rc1, it does work. With deadline scheduler, it
also works in 2.6.37.

I am in bisect run 2 currently to find the changeset that fixed it.

Will let you know as soon as I do.

Regards
Dominik

ps. I am by no means a kernel hacker and none of the rest of your email
made any sense to me. Sorry.

> but here are
> some info which might be helpful.
> 
> * queue_work happens when the work item is queued.
> 
> * activate_work happens when the work item becomes eligible for
>   execution.  e.g. If the workqueue's @max_active is limited and
>   maximum number of work items are already in flight, a new item will
>   only get activated after one of the in flight ones retires.
> 
> * execute_start marks the actual starting of execution.
> 
> * execute_end marks the end of execution.
> 
> So, I would look for the matching work function and then try to follow
> what happens to it after being scheduled and if it doesn't get
> executed what's going on with the target workqueue.
> 
> Thanks.
