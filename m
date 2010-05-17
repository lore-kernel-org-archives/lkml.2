Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755322Ab0EQRE7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 13:04:59 -0400
Received: from cantor.suse.de ([195.135.220.2]:41008 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754785Ab0EQRE4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 13:04:56 -0400
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 6)
From: James Bottomley <James.Bottomley@suse.de>
To: Kevin Hilman <khilman@deeprootsystems.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-omap@vger.kernel.org,
       "Theodore Ts'o" <tytso@mit.edu>, Geoff Smith <geoffx.smith@intel.com>,
       Brian Swetland <swetland@google.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@redhat.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Tejun Heo <tj@kernel.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Liam Girdwood <lrg@slimlogic.co.uk>, Matthew Garrett <mjg@redhat.com>
In-Reply-To: <87hbm6cz90.fsf@deeprootsystems.com>
References: <Pine.LNX.4.44L0.1005151716180.24645-100000@netrider.rowland.org>
	 <87hbm6cz90.fsf@deeprootsystems.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 17 May 2010 13:04:45 -0400
Message-ID: <1274115885.4418.59.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-05-17 at 08:40 -0700, Kevin Hilman wrote:
> > Also, how does it handle the issue of ill-behaved apps?
> 
> For userspace, apps that have polling behavior or are ill-behaved must
> be found and fixed.  Thanks to tools like powertop, this is a farily
> easy task.

That's a bit glib ... powertop can detect power consumption stats on a
running system ... if you have a polling app preventing your system from
suspending, powertop isn't necessarily going to find it ... especially
if the polling interval is of the order of powertop's.  Powertop can
find the bad tens of wakeups per second, but it only takes one wakup
every few seconds or so to drain the battery significantly when
operating on suspend from idle.

> But really, I don't consider the "ill-behaved app" problem to be a
> real-world problem.  Both in maemo/meego and Android, if someone
> writes an app that kills battery life, it will get reported as a bug,
> or get bad ratings etc.  On these kinds of devices, there is a *stong*
> developer incentive to not write battery sucking apps.

I'm not sure this is real world, either.  Developers can fire up
powertop from the command line when their phone isn't idling for as long
as it should.  But a phone is a consumer device: the average smart phone
user just wants to browse the web, get email, go to facebook and play
with some cool apps.  If one of those cool apps is rogue, they're not
really going to know which one or how to find it (and firing up powertop
from the command line isn't something which will occur to them as a
matter of routine).

One of the nice things that suspend blockers actually does is to give
the kernel a clear name for the process blocking suspend (and thus
consuming power).  This allows a nice way to assign power budget to the
application and present who's using what in a nice visible form, which
does facilitate the reporting of bad apps, even for the non-developer
user.

James


