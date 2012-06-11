Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751758Ab2FKTyX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 15:54:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54577 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750969Ab2FKTyW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 15:54:22 -0400
Date: Mon, 11 Jun 2012 15:54:14 -0400
From: Don Zickus <dzickus@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, nzimmer@sgi.com, joe@perches.com
Subject: Re: [PATCH v2] watchdog: Quiet down the boot messages
Message-ID: <20120611195414.GH32472@redhat.com>
References: <1339189389-731-1-git-send-email-dzickus@redhat.com>
 <20120608143928.f84822cc.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120608143928.f84822cc.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 08, 2012 at 02:39:28PM -0700, Andrew Morton wrote:
> > After the change, it is simplified to:
> > 
> >     ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
> >     CPU0: Intel(R) Core(TM)2 Quad CPU    Q9550  @ 2.83GHz stepping 0a
> >     Performance Events: PEBS fmt0+, Core2 events, Intel PMU driver.
> >     ... version:                2
> >     ... bit width:              40
> >     ... generic registers:      2
> >     ... value mask:             000000ffffffffff
> >     ... max period:             000000007fffffff
> >     ... fixed-purpose events:   3
> >     ... event mask:             0000000700000003
> >     NMI watchdog enabled, takes one hw-pmu counter.
> >     Booting Node   0, Processors  #1 #2 #3 Ok.
> >     Brought up 4 CPUs
> 
> What is the behaviour of this change at suspend/resume time?

Good question.  Aside from the brokeness that cpu0 doesn't seem to restart
after cpu suspend/resume (hence a previous patch in this space), the printks
disappear during resume.

Now with the cpu0 fix patch, the message will reappear and state that the
watchdog is enabled for all cpus.  But with just this patch, that message
will not show up during resume.

> 
> > +		if (cpu ==0 || cpu0_err)
> 
> Please use checkpatch.  It's free!

Heh.  Sorry about that.

Cheers,
Don
