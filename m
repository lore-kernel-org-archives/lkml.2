Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752597Ab1CJNF3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 08:05:29 -0500
Received: from charybdis-ext.suse.de ([195.135.221.2]:41183 "EHLO
	nat.nue.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751723Ab1CJNF2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 08:05:28 -0500
Subject: Re: [RFC][PATCH 0/2] Allow subsystems to avoid using sysdevs for
 defining "core" PM callbacks
From: Kay Sievers <kay.sievers@suse.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>,
        Greg KH <gregkh@suse.de>, Jesse Barnes <jbarnes@virtuousgeek.org>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, mingo@redhat.com, tglx@linutronix.de
In-Reply-To: <201103100131.58206.rjw@sisk.pl>
References: <201103100131.58206.rjw@sisk.pl>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 10 Mar 2011 14:05:15 +0100
Message-ID: <1299762315.1875.14.camel@zag>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-03-10 at 01:31 +0100, Rafael J. Wysocki wrote:
> There are multiple problems with sysdevs, or struct sys_device objects to
> be precise, that are so annoying that some people have started to think
> of removind them entirely from the kernel.  To me, personally, the most
> obvious issue is the way sysdevs are used for defining suspend/resume
> callbacks to be executed with one CPU on-line and interrupts disabled.
> Greg and Kay may tell you more about the other problems with sysdevs. :-)
> 
> Some subsystems need to carry out certain operations during suspend after
> we've disabled non-boot CPUs and interrupts have been switched off on the
> only on-line one.  Currently, the only way to achieve that is to define
> sysdev suspend/resume callbacks, but this is cumbersome and inefficient.
> Namely, to do that, one has to define a sysdev class providing the callbacks
> and a sysdev actually using them, which is excessively complicated.  Moreover,
> the sysdev suspend/resume callbacks take arguments that are not really used
> by the majority of subsystems defining sysdev suspend/resume callbacks
> (or even if they are used, they don't really _need_ to be used, so they
> are simply unnecessary).  Of course, if a sysdev is only defined to provide
> suspend/resume (and maybe shutdown) callbacks, there's no real reason why
> it should show up in sysfs.
> 
> For this reason, I thought it would be a good idea to provide a simpler
> interface for subsystems to define "very late" suspend callbacks and
> "very early" resume callbacks (and "very late" shutdown callbacks as well)
> without the entire bloat related to sysdevs.  The interface is introduced
> by the first of the following patches, while the second patch converts some
> sysdev users related to the x86 architecture to using the new interface.
> 
> I believe that call sysdev users who need to define suspend/resume/shutdown
> callbacks may be converted to using the interface provided by the first patch,
> which in turn should allow us to convert the remaining sysdev functionality
> into "normal" struct device interfaces.  Still, even if that turns out to be
> too complicated, the bloat reduction resulting from the second patch kind of
> shows that moving at least some sysdev users to a simpler interface (like in
> the first patch) is a good idea anyway.

Do I read that right? We get rid of the entire dance of creating
sysdevs/sysdev_classes and the pointless and broken stuff in /sys?

We just dynamically maintain a list of devices/operations, which is
list-executed when needed?

These new "core" operations are not included in every device but only
global per subsystem, just like the sysdev_class did earlier?

Looks all like a nice plan to me.

Thanks,
Kay

