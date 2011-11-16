Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753591Ab1KPVo5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 16:44:57 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:42878 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750945Ab1KPVo4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 16:44:56 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2] PM/Memory-hotplug: Avoid task freezing failures
Date: Wed, 16 Nov 2011 22:47:38 +0100
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc10+; KDE/4.6.0; x86_64; ; )
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>, pavel@ucw.cz,
        lenb@kernel.org, ak@linux.intel.com, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-mm@kvack.org
References: <20111116115515.25945.35368.stgit@srivatsabhat.in.ibm.com> <4EC3FFC4.2010904@linux.vnet.ibm.com> <20111116184157.GA25497@google.com>
In-Reply-To: <20111116184157.GA25497@google.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201111162247.39217.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, November 16, 2011, Tejun Heo wrote:
> Hello,
> 
> On Wed, Nov 16, 2011 at 11:54:04PM +0530, Srivatsa S. Bhat wrote:
> > Ok, so by "proper solution", are you referring to a totally different
> > method (than grabbing pm_mutex) to implement mutual exclusion between
> > subsystems and suspend/hibernation, something like the suspend blockers
> > stuff and friends?
> > Or are you hinting at just the existing code itself being fixed more
> > properly than what this patch does, to avoid having side effects like
> > you pointed out?
> 
> Oh, nothing fancy.  Just something w/o busy looping would be fine.
> The stinking thing is we don't have mutex_lock_freezable().  Lack of
> proper freezable interface seems to be a continuing problem and I'm
> not sure what the proper solution should be at this point.  Maybe we
> should promote freezable to a proper task state.  Maybe freezable
> kthread is a bad idea to begin with.

It generally is, but some of them really want to be freezable.

> Maybe instead of removing
> freezable_with_signal() we should make that default, that way,
> freezable can hitch on the pending signal handling (this creates
> another set of problems tho - ie. who's responsible for clearing
> TIF_SIGPENDING?).  I don't know.
> 
> Maybe just throw in msleep(10) there with fat ugly comment explaining
> why the hack is necessary?

Perhaps.

Thanks,
Rafael
