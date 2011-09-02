Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752567Ab1IBPIT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 11:08:19 -0400
Received: from bulk1.smtp.messagingengine.com ([66.111.4.222]:35163 "EHLO
	bulk1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752485Ab1IBPIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 11:08:18 -0400
X-Sasl-enc: pGhhM+e0opuGGTQfibQIERog06tQaN4fgOpF4CG8LCn2 1314976095
Subject: Re: TFD_CANCEL_ON_SET race when making a wall clock
From: Colin Walters <walters@verbum.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Date: Fri, 02 Sep 2011 11:07:37 -0400
In-Reply-To: <alpine.LFD.2.02.1109021655140.2723@ionos>
References: <1314974233.30505.9.camel@lenny>
	 <alpine.LFD.2.02.1109021655140.2723@ionos>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.2 (3.0.2-3.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1314976058.30505.18.camel@lenny>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

On Fri, 2011-09-02 at 17:00 +0200, Thomas Gleixner wrote:

> There is no way to handle:
> 
>    clock_gettime(a);
> 				clock_settime();
>    timerfd_create();
>    timerfd_settime(a + x);
> 
> And there wont be one ever. 

Well, you can see what I did in userspace - require the processes' idea
of the current time to be passed in, and check after calling
timerfd_settime() - did the clock go backwards?  Ok, treat the timerfd
source as ready.

If we wanted to avoid userspace having to do this, we *could* make a new
system call which also took the "expected current time".  But it's
probably not worth doing so given that the userspace workaround isn't
too difficult.

So, I think you confirmed what I'm saying, we should just document this
and move on.   Thanks!


