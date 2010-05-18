Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754271Ab0ERO0l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 10:26:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5483 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752804Ab0ERO0k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 10:26:40 -0400
Date: Tue, 18 May 2010 16:23:36 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Andrey Vagin <avagin@openvz.org>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       stable@kernel.org, Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [PATCH 3/3] posix_timer: move copy_to_user(created_timer_id)
	down in timer_create
Message-ID: <20100518142336.GA4818@redhat.com>
References: <1274116688-4037-1-git-send-email-avagin@openvz.org> <1274116688-4037-2-git-send-email-avagin@openvz.org> <1274116688-4037-3-git-send-email-avagin@openvz.org> <20100518085314.1817d64a@dhcp-lab-109.englab.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100518085314.1817d64a@dhcp-lab-109.englab.brq.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/18, Stanislaw Gruszka wrote:
>
> On Mon, 17 May 2010 21:18:08 +0400
> Andrey Vagin <avagin@openvz.org> wrote:
>
> > According to Oleg Nesterov:
> > We can move copy_to_user(created_timer_id) down after
> > "if (timer_event_spec)" block too. (but before CLOCK_DISPATCH(),
> > of course).
>
> I'm not sure what for Oleg want that change, I'm not seeing any value of
> it. I think patch should be dropped.

I didn't mean this change is really needed. I just wanted to clarify
that currently the comment is wrong.

But. Now that we move CLOCK_DISPATCH() down, it becomes correct again:
we report created_timer_id to user-space despite the fact timer_create()
can fail later. This _perhaps_ means it makes sense to preserve the
comment and move the copy_to_user() block down, before CLOCK_DISPATCH(),
just to make the code more readable/understandable.

But I agree with either way you and Andrey prefer. And I believe 2/3
should fix the problem correctly.

Oleg.

