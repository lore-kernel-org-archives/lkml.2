Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754913Ab2LMWZh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 17:25:37 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:36906 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753028Ab2LMWZg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 17:25:36 -0500
Date: Thu, 13 Dec 2012 14:25:34 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: Serge Hallyn <serge.hallyn@canonical.com>, linux-kernel@vger.kernel.org,
        Daniel Berrange <berrange@redhat.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        containers@lists.linux-foundation.org
Subject: Re: [PATCH] core_pattern: set core helpers root and namespace to
 crashing process
Message-Id: <20121213142534.ea07a3c8.akpm@linux-foundation.org>
In-Reply-To: <20121213181220.GB14796@hmsreliant.think-freely.org>
References: <1355255996-25953-1-git-send-email-nhorman@tuxdriver.com>
	<20121213122048.GF5246@sergelap>
	<20121213181220.GB14796@hmsreliant.think-freely.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Dec 2012 13:12:20 -0500
Neil Horman <nhorman@tuxdriver.com> wrote:

> On Thu, Dec 13, 2012 at 06:20:48AM -0600, Serge Hallyn wrote:
> > Quoting Neil Horman (nhorman@tuxdriver.com):
> > > Theres one problem I currently see with it, and that is that I'm not sure we can
> > > change the current behavior of how the root fs is set for the pipe reader, lest
> > > we break some user space expectations. As such, I've added a sysctl in this
> > > patch to allow administrators to globally select if a core reader specified via
> > > /proc/sys/kernel/core_pattern should use the global rootfs, or the (possibly)
> > > chrooted fs of the crashing process.
> > 
> > Practical question:  How is the admin to make an educated decision on
> > how to set the sysctl?

By reading the documentation which Neil didn't include?

> My thought was that the admin typically wouldn't touch this at all.  I really
> added it as a backwards compatibility option only.  Setting the user space
> helper task to the root of the crashing parent has the possibility of breaking
> existing installs because the core_pattern helper might be expecting global file
> system access.  Moving forward, my expectation would be that core_pattern
> helpers would be written with the default setting in mind, and we could
> eventually deprecate the control entirely.
> 
> If you have a better mechanism in mind however (or if you think that removing
> the control is a resaonable approach), I'm certainly open to that.

Yeah, this is a tiresome patch but I can't think of a better way.

Except, perhaps, adding a new token to the core_pattern which says
"switch namespaces"?

Is there any propect that the core_pattern itself will later become a
per-namespace containerised thing?  I guess that if the per-container
core_pattern has been configured, we can implicitly do the namespace
switch as well.

