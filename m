Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932115Ab1DGF3t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 01:29:49 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58220 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751418Ab1DGF3s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 01:29:48 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Kevin Hilman <khilman@ti.com>
Subject: Re: [RFC][PATCH] PM / Platform: Remove __weak definitions of runtime PM callbacks
Date: Thu, 7 Apr 2011 07:29:45 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.38+; KDE/4.6.0; x86_64; ; )
Cc: Magnus Damm <magnus.damm@gmail.com>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Paul Mundt <lethal@linux-sh.org>,
        linux-sh@vger.kernel.org, grant.likely@secretlab.ca
References: <201103270058.41632.rjw@sisk.pl> <87zko3dn4b.fsf@ti.com>
In-Reply-To: <87zko3dn4b.fsf@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201104070729.45484.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, April 07, 2011, Kevin Hilman wrote:
> Hi Rafael, Magnus,
> 
> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
> 
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> >
> > Remove the __weak definitions of platform bus type runtime PM
> > callbacks, make platform_dev_pm_ops point to the generic routines
> > as appropriate and allow architectures using platform_dev_pm_ops to
> > replace the runtime PM callbacks in that structure with their own
> > set.
> >
> > Convert architectures providing its own definitions of the platform
> > runtime PM callbacks to use the new mechanism.
> >
> > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> 
> I dont't think we should be adding yet another new interface for setting
> platform-specific runtime PM ops.
> 
> We now have 3.  Two existing ones:
> 
> 1) new device power domains (presumably preferred)
> 2) platform_bus_set_pm_ops() (disliked by many)

Hmm, I wasn't aware of that one, will have a look.

> and now the new one you create here
> 
> 3) platform_set_runtime_pm_ops()
> 
> This new one is basically the same as platform_bus_set_pm_ops(), but
> targetted only at runtime PM ops, and also has all the same problems
> that have been discussed before.  Namely, it overrides the pm ops for
> *every* device on the platform_bus, instead of targetting only specific
> devices.

This is not a problem for this particular use case.  We really want to
replace the PM ops for all of the platform devices on that platform.

Though I agree it probably makes more sense to use the existing
platform_bus_set_pm_ops() for this purpose.

> With the new device power domains, we can target specific devices.
> 
> Wouldn't the right way to go here be to convert mach-shmobile over to
> using device power domains?

Not for this particular purpose.
 
> The patch below against v2.6.39-rc2 combined with your patch (minus the
> mach-shmobile/* changes) should do it.

Unfortunately it would conflict with work in progress introducing _real_
power domains on shmobile.

Thanks,
Rafael
