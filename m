Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759235Ab2AMVYW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 16:24:22 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:41993 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753732Ab2AMVYQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 16:24:16 -0500
Date: Fri, 13 Jan 2012 21:24:09 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [git pull] PCI changes
Message-ID: <20120113212409.GA27671@srcf.ucam.org>
References: <20120111103408.30cfa338@jbarnes-desktop>
 <CA+55aFwDVEH1NwEgKCQSv9ee3P2ma1aqtjOo-s2BeURyeTGo8g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+55aFwDVEH1NwEgKCQSv9ee3P2ma1aqtjOo-s2BeURyeTGo8g@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 11, 2012 at 07:38:25PM -0800, Linus Torvalds wrote:
> On Wed, Jan 11, 2012 at 10:34 AM, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> >
> > Matthew Garrett (1):
> >      PCI: Rework ASPM disable code
> 
> Yay.
> 
> However, looking this through some more, I'm still a bit confused by
> the pcie_clear_aspm() call in acpi_pci_root_add().
> 
> It seems to be explicitly against the rules elsewhere - we clear ASPM
> even though ACPI_FADT_NO_ASPM is set - which the changelog (and the
> other parts of that commit) says means "don't touch pre-existing ASPM
> state").
> 
> So why is acpi_pci_root_add() special? Cna you explain that part to me?

pcie_no_aspm() means "Do not permit ASPM to be enabled" - it doesn't 
alter the existing state. pcie_clear_aspm() does that.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
