Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751196Ab0JSNn4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 09:43:56 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:58718 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750787Ab0JSNnz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 09:43:55 -0400
X-Authority-Analysis: v=1.1 cv=NFUeGz0loTdi/T6hXKngYYtckjed7x3pKvNOqmBBK18= c=1 sm=0 a=uClON0xspYwA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VY8Fu2yrwOplFC62wbIA:9 a=_Aeb6o9nrB9pm4_2sAIwhUaL-AwA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [Ksummit-2010-discuss] [v2] Remaining BKL users, what to do
From: Steven Rostedt <rostedt@goodmis.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Dave Airlie <airlied@gmail.com>, dri-devel@lists.freedesktop.org,
        ksummit-2010-discuss@lists.linux-foundation.org
In-Reply-To: <201010191536.33373.arnd@arndb.de>
References: <201009161632.59210.arnd@arndb.de>
	 <201010190926.54635.arnd@arndb.de>
	 <1287491998.16971.360.camel@gandalf.stny.rr.com>
	 <201010191536.33373.arnd@arndb.de>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 19 Oct 2010 09:43:52 -0400
Message-ID: <1287495832.16971.368.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-10-19 at 15:36 +0200, Arnd Bergmann wrote:
> [trimming Cc list]
> 
> On Tuesday 19 October 2010, Steven Rostedt wrote:
> > I think we also need to cover the PREEMPT case too. But that could be a
> > compile time check, since you can't boot a preempt kernel and make it
> > non preempt.
> 
> Right. Can we turn the lock_kernel() into preempt_disable() in these
> drivers when we know we never run on SMP?

I'm not sure that will work. A holder of the BKL can call schedule or
even a mutex. The schedule code will drop the BKL and re-enable
preemption. Unless the code is known not to schedule while holding BKL,
we would need to open code the preempt_enable() around the locations
that the code may schedule.

-- Steve


