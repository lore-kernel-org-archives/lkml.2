Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756234Ab1LWBzh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 20:55:37 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:47287 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754004Ab1LWBzd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 20:55:33 -0500
Date: Thu, 22 Dec 2011 17:58:34 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, avi@redhat.com, nate@cpanel.net,
        cl@linux-foundation.org, oleg@redhat.com, axboe@kernel.dk,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET] block, mempool, percpu: implement percpu mempool and
 fix blkcg percpu alloc deadlock
Message-Id: <20111222175834.66559c8b.akpm@linux-foundation.org>
In-Reply-To: <20111223014043.GC12738@redhat.com>
References: <1324590326-10135-1-git-send-email-tj@kernel.org>
	<20111222135925.de3221c8.akpm@linux-foundation.org>
	<20111222220911.GK17084@google.com>
	<20111222142058.41316ee0.akpm@linux-foundation.org>
	<20111223014043.GC12738@redhat.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Dec 2011 20:40:43 -0500 Vivek Goyal <vgoyal@redhat.com> wrote:

> That's why the need of per cpu data structures to make stat collection
> lockless.

btw, (and this is a common refrain): was there any reason for avoiding
using percpu_counters here?

afacit these stats don't have the transient-negative-number problem
because they're purely upcounters, but percpu_counters would be helpful
when num_online_cpus is much less than num_possible_cpus.  Plus it would
avoid implementing yet another hand-coded percpu_counter...



