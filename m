Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754260Ab1LMCPq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 21:15:46 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:48169 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753947Ab1LMCPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 21:15:42 -0500
Date: Mon, 12 Dec 2011 21:15:37 -0500
From: Konrad Rzeszutek Wilk <konrad@darnok.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Konrad Rzeszutek Wilk <konrad@kernel.org>,
        "Brown, Len" <len.brown@intel.com>, linux-acpi@vger.kernel.org,
        sfr@canb.auug.org.au, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, pjones@redhat.com
Subject: Re: Re-add ibft tree to linux-next please
Message-ID: <20111213021536.GC2730@konrad-lan>
References: <20111212145330.GA16278@andromeda.dapyr.net>
 <4EE68D57.7030603@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EE68D57.7030603@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 12, 2011 at 03:25:11PM -0800, H. Peter Anvin wrote:
> On 12/12/2011 06:53 AM, Konrad Rzeszutek Wilk wrote:
> > Hey Stephen,
> > 
> > I've one patch for the iBFT and since I am the co-maintainer of said tree,
> > please add this tree to your awesome build system:
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/konrad/ibft.git
> > 
> > The branch is "linux-next"
> > 
> > Signed-off-by: Konrad Rzeszutek Wilk <konrad@kernel.org>
> > CC: Peter Jones <pjones@redhat.com>
> > Thanks!
> > 
> > P.S.
> > After kernel.org went down, I choose not to resurface the iBFT tree b/c I
> > figured that the driver was sooo stable that there would be no need for any
> > patches. Well, not the case
> 
> iBFT is basically an ACPI table with nonstandard discovery.  Any way we
> could get this merged into the ACPI core eventually?

Part of the driver has been exported to the SCSI tree already (the software and
broadcam iSCSI one). The only two remainig pieces are the SysFS skeleton
(which should probably still sit in drivers/firmware) and iBFT finder.

The remaining piece that could be moved to drivers/acpi is the "finder" of
the IBFT which can find it via ACPI, similar to how MADT tables are found
(so perhaps arch/x86/acpi?).

The trick is that we also have to retain the code functionality if
"# CONFIG_ACPI is not set" to scan the memory for the iBFT. That part
should definitly _not_ be moved to drivers/acpi. It could be moved to
arch/x86/ .. but it could also stay in drivers/firmware. <shrugs>

