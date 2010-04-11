Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753270Ab0DKXoS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Apr 2010 19:44:18 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:49456 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752156Ab0DKXoQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Apr 2010 19:44:16 -0400
From: "Hans-Peter Jansen" <hpj@urpla.net>
To: linux-kernel@vger.kernel.org
Subject: Re: Poor interactive performance with I/O loads with fsync()ing
Date: Mon, 12 Apr 2010 01:43:44 +0200
User-Agent: KMail/1.9.10
Cc: Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <andi@firstfloor.org>,
       Avi Kivity <avi@redhat.com>, Ben Gamari <bgamari.foss@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>, tytso@mit.edu, npiggin@suse.de,
       Ingo Molnar <mingo@elte.hu>, Ruald Andreae <ruald.a@gmail.com>,
       Jens Axboe <jens.axboe@oracle.com>, Olly Betts <olly@survex.com>,
       martin f krafft <madduck@madduck.net>
References: <4b9fa440.12135e0a.7fc8.ffffe745@mx.google.com> <20100411184227.GL18855@one.firstfloor.org> <alpine.LFD.2.00.1004112332380.18009@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.1004112332380.18009@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <201004120143.45643.hpj@urpla.net>
X-Provags-ID: V01U2FsdGVkX1+FYj64cy7IwC/KSAwpVXIY1Z4vTwgiK+RXWiF
 MjrON37e2ybRxd18XWLeWDrS6msbhXV1XtCRehivyZctto+3zf
 NysJMJndru02gt7LSI9Bgh9xkwugWJC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 11 April 2010, 23:54:34 Thomas Gleixner wrote:
> On Sun, 11 Apr 2010, Andi Kleen wrote:
> > > XFS does not do much better. Just moved my VM images back to ext for
> > > that reason.
> >
> > Did you move from XFS to ext3?  ext3 defaults to barriers off, XFS on,
> > which can make a big difference depending on the disk. You can
> > disable them on XFS too of course, with the known drawbacks.
> >
> > XFS also typically needs some tuning to get reasonable log sizes.
> >
> > My point was merely (before people chime in with counter examples)
> > that XFS/btrfs/jfs don't suffer from the "need to sync all transactions
> > for every fsync" issue. There can (and will be) still other issues.
>
> Yes, I moved them back from XFS to ext3 simply because moving them
> from ext3 to XFS turned out to be a completely unusable disaster.
>
> I know that I can tweak knobs on XFS (or any other file system), but I
> would not have expected that it sucks that much for KVM with the
> default settings which are perfectly fine for the other use cases
> which made us move to XFS.

Thomas, what Andi was merely turning out, is that xfs has a really 
concerning different default: barriers, that hurts with fsync(). 

In order to make a fair comparison of the two, you may want to mount xfs 
with nobarrier or ext3 with barrier option set, and _then_ check which one 
is sucking less.

I guess, that outcome will be interesting for quite a bunch of people in the 
audience (including me¹).

Pete

¹) while in transition of getting rid of even suckier technology junk like
   VMware-Server - but digging out a current², but _stable_ kernel release
   seems harder then ever nowadays. 
²) with operational VT-d support for kvm
