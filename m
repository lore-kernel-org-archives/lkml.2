Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755762Ab0HII3I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 04:29:08 -0400
Received: from mtagate7.de.ibm.com ([195.212.17.167]:57592 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755677Ab0HII3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 04:29:06 -0400
Date: Mon, 9 Aug 2010 10:30:53 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: walt <w41ter@gmail.com>, linux-kernel@vger.kernel.org, tj@kernel.org
Subject: Re: [BISECTED] Today's Linus.git hangs during boot: can't find the
 floppy controller
Message-ID: <20100809083053.GB2169@osiris.boeblingen.de.ibm.com>
References: <i3n3dh$t48$1@dough.gmane.org>
 <20100809063742.GA1632@arch.tripp.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100809063742.GA1632@arch.tripp.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 09, 2010 at 08:37:42AM +0200, Markus Trippelsdorf wrote:
> On Sun, Aug 08, 2010 at 01:17:53PM -0700, walt wrote:
> > This commit produces the error:
> > 
> > commit 6ee0578b4daaea01c96b172c6aacca43fd9807a6
> > Author: Suresh Siddha <suresh.b.siddha@intel.com>
> > Date:   Fri Jul 30 14:57:37 2010 -0700
> > 
> >     workqueue: mark init_workqueues() as early_initcall()
> > 
> >     Mark init_workqueues() as early_initcall() and thus it will be initialized
> >     before smp bringup. init_workqueues() registers for the hotcpu notifier
> >     and thus it should cope with the processors that are brought online after
> >     the workqueues are initialized.
> > 
> >     x86 smp bringup code uses workqueues and uses a workaround for the
> >     cold boot process (as the workqueues are initialized post smp_init()).
> >     Marking init_workqueues() as early_initcall() will pave the way for
> >     cleaning up this code.
> > 
> >     Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
> >     Signed-off-by: Tejun Heo <tj@kernel.org>
> >     Cc: Oleg Nesterov <oleg@redhat.com>
> >     Cc: Andrew Morton <akpm@linux-foundation.org>
> > 
> > 
> > Just after the error message about the floppy controller not found, the
> > machine hangs for two minutes and then this message:
> > 
> > task swapper:1 blocked for greater than 120 seconds, followed by a stack
> > trace, and again every two minutes AFAICT.
> > 
> > I'm not including all the gory messages and stack traces because I'm
> > hoping you'll know what the problem is without them. (Fingers crossed.)
> > 
> > BTW, I see this problem only on my dual-core machine, not the older single
> > single processor machine, as I would expect from reading the commit message.
> > (Both machine have properly functioning floppy drives.)
> 
> (Added Tejun to CC)
> 
> I see a similar problem here. The kernel will boot, but the system will
> not initialize (no X11). 
> After reverting the commit, the system starts normally and the only
> workqueue problem left is drm related:

I would guess that both of you have CONFIG_HOTPLUG_CPU disabled and enabling
that config option will make the problem disappear.
>From the problem description and the patch it looks like it got screwed up
the same way I did two years ago.
See commits a802dd0eb5fc97a50cf1abb1f788a8f6cc5db635 and
4403b406d4369a275d483ece6ddee0088cc0d592.
