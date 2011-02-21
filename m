Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756083Ab1BUQ3p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 11:29:45 -0500
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:53284 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751800Ab1BUQ3n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 11:29:43 -0500
Date: Mon, 21 Feb 2011 18:29:39 +0200
From: Felipe Balbi <balbi@ti.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: David Cohen <dacohen@gmail.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, linux-omap@vger.kernel.org, linux-media@vger.kernel.org,
        Alexey Dobriyan <adobriyan@gmail.com>, Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH v2 1/1] headers: fix circular dependency between
 linux/sched.h and linux/wait.h
Message-ID: <20110221162939.GK23087@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1298299131-17695-1-git-send-email-dacohen@gmail.com>
 <1298299131-17695-2-git-send-email-dacohen@gmail.com>
 <1298303677.24121.1.camel@twins>
 <AANLkTimOT6jNG3=TiRMJR0dgEQ6EHjcBPJ1ivCu3Wj5Q@mail.gmail.com>
 <1298305245.24121.7.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1298305245.24121.7.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Feb 21, 2011 at 05:20:45PM +0100, Peter Zijlstra wrote:
> > > I think Alexey already told you what you done wrong.
> > >
> > > Also, I really don't like the task_state.h header, it assumes a lot of
> > > things it doesn't include itself and only works because its using macros
> > > and not inlines at it probably should.
> > 
> > Like wait.h I'd say. The main issue is wait.h uses TASK_* macros but
> > cannot properly include sched.h as it would create a circular
> > dependency. So a file including wait.h is able to compile because the
> > dependency of sched.h relies on wake_up*() macros and it's not always
> > used.
> > We can still drop everything else from task_state.h but the TASK_*
> > macros and then the problem you just pointed out won't exist anymore.
> > What do you think about it?
> 
> I'd much rather see a real cleanup.. eg. remove the need for sched.h to
> include wait.h.

isn't that exactly what he's trying to achieve ? Moving TASK_* to its
own header is one approach, what other approach do you suggest ?

> afaict its needed because struct signal_struct and struct sighand_struct
> include a wait_queue_head_t. The inclusion seems to come through

yes.

> completion.h, but afaict we don't actually need to include completion.h
> because all we have is a pointer to a completion, which is perfectly
> fine with an incomplete type.

so maybe just dropping completion.h from sched.h would do it.

> This all would suggest we move the signal bits into their own header
> (include/linux/signal.h already exists and seems inviting).
> 
> And then make sched.c include signal.h and completion.h.

you wouldn't prevent the underlying problem which is the need to include
sched.h whenever you include wait.h and use wake_up*()

-- 
balbi
