Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759469Ab2AMX07 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 18:26:59 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:34045 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753535Ab2AMX05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 18:26:57 -0500
Date: Fri, 13 Jan 2012 23:26:53 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [git pull] PCI changes
Message-ID: <20120113232653.GA29533@srcf.ucam.org>
References: <20120111103408.30cfa338@jbarnes-desktop>
 <CA+55aFwDVEH1NwEgKCQSv9ee3P2ma1aqtjOo-s2BeURyeTGo8g@mail.gmail.com>
 <20120113212409.GA27671@srcf.ucam.org>
 <CA+55aFwJvvrNyqNStjM9iYcRa+t4FuuJW48SixXN+6H6sJ9e8w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwJvvrNyqNStjM9iYcRa+t4FuuJW48SixXN+6H6sJ9e8w@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 13, 2012 at 03:14:21PM -0800, Linus Torvalds wrote:
> On Fri, Jan 13, 2012 at 1:24 PM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> >>
> >> So why is acpi_pci_root_add() special? Cna you explain that part to me?
> >
> > pcie_no_aspm() means "Do not permit ASPM to be enabled" - it doesn't
> > alter the existing state. pcie_clear_aspm() does that.
> 
> I *know*.
> 
> So look again.
> 
> Why is acpi_pci_root_add() special?
> 
> Because dammit, it does exactly that pcie_clear_aspm() for the
> ACPI_FADT_NO_ASPM case.

I'm sorry, I thought you were referring to the status quo rather than 
the patch - I see what you mean now. The intent here is to clear ASPM 
state if the FADT bit has been set *and* we've got _OSC control, whereas 
previously we'd clear ASPM state any time the FADT bit was set. There 
are some machines which (a) set the FADT bit, (b) hand over _OSC 
control, (c) program the device and (d) crash under certain 
circumstances if you then try to use it. My assumption here is that the 
FADT bit *does* mean "clear ASPM state", but only if we've been granted 
_OSC control. That's the behaviour described in the changelog.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
