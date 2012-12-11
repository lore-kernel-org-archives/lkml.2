Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754001Ab2LKQ1s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 11:27:48 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34894 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752904Ab2LKQ1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 11:27:46 -0500
Date: Tue, 11 Dec 2012 08:27:29 -0800
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Zhao Shuai <zhaoshuai@freebsd.org>, axboe@kernel.dk, ctalbott@google.com,
        rni@google.com, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        containers@lists.linux-foundation.org
Subject: Re: performance drop after using blkcg
Message-ID: <20121211162729.GK7084@htj.dyndns.org>
References: <CAFVn34SxqAJe_4P-WT8MOiG-kmKKD7ge96zoHXQuGqHWPgAt+A@mail.gmail.com>
 <20121211142518.GA5580@redhat.com>
 <20121211142742.GE7084@htj.dyndns.org>
 <20121211144336.GB5580@redhat.com>
 <20121211144718.GF7084@htj.dyndns.org>
 <20121211150234.GC5580@redhat.com>
 <20121211151412.GG7084@htj.dyndns.org>
 <20121211153725.GD5580@redhat.com>
 <20121211160137.GJ7084@htj.dyndns.org>
 <20121211161820.GE5580@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121211161820.GE5580@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Vivek.

On Tue, Dec 11, 2012 at 11:18:20AM -0500, Vivek Goyal wrote:
> - Controlling device queue should bring down throughput too as it
>   should bring down level of parallelism at device level. Also asking
>   user to tune device queue depth seems bad interface. How would a
>   user know what's the right queue depth. May be software can try to
>   be intelligent about it and if IO latencies cross a threshold then
>   try to decrese queue depth. (We do things like that in CFQ).

Yeah, it should definitely be something automatic.  Command completion
latencies are visible to iosched, so it should be doable.

> - Passing prio to device sounds something new and promising. If they
>   can do a good job at it, why not. I think at minimum they need to
>   make sure READs are prioritized over writes by default. And may
>   be provide a way to signal important writes which need to go to
>   the disk now.
> 
>   If READs are prioritized in device, then it takes care of one very
>   important use case. Then we just have to worry about other case of
>   fairness between different readers or fairness between different
>   writers and there we do not idle and try our best to give fair share.
>   In case group is not backlogged, it is bound to loose some share.

I think it can be good enough if we have queue at the head / tail
choice.  No idea how it'll actually fan out tho.

Thanks.

-- 
tejun
