Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753114Ab0LLNVr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 08:21:47 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:47082 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752557Ab0LLNVn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 08:21:43 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH 1/5] resources: add arch hook for preventing allocation in reserved areas
Date: Sun, 12 Dec 2010 14:20:56 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc5+; KDE/4.4.4; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Bjorn Helgaas <bjorn.helgaas@hp.com>, Len Brown <lenb@kernel.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Adam Belay <abelay@mit.edu>, Matthew Garrett <mjg@redhat.com>,
        Dan Williams <dcbw@redhat.com>
References: <20101208213606.13026.47657.stgit@bob.kio> <AANLkTi=b5pq+RhA1DpyyRaLEQxQFOrf4aEXHrG-Qjqbt@mail.gmail.com> <20101211201615.79186de7@jbarnes-desktop>
In-Reply-To: <20101211201615.79186de7@jbarnes-desktop>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201012121420.57217.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, December 12, 2010, Jesse Barnes wrote:
> On Sat, 11 Dec 2010 19:34:05 -0800
> Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > On Fri, Dec 10, 2010 at 5:37 PM, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> > >
> > > Thanks, I'll add Dan and Rafael's tested-bys to the patches (they're
> > > already in my for-linus tree).  Unless Linus has a problem with them
> > > I'll send them over to him this weekend or Monday.
> > 
> > See my other email I just sent out.
> > 
> > I really am not going to take some totally new experimental and hacky
> > major PCI resource management thing this late in the -rc game. No way,
> > no how.
> > 
> > If the top-down allocator is causing regressions that cannot be fixed
> > by _simple_ patches, we're simply going to have to undo it. What's the
> > advantage of top-down? None. Not if we then need all this crap, which
> > we could as easily do on top of the bottom-up one WITHOUT any
> > regressions.
> > 
> > Why isn't anybody else questioning the whole basic premise here?
> 
> Questioning the whole premise is fine, but so far we've gone in (or at
> least think we're going in) a consistent direction: behave like Windows
> on platforms designed for Windows to avoid bugs that Windows doesn't
> hit and enable all the same devices Windows allows.
> 
> But yes, I really don't like the nx6325 patch either; there's obviously
> something we're still missing that's preventing us from doing the right
> thing on that platform.  Quirking it isn't a good long term answer.

OK, so I guess the best thing we can do for 2.6.37 is to revert
1af3c2e (x86: allocate space within a region top-down), right?

Rafael
