Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756075Ab1AKOAY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 09:00:24 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:47837 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755788Ab1AKOAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 09:00:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=wpGYqfAEmrn2NNkVkvZEClf/l74Hhjq9Anjo1tFlMqhvqVkcEP9BUhDnAhACIjrrsh
         4mtx9dpVjvQubMlPW3S/uj2RMRVb5Xh1Rxkal6d6fOp5pF8P08GJ6OJ1a84yE700cwbY
         wO70NYgfZOh7zDPCKjDDpe5AuBXqEdV4YA260=
Date: Tue, 11 Jan 2011 22:00:05 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: Bharata B Rao <bharata@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Mike Galbraith <efault@gmx.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH -tip 1/2] [PATCH -tip 1/2] sched: Reinstate group names
 in /proc/sched_debug.
Message-ID: <20110111140005.GA6069@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <20110111101040.GD4772@in.ibm.com>
 <20110111101153.GE4772@in.ibm.com>
 <20110111124658.GA4507@zhy>
 <20110111134244.GJ4772@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20110111134244.GJ4772@in.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 11, 2011 at 07:12:44PM +0530, Bharata B Rao wrote:
> The group name is generated in a global buffer which is protected by
> this lock. Earlier small sized local buffer (on stack) was used for
> this purpose which wasn't ideal. Also since we can be here from
> interrupt context, I wanted to avoid allocation too. Hence went for
> a global buffer protected by a lock.

Sounds good ;)

BTW, I guess we can also remove rcu_read_lock/unlock() in print_rt_stats()
and print_cfs_stats() with sched_debug_lock hold.

Thanks,
Yong
