Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751299Ab2KDJPF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2012 04:15:05 -0500
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:50217 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750922Ab2KDJOz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2012 04:14:55 -0500
Message-ID: <1352020487.2427.5.camel@dabdike.int.hansenpartnership.com>
Subject: Re: [RFC] Second attempt at kernel secure boot support
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Pavel Machek <pavel@ucw.cz>, Chris Friesen <chris.friesen@genband.com>,
        Eric Paris <eparis@parisplace.org>, Jiri Kosina <jkosina@suse.cz>,
        Oliver Neukum <oneukum@suse.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Josh Boyer <jwboyer@gmail.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org
Date: Sun, 04 Nov 2012 09:14:47 +0000
In-Reply-To: <20121104042802.GA11295@srcf.ucam.org>
References: <20121102165456.GB9997@srcf.ucam.org>
	 <1351878511.2439.44.camel@dabdike.int.hansenpartnership.com>
	 <20121102175416.GA11816@srcf.ucam.org>
	 <1351879058.2439.46.camel@dabdike.int.hansenpartnership.com>
	 <20121102180458.GA12052@srcf.ucam.org>
	 <1351899503.2439.49.camel@dabdike.int.hansenpartnership.com>
	 <20121103002244.GC18691@srcf.ucam.org>
	 <1351944236.2417.7.camel@dabdike.int.hansenpartnership.com>
	 <20121103134630.GA28166@srcf.ucam.org>
	 <1351983400.2417.21.camel@dabdike.int.hansenpartnership.com>
	 <20121104042802.GA11295@srcf.ucam.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-11-04 at 04:28 +0000, Matthew Garrett wrote:
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

Are you sure you've spoken to the right users if you think they use a
distro boot system to do automated installs?

I've actually had more than enough experience with automated installs
over my career: they're either done by paying someone or using a
provisioning system.  In either case, they provision a static image and
boot environment description, including EFI boot services variables, so
you can provision a default MOK database if you want the ignition image
not to pause on firstboot.

There is obviously the question of making the provisioning systems
secure, but it's a separate one from making boot secure.

James


