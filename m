Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757356Ab0I1RXD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 13:23:03 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:49841 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752082Ab0I1RXB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 13:23:01 -0400
Date: Tue, 28 Sep 2010 10:16:41 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk
Subject: Re: [PATCH 4/4] blkio: Recalculate the throttled bio dispatch time
 upon throttle limit change
Message-Id: <20100928101641.a2791513.randy.dunlap@oracle.com>
In-Reply-To: <1285693859-13591-5-git-send-email-vgoyal@redhat.com>
References: <1285693859-13591-1-git-send-email-vgoyal@redhat.com>
	<1285693859-13591-5-git-send-email-vgoyal@redhat.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Sep 2010 13:10:59 -0400 Vivek Goyal wrote:

> o Currently any cgroup throttle limit changes are processed asynchronousy and
>   the change does not take affect till a new bio is dispatched from same group.
> 
> o It might happen that a user sets a redicuously low limit on throttling.
>   Say 1 bytes per second on reads. In such cases simple operations like mount
>   a disk can wait for a very long time.
> 
> o Once bio is throttled, there is no easy way to come out of that wait even if
>   user increases the read limit later.
> 
> o This patch fixes it. Now if a user changes the cgroup limits, we recalculate
>   the bio dispatch time according to new limits.
> 
> o Can't take queueu lock under blkcg_lock, hence after the change I wake
>   up the dispatch thread again which recalculates the time. So there are some
>   variables being synchronized across two threads without lock and I had to
>   make use of barriers. Hoping I have used barriers correctly. Any review of
>   memory barrier code especially will help.


Hi,
Has this report been addressed/fixed?


on i386:

blk-throttle.c:(.text+0x1abb8): undefined reference to `__udivdi3'
blk-throttle.c:(.text+0x1b1dc): undefined reference to `__udivdi3'


on linux-next 2010-0924 and 2010-0927.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
