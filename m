Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755903Ab1EJIIq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 04:08:46 -0400
Received: from casper.infradead.org ([85.118.1.10]:36966 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752875Ab1EJIIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 04:08:43 -0400
Subject: Re: [PATCH] wait: include linux/sched.h
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Kaywinnit L. Frye" <kaywinnit.lee.frye.2497@gmail.com>,
        linux-kernel@vger.kernel.org,
        Michal Nazarewicz <m.nazarewicz@samsung.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Evgeny Kuznetsov <EXT-Eugeny.Kuznetsov@nokia.com>
In-Reply-To: <20110506075408.GI23166@elte.hu>
References: <1304372042-12098-1-git-send-email-kaywinnit.lee.frye.2497@gmail.com>
	 <20110506075408.GI23166@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 10 May 2011 10:11:43 +0200
Message-ID: <1305015103.2914.17.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-05-06 at 09:54 +0200, Ingo Molnar wrote:

> > diff --git a/include/linux/wait.h b/include/linux/wait.h
> > index 3efc9f3..667a3d7 100644
> > --- a/include/linux/wait.h
> > +++ b/include/linux/wait.h
> > @@ -22,6 +22,7 @@
> >  #include <linux/list.h>
> >  #include <linux/stddef.h>
> >  #include <linux/spinlock.h>
> > +#include <linux/sched.h>
> >  #include <asm/system.h>
> >  #include <asm/current.h>
> 
> I'm quite sure this will break the build all around the place, because sched.h 
> itself uses wait.h primitives.

I'm very sure it will, people keep proposing this.

> To fix these super-headers like sched.h and to make wait.h self-sufficient the 
> right and cleanest approach would be to split data types and primitive accessor 
> functions from higher level helper methods (which inevitably mix different 
> domains) and put them into two separate files.
> 
> We have a few such split files in the kernel tree, spinlock_types.h and 
> spinlock_api.h, and this concept works reasonably well.
> 
> So here we'd need wait_types.h and wait_api.h and of course sched_types.h and 
> sched_api.h.
> 
> For simplicity of migration wait_api.h could be wait.h itself and sched_api.h 
> could be sched.h itself.

Argh, please don't. I've been arguing against that for a while now.

The right thing to do is to clean up sched.h and remove a lot of the
non-scheduler bits in there, like all the process and signal bits.


