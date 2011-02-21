Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753958Ab1BUSLk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 13:11:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53130 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752781Ab1BUSLi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 13:11:38 -0500
Date: Mon, 21 Feb 2011 18:27:56 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: David Cohen <dacohen@gmail.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, linux-omap@vger.kernel.org, linux-media@vger.kernel.org,
        Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH v2 1/1] headers: fix circular dependency between
	linux/sched.h and linux/wait.h
Message-ID: <20110221172756.GA27664@redhat.com>
References: <1298299131-17695-1-git-send-email-dacohen@gmail.com> <1298299131-17695-2-git-send-email-dacohen@gmail.com> <1298303677.24121.1.camel@twins> <AANLkTimOT6jNG3=TiRMJR0dgEQ6EHjcBPJ1ivCu3Wj5Q@mail.gmail.com> <1298305245.24121.7.camel@twins> <20110221172103.GA26225@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110221172103.GA26225@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/21, Oleg Nesterov wrote:
>
> On 02/21, Peter Zijlstra wrote:
> >
> > afaict its needed because struct signal_struct and struct sighand_struct
> > include a wait_queue_head_t. The inclusion seems to come through
> > completion.h, but afaict we don't actually need to include completion.h
> > because all we have is a pointer to a completion, which is perfectly
> > fine with an incomplete type.
> >
> > This all would suggest we move the signal bits into their own header
> > (include/linux/signal.h already exists and seems inviting).
>
> Agreed, sched.h contatins a lot of garbage, including the signal bits.
>
> As for signal_struct in particular I am not really sure, it is just
> misnamed. It is in fact "struct process" or "struct thread_group". But
> dequeue_signal/etc should go into signal.h.
>
> The only problem, it is not clear how to test such a change.

Ah. sched.h includes signal.h, the testing is not the problem.

So, we can (at least) safely move some declarations.

Oleg.

