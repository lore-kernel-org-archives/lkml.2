Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932888Ab2IUSfd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 14:35:33 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:56443 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757438Ab2IUSfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 14:35:25 -0400
Date: Fri, 21 Sep 2012 11:35:15 -0700
From: Tejun Heo <tj@kernel.org>
To: Deepawali Verma <dverma249@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Work queue questions
Message-ID: <20120921183515.GI7264@google.com>
References: <CAHCeSFpar4ykz5cr9dLrO5J4r3ZXkwbNkU1O3q=QZs9rFEyB6w@mail.gmail.com>
 <20120921174952.GF7264@google.com>
 <CAHCeSFo0QtOc4GYfMqJy4R60G_Yy+1psidUbZ2=ym8XWraGvcw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHCeSFo0QtOc4GYfMqJy4R60G_Yy+1psidUbZ2=ym8XWraGvcw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Sep 21, 2012 at 07:30:21PM +0100, Deepawali Verma wrote:
> Actually I want to make parallelization of one task into three tasks.
> Therefore I created three single threaded work queues means divide the
> task into three tasks. You are right that I can use one work queue as
> well. But when I am doing three times schedule on different work
> queues, I am seeing only one worker thread is processing the three
> times schedule though I created three different workqueues and I
> believe from previous kernel versions that there is one worker thread
> associated with one queue. If one thread does this task then there is
> no difference between doing the same task in one thread and using
> three threads.
> 
> If we create different work queues, why always one worker thread is
> processing the all tasks instead I want another two threads also work
> in parallel?

Well, that was the whole point of concurrency managed workqueue.  You
don't need to worry about the number of workers.  Concurrency is
automatically managed.  If you queue three work items on, say,
system_wq and none of them sleeps, a single worker will execute them
back to back.  If a work item sleeps, another worker will kick in.
So, in most cases, there's no need to worry about concurrency - just
use system_wq.

Thanks.

-- 
tejun
