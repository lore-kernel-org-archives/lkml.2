Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754405Ab0IVSVX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 14:21:23 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:13114 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754225Ab0IVSVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 14:21:21 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: tidy e820 output
Date: Wed, 22 Sep 2010 12:20:33 -0600
User-Agent: KMail/1.13.2 (Linux/2.6.32-24-generic; KDE/4.4.2; x86_64; ; )
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, Yinghai Lu <yinghai@kernel.org>,
        linux-kernel@vger.kernel.org
References: <20100922172744.19085.41844.stgit@bob.kio> <4C9A42E9.7040109@zytor.com>
In-Reply-To: <4C9A42E9.7040109@zytor.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201009221220.34066.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, September 22, 2010 11:54:49 am H. Peter Anvin wrote:
> On 09/22/2010 10:27 AM, Bjorn Helgaas wrote:
> > 
> > This tidies e820 output by adding an "e820" prefix and printing ranges in
> > the same style we use for struct resource with %pR, e.g.:
> > 
> >     - BIOS-e820: 0000000000000000 - 000000000009f400 (usable)
> >     + BIOS-e820: [mem 0x00000000-0x0009f3ff] (usable)
> 
> I'm sorry, I have to admit to not understanding the difference.  I do
> not want to change the number of hex digits from fixed 16 digits, as
> that will make the output harder to read when printed in a block (as is
> normal for the early e820 dump).  The [mem] prefix seems redundant with
> (usable), or am I misreading this?

These E820 ranges should be easily comparable with similar ranges we
print elsewhere.  Currently we have things like this:

    BIOS-e820: 0000000000000000 - 000000000009f400 (usable)
    BIOS-e820: 000000000009f400 - 00000000000a0000 (reserved)
    BIOS-e820: 00000000fffbc000 - 0000000100000000 (reserved)
    pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff]
    pci_root PNP0A03:00: host bridge window [mem 0xe0000000-0xfebfffff]
    pci 0000:00:02.0: reg 10: [mem 0xf0000000-0xf1ffffff pref]
    reserve RAM buffer: 000000000009f400 - 000000000009ffff 
    pnp 00:07: [mem 0xfed00000-0xfed003ff]

It would be easier to integrate the E820 information with the ACPI
and PCI window and BAR information if they looked similar.

We currently have a mix of some with "0x" prefix, some without;
some with eight hex digits, some with sixteen; some with spaces
around the internal "-", some without; some with type (io/mem/etc),
some without; some with uppercase hex (MTRR), most with lowercase;
some including the end address, some not; and even some in PFNs
and most in addresses.  It just makes it harder than it needs
to be to debug issues in this area.

Bjorn
