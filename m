Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753476Ab1DZKSH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 06:18:07 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:54585 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753051Ab1DZKSE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 06:18:04 -0400
Date: Tue, 26 Apr 2011 11:18:01 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        "Nikita V. Youshchenko" <nyoushchenko@mvista.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] signal: sys_rt_sigtimedwait: simplify the timeout
 logic
Message-ID: <20110426111801.751c7063@mfleming-mobl1.ger.corp.intel.com>
In-Reply-To: <20110423175922.GB484@redhat.com>
References: <20110418134421.GA15951@redhat.com>
	<BANLkTimO2FL3548rxa9NEoVLFbZU7mzG7g@mail.gmail.com>
	<20110418173224.GA27918@redhat.com>
	<BANLkTikkYapz+qiJ0skx9ykz7TT9vmTVQw@mail.gmail.com>
	<20110423175901.GA484@redhat.com>
	<20110423175922.GB484@redhat.com>
X-Mailer: Claws Mail 3.7.8cvs52 (GTK+ 2.22.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 23 Apr 2011 19:59:22 +0200
Oleg Nesterov <oleg@redhat.com> wrote:

> No functional changes, cleanup compat_sys_rt_sigtimedwait() and
> sys_rt_sigtimedwait().
> 
> Calculate the timeout before we take ->siglock, this simplifies and
> lessens the code. Use timespec_valid() to check the timespec.
> 
> I don't understand why we are adding (ts.tv_sec || ts.tv_nsec) to
> timespec_to_jiffies(&ts). Perhaps to ensure we will sleep at least
> one jiffy if ts != 0? But in this case we should only check tv_nsec,
> I don't think timespec_to_jiffies() can return zero if tv_sec != 0.
> In fact I suspect timespec_to_jiffies() can only return zero if
> tv_sec == tv_nsec == 0 because we add "TICK_NSEC - 1", but I am not
> sure I understand correctly this math.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Reviewed-by: Matt Fleming <matt.fleming@linux.intel.com>

-- 
Matt Fleming, Intel Open Source Technology Center
