Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755439Ab1HZSJj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 14:09:39 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:58810 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753216Ab1HZSJg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 14:09:36 -0400
Date: Fri, 26 Aug 2011 22:09:30 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ralf Jung <ralfjung-e@gmx.de>,
        Yinghai Lu <yinghai@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] x86, ioapic: Reserve only 128 bytes for IOAPICs
Message-ID: <20110826180930.GA1930@sun>
References: <20110825230539.5355.13851.stgit@bhelgaas.mtv.corp.google.com>
 <1314315225.16133.30.camel@sbsiddha-desk.sc.intel.com>
 <CAErSpo7N3UBJgQTb+zePnsf5YuFSQT8zy9CftwceyAKKfcHUjA@mail.gmail.com>
 <20110826062224.GA3903@sun>
 <CAErSpo66U-La7AXCraENWOUvQAuCECRT_eGvJmxC-S4BrN=yAA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAErSpo66U-La7AXCraENWOUvQAuCECRT_eGvJmxC-S4BrN=yAA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 26, 2011 at 10:21:02AM -0600, Bjorn Helgaas wrote:
...
> >
> > Which means, I would prefer if we have (since we change IO_APIC_SLOT_SIZE
> > anyway) some additional check and WARN_ON in this code. Something like
> >
> >  if (io-apic-base-address & 0x3ff)
> >   WARN_ON();
> >
> > Hm? (also we have bad_ioapic() check, probably should put such test
> > there instead).
> 
> Is there some spec that requires all IOAPICs to be 1K aligned?  I
> don't doubt that's the case; I'd just like to see something more
> concrete than folklore.  I'm pretty sure there's some (possibly
> secret) "IOAPIC architecture spec," and a section reference to it
> would be nice.  Even before my patch, I don't think we actually
> checked or enforced any *alignment* -- we only set the size.  I don't
> know if it's worth it unless we have a problem it would fix, and it's
> conceivable that we'd start warning about a perfectly functional
> IOAPIC that's 128-byte aligned.
> 
> Bjorn

Yes, one of the spec is Intel's MP specification (as far as I remember).
Letme re-check...

 | 3.6.5 APIC Memory Mapping
 |
 | "Unlike the local APICs, the I/O APICs are mapped to give shared access from all
 | processors, providing full symmetric I/O access. The default base address for the
 | first I/O APIC is 0FEC0_0000h. Subsequent I/O APIC addresses are assigned in
 | 4K increments. For example, the second I/O APIC is at 0FEC0_1000h. Non-default
 | APIC base addresses can be used if the MP configuration table is provided.
 | (Refer to Chapter 4.) However, the local APIC base address must be aligned
 | on a 4K boundary, and the I/O APIC base address must be aligned on a 1K
 | boundary."

Ie -- 4K increment with 1K base address. If I find other sources I have in mind
I'll ping you.

	Cyrill
