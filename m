Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751974Ab1DGFpI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 01:45:08 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:36397 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751832Ab1DGFpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 01:45:06 -0400
Date: Wed, 6 Apr 2011 22:44:59 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: Kevin Hilman <khilman@ti.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Magnus Damm <magnus.damm@gmail.com>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Paul Mundt <lethal@linux-sh.org>,
        linux-sh@vger.kernel.org
Subject: Re: [RFC][PATCH] PM / Platform: Remove __weak definitions of runtime
 PM callbacks
Message-ID: <20110407054459.GB6427@angua.secretlab.ca>
References: <201103270058.41632.rjw@sisk.pl>
 <87zko3dn4b.fsf@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87zko3dn4b.fsf@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 06, 2011 at 03:35:32PM -0700, Kevin Hilman wrote:
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
> 
> and now the new one you create here
> 
> 3) platform_set_runtime_pm_ops()
> 
> This new one is basically the same as platform_bus_set_pm_ops(), but
> targetted only at runtime PM ops, and also has all the same problems
> that have been discussed before.  Namely, it overrides the pm ops for
> *every* device on the platform_bus, instead of targetting only specific
> devices.  With the new device power domains, we can target specific
> devices.
> 
> Wouldn't the right way to go here be to convert mach-shmobile over to
> using device power domains?

I agree.  +1

g.
