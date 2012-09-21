Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757761Ab2IUT10 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 15:27:26 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63488 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757722Ab2IUT1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 15:27:25 -0400
Date: Fri, 21 Sep 2012 12:27:20 -0700
From: Tejun Heo <tj@kernel.org>
To: Deepawali Verma <dverma249@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Work queue questions
Message-ID: <20120921192720.GJ7264@google.com>
References: <CAHCeSFpar4ykz5cr9dLrO5J4r3ZXkwbNkU1O3q=QZs9rFEyB6w@mail.gmail.com>
 <20120921174952.GF7264@google.com>
 <CAHCeSFo0QtOc4GYfMqJy4R60G_Yy+1psidUbZ2=ym8XWraGvcw@mail.gmail.com>
 <20120921183515.GI7264@google.com>
 <CAHCeSFpa28d-7ruMKSw6z2EYKYN-5udVouUJOi4cnj4dPad-TA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHCeSFpa28d-7ruMKSw6z2EYKYN-5udVouUJOi4cnj4dPad-TA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 21, 2012 at 08:26:01PM +0100, Deepawali Verma wrote:
>      kworker/u:1-21    [000]   110.964895: task_event: MYTASKJOB2381 XStarted
>      kworker/u:1-21    [000]   110.964909: task_event: MYTASKJOB2381 Xstopped
>      kworker/u:1-21    [000]   110.965137: task_event: MYTASKJOB2382 XStarted
>      kworker/u:1-21    [000]   110.965154: task_event: MYTASKJOB2382 Xstopped
>      kworker/u:5-3724  [000]   110.965311: task_event: MYTASKJOB2383 XStarted
>      kworker/u:5-3724  [000]   110.965325: task_event: MYTASKJOB2383 Xstopped
> 
> I have this one big task to whom I divided into small sub tasks. These
> are numbered 2381, 2382 and 2383, what was I expecting that task 2381,
> 2382, 2383 run in parallel. I have put start and stop markers here so
> that I can see how this concurrency managed work queue is distributing
> the load.
> 
> I found that task no 2381 is started first and exited before starting
> task 2382 and so on. What I expected that it should start the three
> sub tasks in parallel, not one by one.
> 
> Where is concurrency here?

If none of them blocks, there isn't much point in throwing more
threads at them.  What are those thread doing?

Thanks.

-- 
tejun
