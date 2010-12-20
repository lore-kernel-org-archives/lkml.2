Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932814Ab0LTQar (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 11:30:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10339 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932586Ab0LTQaq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 11:30:46 -0500
Date: Mon, 20 Dec 2010 17:23:47 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: roland@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org, rjw@sisk.pl,
        jan.kratochvil@redhat.com
Subject: Re: [PATCH 11/16] signal: prepare for CLD_* notification changes
Message-ID: <20101220162347.GB15755@redhat.com>
References: <1291654624-6230-1-git-send-email-tj@kernel.org> <1291654624-6230-12-git-send-email-tj@kernel.org> <20101220162120.GA15755@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101220162120.GA15755@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/20, Oleg Nesterov wrote:
>
> On 12/06, Tejun Heo wrote:
> >
> > +	 * Determine whether and what to notify.  This should be done under
> > +	 * @tsk's siglock.
>
> Hmm... it is not clear why.
>
> > +	spin_lock_irqsave(&sighand->siglock, flags);
> >
> > +	switch (why) {
> > +	case CLD_CONTINUED:
> > +	case CLD_STOPPED:
> > +	case CLD_TRAPPED:
> > +		notify = why;
> > +		break;
> > +	}
>
> OK, with the next patches this code checks sig->flags, probably that
> is why we take ->siglock. Still I can't understand this so far.
> May be the comment could tell more?

Ah, I didn't notice we are going to change sig->flags here, please
ignore.

Oleg.

