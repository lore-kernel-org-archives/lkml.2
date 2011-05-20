Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934050Ab1ETPSD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 11:18:03 -0400
Received: from smtp.outflux.net ([198.145.64.163]:48319 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933917Ab1ETPSC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 11:18:02 -0400
Date: Fri, 20 May 2011 08:17:31 -0700
From: Kees Cook <kees.cook@canonical.com>
To: Greg KH <gregkh@suse.de>
Cc: Vasiliy Kulikov <segoon@openwall.com>, linux-kernel@vger.kernel.org,
        Eugene Teo <eugeneteo@gmail.com>
Subject: Re: [RFC] add mount options to sysfs
Message-ID: <20110520151731.GT25448@outflux.net>
References: <20110518163951.GA24143@suse.de>
 <20110518170545.GA4435@albatros>
 <20110518191727.GA26741@suse.de>
 <20110519062622.GA4418@albatros>
 <20110519171227.GB22019@suse.de>
 <20110520095920.GA4489@albatros>
 <20110520133044.GC10225@suse.de>
 <20110520133451.GA8112@albatros>
 <20110520133615.GB8112@albatros>
 <20110520135424.GA10878@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110520135424.GA10878@suse.de>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Fri, May 20, 2011 at 06:54:24AM -0700, Greg KH wrote:
> That's the question for you, we would be changing the kernel/user api
> here, and odds are, something will break.

I feel like this is going in circles. :)

Adding this feature (with no changes to the defaults) will:
 - not break anything in the standard case
 - allow a system owner to locally choose the DAC perms on the mounts

The question is about providing a temporal buffer between when a flaw is
found in sysfs or debugfs and when the fix for it gets to the system owner.
This, of course, presupposes that flaws are even publicly discovered in the
first place. It gives paranoid system owners the option to lock down sysfs
and debugfs from non-root users while still having them mounted without
needing to make rather non-standard changes to boot time scripts beyond
changing the fstab.

Given that things like tmpfs support these options, it seems only sane to
suppor them here too.

-Kees

-- 
Kees Cook
Ubuntu Security Team
