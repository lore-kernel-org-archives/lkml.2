Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933119Ab2AFIvI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 03:51:08 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:34076 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932133Ab2AFIvH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 03:51:07 -0500
Date: Fri, 6 Jan 2012 09:49:01 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, thuban@singularity.fr,
        dann frazier <dann.frazier@canonical.com>,
        Lisa Salimbas <lisa.salimbas@canonical.com>,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        Len Brown <lenb@kernel.org>
Subject: Re: [PATCH 2/2] PNP: work around Dell 1536/1546 BIOS MMCONFIG bug
 that breaks USB
Message-ID: <20120106084901.GD14188@elte.hu>
References: <20120105212719.3965.40406.stgit@bhelgaas.mtv.corp.google.com>
 <20120105212724.3965.30193.stgit@bhelgaas.mtv.corp.google.com>
 <CAErSpo6=yHFspY_L0rQa6iVD692nYyL=BR=3qBwc3UV8M16xbw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAErSpo6=yHFspY_L0rQa6iVD692nYyL=BR=3qBwc3UV8M16xbw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Bjorn Helgaas <bhelgaas@google.com> wrote:

> On Thu, Jan 5, 2012 at 2:27 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> > Some Dell BIOSes have MCFG tables that don't report the entire
> > MMCONFIG area claimed by the chipset.  If we move PCI devices into
> > that claimed-but-unreported area, they don't work.
> >
> > This quirk reads the AMD MMCONFIG MSRs and adds PNP0C01 resources as
> > needed to cover the entire area.
> 
> PNP stuff usually goes through Len's ACPI tree, but this is 
> really x86-specific, and these two patches need to go 
> together, so I think it would make sense to put them both in 
> the x86 tree.  Len, do you object?

I'd really suggest the PCI tree for this - mmconfig is really 
PCI related.

Thanks,

	Ingo
