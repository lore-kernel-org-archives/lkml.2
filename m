Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755708Ab2KCW4t (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2012 18:56:49 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:49729 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751149Ab2KCW4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2012 18:56:47 -0400
Message-ID: <1351983400.2417.21.camel@dabdike.int.hansenpartnership.com>
Subject: Re: [RFC] Second attempt at kernel secure boot support
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Pavel Machek <pavel@ucw.cz>, Chris Friesen <chris.friesen@genband.com>,
        Eric Paris <eparis@parisplace.org>, Jiri Kosina <jkosina@suse.cz>,
        Oliver Neukum <oneukum@suse.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Josh Boyer <jwboyer@gmail.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org
Date: Sat, 03 Nov 2012 22:56:40 +0000
In-Reply-To: <20121103134630.GA28166@srcf.ucam.org>
References: <20121102163302.GA6080@elf.ucw.cz>
	 <1351875164.2439.42.camel@dabdike.int.hansenpartnership.com>
	 <20121102165456.GB9997@srcf.ucam.org>
	 <1351878511.2439.44.camel@dabdike.int.hansenpartnership.com>
	 <20121102175416.GA11816@srcf.ucam.org>
	 <1351879058.2439.46.camel@dabdike.int.hansenpartnership.com>
	 <20121102180458.GA12052@srcf.ucam.org>
	 <1351899503.2439.49.camel@dabdike.int.hansenpartnership.com>
	 <20121103002244.GC18691@srcf.ucam.org>
	 <1351944236.2417.7.camel@dabdike.int.hansenpartnership.com>
	 <20121103134630.GA28166@srcf.ucam.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-11-03 at 13:46 +0000, Matthew Garrett wrote:
> On Sat, Nov 03, 2012 at 12:03:56PM +0000, James Bottomley wrote:
> > On Sat, 2012-11-03 at 00:22 +0000, Matthew Garrett wrote:
> > > Why would an attacker use one of those Linux systems? There's going to 
> > > be plenty available that don't have that restriction.
> > 
> > It's called best practices.  If someone else releases something that
> > doesn't conform to them, then it's their signing key in jeopardy, not
> > yours.  You surely must see that the goal of securing "everything"
> > against "anything" isn't achievable because if someone releases a
> > bootloader not conforming to the best practices, why would they have
> > bothered to include your secure boot lockdowns in their kernel.  In
> > other words, you lost ab initio, so it's pointless to cite this type of
> > thing as a rationale for a kernel lockdown patch.
> 
> I... what? Our signed bootloader will boot our signed kernel without any 
> physically present end-user involvement. We therefore need to make it 
> as difficult as practically possible for an attacker to use our signed 
> bootloader and our signed kernel as an attack vector against other 
> operating systems, which includes worrying about hibernate and kexec. If 
> people want to support this use case then patches to deal with that need 
> to be present in the upstream kernel.

Right, but what I'm telling you is that by deciding to allow automatic
first boot, you're causing the windows attack vector problem.  You could
easily do a present user test only on first boot which would eliminate
it.  Instead, we get all of this.

By analogy, it's like an architect trying to design a house to be secure
without a front door lock.  If you just secure the front door, you don't
necessarily need all the internal security.  There is certainly a market
for houses with good internal security, but not everyone wants the
hassle, so trying to make every house that way is counterproductive.
It's also not so useful to the people who want specialist internal
security because they're willing to use much more specialised systems
than you have to deploy generally.

In short, if you'd just separate the problem into

     1. What do we have to do to prevent Linux being used to attack
        windows and thus getting our key revoked from,
     2. What specialised systems can we put in place to enhance linux
        security with secure boot for those who want it

It becomes a lot simpler than trying to do a one size fits all solution.

James


