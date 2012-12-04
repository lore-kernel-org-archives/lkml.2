Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754528Ab2LDOJN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 09:09:13 -0500
Received: from mail-ie0-f171.google.com ([209.85.223.171]:63631 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753939Ab2LDOJK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 09:09:10 -0500
X-Greylist: delayed 360 seconds by postgrey-1.27 at vger.kernel.org; Tue, 04 Dec 2012 09:09:10 EST
MIME-Version: 1.0
In-Reply-To: <CAAmnkz=gJ02Uad6bgbCAuE0EPjcWXK9VrWo-3C1yK_XbmA4Xow@mail.gmail.com>
References: <CAAmnkz=gJ02Uad6bgbCAuE0EPjcWXK9VrWo-3C1yK_XbmA4Xow@mail.gmail.com>
Date: Tue, 4 Dec 2012 06:03:09 -0800
Message-ID: <CAAmnkzkzCg8tR0k4VZRp_HPErE73ykFc7K8SpqEi7AU_6Dyk=g@mail.gmail.com>
Subject: Re: BUG: wait_task_zombie NULL dereference
From: "Bill Huey (hui)" <bill.huey@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: ebiederm@xmission.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I should add that I encountered this on 3.6.0 with some mild
modifications to the scheduler path that enqueue/dequeue a task before
any of the schedule exit logic gets hit. The SCHED_FF/FIFO rebalancer
does much the same so I can't imagine that being the source of the
problem.

I could be wrong however.

bill

On Tue, Dec 4, 2012 at 5:48 AM, Bill Huey (hui) <bill.huey@gmail.com> wrote:
> I'm hitting this under a heavy scheduler test load with SCHED_RR tasks
> exiting normally after completion and the parent exiting with some of
> the pthreads still running:
