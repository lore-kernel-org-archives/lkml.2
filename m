Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752221Ab0IVWiI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 18:38:08 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:1265 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751781Ab0IVWiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 18:38:07 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86, HPET: ignore any PCI BARs that match an HPET we already know about
Date: Wed, 22 Sep 2010 16:37:15 -0600
User-Agent: KMail/1.13.2 (Linux/2.6.32-24-generic; KDE/4.4.2; x86_64; ; )
Cc: Venkatesh Pallipadi <venki@google.com>,
        Prarit Bhargava <prarit@redhat.com>, Simon Arlott <simon@fire.lp0.eu>,
        x86@kernel.org, Clemens Ladisch <clemens@ladisch.de>,
        linux-kernel@vger.kernel.org, Marc Jones <marcj303@gmail.com>,
        Jordan Crouse <jcrouse@codeaurora.org>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
References: <20100922201547.3197.33702.stgit@bob.kio> <201009221552.21896.bjorn.helgaas@hp.com> <4C9A7EDC.5030809@zytor.com>
In-Reply-To: <4C9A7EDC.5030809@zytor.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201009221637.18151.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, September 22, 2010 04:10:36 pm H. Peter Anvin wrote:
> On 09/22/2010 02:52 PM, Bjorn Helgaas wrote:
> > 
> > We don't necessarily need to slavishly copy what Windows does, but
> > I'd feel better if we understood how it avoided the problem on the
> > Gigabyte board so we could make a more informed decision.
> > 
> > It really doesn't look like Windows, and therefore BIOS writers,
> > share your expectations about PCI BARs in E820 reserved areas.
> > It's likely still *safe* to make them fixed resources, but we might
> > be able to fix more issues if we knew how Windows avoids the problem.
> > 
> 
> Keep in mind that Windows -- the version they tested against -- might
> just work by accident.  That's a "ship it" condition for the BIOS for
> almost every vendor.

Yep.  I really wish I had a board to play with to find out.  I'm sure
we'd learn something useful.

> Also, do note that the reservations don't necessarily need to come from
> the BIOS; we can mark the HPET area internally reserved, for example,
> when we discover it.

That actually raises another question I had: we currently look at the
HPET table pretty early, but I don't know whether the earliness is a
requirement.  It would be cleaner if we could ignore the table and
discover the HPET later in normal ways like pnp_register_driver() and
pci_register_driver().  Then I could imagine someday dealing with the
resources in a more generic way, i.e., in the PCI and PNP cores.

Bjorn
