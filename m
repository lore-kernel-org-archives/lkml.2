Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760234Ab1CDWaa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 17:30:30 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:53092 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752277Ab1CDWa3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 17:30:29 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Vasiliy Kulikov <segoon@openwall.com>
Subject: Re: [PATCH] power: disable hibernation if module loading is disabled
Date: Fri, 4 Mar 2011 23:30:24 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc7+; KDE/4.4.4; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, security@kernel.org,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        linux-pm@lists.linux-foundation.org
References: <1299255084-4390-1-git-send-email-segoon@openwall.com> <201103042221.02852.rjw@sisk.pl> <20110304214630.GA29883@albatros>
In-Reply-To: <20110304214630.GA29883@albatros>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103042330.25079.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, March 04, 2011, Vasiliy Kulikov wrote:
> On Fri, Mar 04, 2011 at 22:21 +0100, Rafael J. Wysocki wrote:
> > On Friday, March 04, 2011, Vasiliy Kulikov wrote:
> > > If modules_disabled is set to 1, then nobody, even full root may not write
> > > to the kernel, right?  So, if something permits to indirectly pass
> > > modules_disabled restriction, this is a bug.  Otherwise,
> > > modules_disabled is confusing as it gives false sense of security.
> > > 
> > > -OR-
> > > 
> > > modules_disabled's documentation should be changed to note that it
> > > doesn't prevent rootkit uploading, but only forbids modprob'ing modules
> > > via the "official" init_module(2) gate, disallowing e.g. module autoloading.
> > 
> > Why not to change that documentation, then?
> 
> Because it's better to fix something (if it is possible, of course) than
> simply documenting the bug.

modules_disabled surely is not the right interface to disable hibernation
and I don't really think there's a bug because it doesn't work as you'd like
it to.  In fact, there would be a bug if it did work that way.

> > Also, please note that in order to "write" into memory using the hibernation
> > interface you need to have write access to swap,
> 
> No, you may just "write the kernel" via write() /dev/snapshot, this is
> the way uswsusp works.  I didn't check whether it really needs
> temporary file to change the kernel memory or it may be done entirely
> without disk iteraction.  This is irrelevant to modules_disabled policy
> violation, though.

Sorry, but who defined the "modules_disabled policy" and when did that happen
and how come that I'm not aware of it?

> > which you can use to corrupt
> > memory regardless of the modules_disabled setting AFAICS.
> 
> Please correct me if I'm wrong, but kernel memory is not swappable at
> all and only userspace memory is written to the swap.  Root with
> CAP_SYS_ADMIN already may do everything with all processes, so this is
> not a threat.

OK

> If one may change kernel memory via swap then it is another problem with
> modules_disabled.

If you want an interface to disable _any_ kind of writes into the kernel
memory by any means, then please add it and don't call it modules_disabled,
because it's a hell of a confusing name and no amount of documentation
can help that.

Thanks,
Rafael
