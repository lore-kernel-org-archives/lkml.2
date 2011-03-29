Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752212Ab1C2I7u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 04:59:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53833 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751237Ab1C2I7r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 04:59:47 -0400
Message-ID: <4D919F75.5070601@redhat.com>
Date: Tue, 29 Mar 2011 10:59:33 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.9
MIME-Version: 1.0
To: John Lepikhin <johnlepikhin@gmail.com>
CC: Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org,
        xfs@oss.sgi.com, linux-mm@kvack.org
Subject: Re: Very aggressive memory reclaim
References: <AANLkTinFqqmE+fTMTLVU-_CwPE+LQv7CpXSQ5+CdAKLK@mail.gmail.com>	<20110328215344.GC3008@dastard> <AANLkTi==vw7Dy-oK31PxHadwUaDRUUk+TM0ECSZ=chfv@mail.gmail.com>
In-Reply-To: <AANLkTi==vw7Dy-oK31PxHadwUaDRUUk+TM0ECSZ=chfv@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/29/2011 09:26 AM, John Lepikhin wrote:
> 2011/3/29 Dave Chinner<david@fromorbit.com>:
>
> >  First it would be useful to determine why the VM is reclaiming so
> >  much memory. If it is somewhat predictable when the excessive
> >  reclaim is going to happen, it might be worth capturing an event
> >  trace from the VM so we can see more precisely what it is doiing
> >  during this event. In that case, recording the kmem/* and vmscan/*
> >  events is probably sufficient to tell us what memory allocations
> >  triggered reclaim and how much reclaim was done on each event.
>
> Do you mean I must add some debug to mm functions? I don't know any
> other way to catch such events.

Download and build trace-cmd 
(git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/trace-cmd.git), 
and do

$ trace-cmd record -e kmem -e vmscan -b 30000

Hit ctrl-C when done and post the output file generated in cwd.

-- 
error compiling committee.c: too many arguments to function

