Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932317Ab1JDQIa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 12:08:30 -0400
Received: from gate.crashing.org ([63.228.1.57]:40486 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932151Ab1JDQI2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 12:08:28 -0400
Subject: Re: [PATCH 2/3] pci: Clamp pcie_set_readrq() when using
 "performance" settings
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jon Mason <mason@myri.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, Benjamin LaHaise <bcrl@kvack.org>
In-Reply-To: <CA+55aFzFWC3Acp0bwx33CgUZ9NgiDdJ8H=yNOdb0xmLsAAJZxQ@mail.gmail.com>
References: <1317653420-21404-3-git-send-email-mason@myri.com>
	 <CA+55aFyyx99Z4=x-Twp7JCpU=JHPzP8HRdLc4H3NOGHNQq9jCw@mail.gmail.com>
	 <1317742838.29415.217.camel@pasglop>
	 <CA+55aFzFWC3Acp0bwx33CgUZ9NgiDdJ8H=yNOdb0xmLsAAJZxQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 04 Oct 2011 18:08:13 +0200
Message-ID: <1317744493.29415.238.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-10-04 at 08:48 -0700, Linus Torvalds wrote:
> On Tue, Oct 4, 2011 at 8:40 AM, Benjamin Herrenschmidt
> <benh@kernel.crashing.org> wrote:
> >
> > Hopefully most of these patches only affect the "performance" setting
> > which is no longer the default.
> >
> > But yes, more reviews are always welcome.
> 
> Well, bcrl argues that patches 1-2 of 3 are actively wrong.

This is an argument that isn't finished :-)

In any case, what Ben's arguing about is the whole "performance" mode
which is -already- implemented in your tree, except that the current
implementation you have is totally broken and those patches fix it. This
mode is optional and isn't the default.
 
> Quite frankly, my gut feel is that this late in the game, he only
> patch I should apply is 3/3, and even that I wonder about. But that
> seems to *really* disable all the games we do, and that all seem to be
> questionable.

Sort-of yes. The "safe" mode shouldn't be questionable. It's the right
way to safely configure the system. But as usual, we get defeated by
chipset errata.

Still, I think Jon has workarounds for a bunch and having those modes as
options for broken BIOSes is handy.

The real thing for me is that this ability to configure MPS and MRRS
from scratch is needed for platforms where the firmware isn't doing it
at all, such as some embedded platforms or our new upcoming "no pHyp"
KVM-oriented power platforms.

So I like having the code there and the ability to turn it on either
manually or from platform code.

But I agree that at this point, the right default for the x86 mess
should be "don't touch" which is what 3/3 does afaik.

> Comments? Please? I'm going to do an -rc9 today, and after that I'll
> be travelling a lot, so..

My vote is to apply Jon patches. 1/2 and 2/3 will have no effect unless
the "performance" mode is explicitly requested. Without them, it's
totally busted (ie the current implementation you have in your tree is
broken). Patch 3/3 will make sure that the default is to not do
anything.

Cheers,
Ben.




