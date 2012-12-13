Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755844Ab2LMSM3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 13:12:29 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:55469 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755452Ab2LMSM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 13:12:28 -0500
Date: Thu, 13 Dec 2012 13:12:20 -0500
From: Neil Horman <nhorman@tuxdriver.com>
To: Serge Hallyn <serge.hallyn@canonical.com>
Cc: linux-kernel@vger.kernel.org, Daniel Berrange <berrange@redhat.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        containers@lists.linux-foundation.org
Subject: Re: [PATCH] core_pattern: set core helpers root and namespace to
 crashing process
Message-ID: <20121213181220.GB14796@hmsreliant.think-freely.org>
References: <1355255996-25953-1-git-send-email-nhorman@tuxdriver.com>
 <20121213122048.GF5246@sergelap>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121213122048.GF5246@sergelap>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Score: -2.9 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 13, 2012 at 06:20:48AM -0600, Serge Hallyn wrote:
> Quoting Neil Horman (nhorman@tuxdriver.com):
> > Theres one problem I currently see with it, and that is that I'm not sure we can
> > change the current behavior of how the root fs is set for the pipe reader, lest
> > we break some user space expectations. As such, I've added a sysctl in this
> > patch to allow administrators to globally select if a core reader specified via
> > /proc/sys/kernel/core_pattern should use the global rootfs, or the (possibly)
> > chrooted fs of the crashing process.
> 
> Practical question:  How is the admin to make an educated decision on
> how to set the sysctl?
> 
My thought was that the admin typically wouldn't touch this at all.  I really
added it as a backwards compatibility option only.  Setting the user space
helper task to the root of the crashing parent has the possibility of breaking
existing installs because the core_pattern helper might be expecting global file
system access.  Moving forward, my expectation would be that core_pattern
helpers would be written with the default setting in mind, and we could
eventually deprecate the control entirely.

If you have a better mechanism in mind however (or if you think that removing
the control is a resaonable approach), I'm certainly open to that.

Neil

> -serge
> 
