Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753211Ab1IWXrz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 19:47:55 -0400
Received: from smtp-out.google.com ([74.125.121.67]:50106 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753091Ab1IWXry (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 19:47:54 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:date:
	message-id:subject:from:to:cc:content-type:x-system-of-record;
	b=v3ThsNE57stYEoBGYWI9doKbDKQr4cQ72WmP60aCQlbu+otjsg+N0VPZlqJ7jIowq
	zjHupxEF5obemuCt7l5NQ==
MIME-Version: 1.0
In-Reply-To: <1316808181.9084.49.camel@twins>
References: <1316804080-6396-1-git-send-email-venki@google.com>
	<1316808181.9084.49.camel@twins>
Date: Fri, 23 Sep 2011 16:47:51 -0700
Message-ID: <CABeCy1bng31kBhDT+=xumez0hjsXVi2V2ysqtDgUH=Y+3JRpuA@mail.gmail.com>
Subject: Re: [RFC] Introduce greedy hrtimer walk on idle
From: Venki Pallipadi <venki@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 23, 2011 at 1:03 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Fri, 2011-09-23 at 11:54 -0700, Venkatesh Pallipadi wrote:
>> Comments?
>
> Looks to be a possible IRQ latency issue as well, that can be a lot of
> timers to run..
>

We could add some rate limit on how many timers we service this way
and/or interrupt/disable-enable in the inner loop.
But, this would be a problem with current hrtimer as well. When
sched_tick timer is not around, we may end up servicing lot of timers
depending on number of them and slack. No?
