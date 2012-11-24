Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751089Ab2KXMrj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2012 07:47:39 -0500
Received: from miso.sublimeip.com ([203.12.5.51]:42446 "EHLO
	miso.sublimeip.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750Ab2KXMrh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2012 07:47:37 -0500
Subject: Re: vdso && cr (Was: arch_check_bp_in_kernelspace: fix the range
To: oleg@redhat.com (Oleg Nesterov)
Date: Sat, 24 Nov 2012 23:47:35 +1100 (EST)
Cc: xemul@parallels.com (Pavel Emelyanov),
        gorcunov@openvz.org (Cyrill Gorcunov),
        rostedt@goodmis.org (Steven Rostedt),
        fweisbec@gmail.com (Frederic Weisbecker),
        mingo@redhat.com (Ingo Molnar),
        a.p.zijlstra@chello.nl (Peter Zijlstra), linux-kernel@vger.kernel.org
Reply-To: u3557@dialix.com.au
In-Reply-To: <20121123174529.GB3361@redhat.com>
X-Mailer: ELM [version 2.5 PL8]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20121124124735.9EE57592076@miso.sublimeip.com>
From: u3557@miso.sublimeip.com (Amnon Shiloh)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Oleg,

> Amnon,
> 
> I am going to "ignore" this thread because this is not my area and
> I can't help anyway. Just one note:
> 
> On 11/23, Amnon Shiloh wrote:
> >
> > The solution can be to hold all catched signals while in the VDSO page.
> > ...
> >
> > 1) + introduce a kernel feature to prevent
> >    catching signals within the VDSO page (probably a new prctl,
> >    or make it the default)
> 
> Sorry, never ;)
> 
> Oleg.

It's OK with me because I already found a way to work around this that
works for me, but I suspect that other people who write checkpoint/restore
packages may not be able to use my soltion and so they will have a problem
with interrupts occuring within the VDSO page.

I therefore suggested an alternate solution, for all such systems where
applications can be checkpointed on one kernel and restarted on another:
to allow the user to ask for an ultra-compatible VDSO version, which would
be exactly the same on all kernels (from a given point in time) and all
kernel configurations, even if it means a loss of performance.  This is
needed for systems where applications can be checkpointed on one kernel
and restarted on another.

It could even be a kernel configuration option: CONFIG_ULTRA_COMPAT_VDSO,
but ideally it should be the user's choice.

Best Regards,
Amnon.
