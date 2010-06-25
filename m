Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751821Ab0FYHQM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 03:16:12 -0400
Received: from smtp-out.google.com ([216.239.44.51]:24223 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501Ab0FYHQL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 03:16:11 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:from:date:message-id:
	subject:to:cc:content-type:content-transfer-encoding:x-system-of-record;
	b=UJa3Qefdp0zSFFzC2xuzFGyz/xuXa1t/WmypMSQYNbQAoO1JSILdpKLLaHbZJ5zaL
	4Ui6TAIF2jtKH35xOyhWQ==
MIME-Version: 1.0
In-Reply-To: <20100624000246.GQ6590@dastard>
References: <1276907415-504-1-git-send-email-mrubin@google.com> 
	<20100620231017.GI6590@dastard> <AANLkTikem5aW2MChCwmluUveB-F3zv5B9Tj0TtXPcfxm@mail.gmail.com> 
	<20100624000246.GQ6590@dastard>
From: Michael Rubin <mrubin@google.com>
Date: Fri, 25 Jun 2010 00:15:48 -0700
Message-ID: <AANLkTilQE03HfE6LbC146QR9m6a1AoSkIUYwZnhiIYjI@mail.gmail.com>
Subject: Re: [PATCH 0/3] writeback visibility
To: Dave Chinner <david@fromorbit.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-mm@kvack.org, jack@suse.cz, akpm@linux-foundation.org, hch@lst.de,
       axboe@kernel.dk
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 23, 2010 at 5:02 PM, Dave Chinner <david@fromorbit.com> wrote:
> I don't see any probems with these stats - no matter the
> implementation, they'll still be relevant.

Cool. I have a new patch I will send out tomorrow for these. They have
been moved to /proc/sys/vm too as Christoph recommended. Makes more
sense too.

> I'd much prefer all the bdi stats in the one spot. It's hard enough
> to find what you're looking for without splitting them into multiple
> locations.

Yeah I hear ya.

> The other thing to consider is that tracing requires debugfѕ to be
> mounted. Hence most kernels are going to have the debug stats
> available, anyway....

This thread has made me reconsider pursuing if there is a way that we
can access debugfs safely in our environment. It would make things a
lot easier.

>> >> writeback: tracking subsystems causing writeback

> I don't see much value in exposing this information outside of
> development environments. I think it's much better to add trace
> points for events like this so that we do fine-grained analysis of
> when the events occur during problematic workloads....

> These stats aren't the place for observing that a disk is bad ;)

They do help grant visibility in the whole stack of behaviour.
Writeback has created a whole lot of confusion and time waste. I do
agree with you that these should be folded into tracing
infrastructure.

> Yes, I hear this all the time from appliance developers that cache
> everything they need in userspace - they just want the kernel to
> stay out of the way and not use the unused RAM for caching stuff that
> doesn't matter to the application. Normally the issue is unbounded
> growth of the inode and dentry caches, but I can see how exceeding
> writeback limits can be just as much of a problem.

You hit the nail on the head. There's nothing like writing back logs
to create latency spikes for direct IO traffic that make folks scratch
their heads. In low memory environments this can get more confusing
for a appliance developers trying to find out what happened after the
fact.

Thanks again. I think (or hope) the next set of patches will be more applicable.

mrubin
