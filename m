Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753500Ab2KDLxZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2012 06:53:25 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:45021 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752091Ab2KDLxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2012 06:53:22 -0500
Date: Sun, 4 Nov 2012 12:53:11 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
        Chris Friesen <chris.friesen@genband.com>,
        Eric Paris <eparis@parisplace.org>, Jiri Kosina <jkosina@suse.cz>,
        Oliver Neukum <oneukum@suse.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Josh Boyer <jwboyer@gmail.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org
Subject: Re: [RFC] Second attempt at kernel secure boot support
Message-ID: <20121104115311.GA16238@elf.ucw.cz>
References: <1351878511.2439.44.camel@dabdike.int.hansenpartnership.com>
 <20121102175416.GA11816@srcf.ucam.org>
 <1351879058.2439.46.camel@dabdike.int.hansenpartnership.com>
 <20121102180458.GA12052@srcf.ucam.org>
 <1351899503.2439.49.camel@dabdike.int.hansenpartnership.com>
 <20121103002244.GC18691@srcf.ucam.org>
 <1351944236.2417.7.camel@dabdike.int.hansenpartnership.com>
 <20121103134630.GA28166@srcf.ucam.org>
 <1351983400.2417.21.camel@dabdike.int.hansenpartnership.com>
 <20121104042802.GA11295@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121104042802.GA11295@srcf.ucam.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2012-11-04 04:28:02, Matthew Garrett wrote:
> On Sat, Nov 03, 2012 at 10:56:40PM +0000, James Bottomley wrote:
> > On Sat, 2012-11-03 at 13:46 +0000, Matthew Garrett wrote:
> > > I... what? Our signed bootloader will boot our signed kernel without any 
> > > physically present end-user involvement. We therefore need to make it 
> > > as difficult as practically possible for an attacker to use our signed 
> > > bootloader and our signed kernel as an attack vector against other 
> > > operating systems, which includes worrying about hibernate and kexec. If 
> > > people want to support this use case then patches to deal with that need 
> > > to be present in the upstream kernel.
> > 
> > Right, but what I'm telling you is that by deciding to allow automatic
> > first boot, you're causing the windows attack vector problem.  You could
> > easily do a present user test only on first boot which would eliminate
> > it.  Instead, we get all of this.
> 
> Your definition of "Best practices" is "Automated installs are 
> impossible"? Have you ever actually spoken to a user?

Always polite Matthew...

Anyway, problem with introducing random signatures all over the kernel
is that it does not _work_. You'll end up signing all the userspace,
too. So far you want to sign kexec, soon you'll discover you need to
sign s2disk, too, and then you realize X, wine and dosemu needs the
same treatment. fwvm95 comes next.

								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
