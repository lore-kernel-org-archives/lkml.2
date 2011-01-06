Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752705Ab1AFKai (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 05:30:38 -0500
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:55661 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752427Ab1AFKah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 05:30:37 -0500
Date: Thu, 6 Jan 2011 11:30:35 +0100
From: Andreas Mohr <andi@lisas.de>
To: Robert Hancock <hancockrwd@gmail.com>
Cc: sclark46@earthlink.net, linux-kernel <linux-kernel@vger.kernel.org>,
        ide <linux-ide@vger.kernel.org>
Subject: Re: Kernel 2.6.37 erroneously limiting to UDMA/33
Message-ID: <20110106103035.GA3484@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D2503B1.4080500@gmail.com>
X-Priority: none
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Robert Hancock wrote:
> On 01/05/2011 12:33 PM, Stephen Clark wrote:
> > Hello,
> >
> > Why is the kernel limiting me to udma/33 when the device says it can do
> > ata2.01: CFA: TRANSCEND, 20070831, max UDMA/66
> >
> > There is no cable the compact flash is a socket on the motherboard!
> 
> The kernel has no way to know that, and presumably the board isn't 
> connecting the signal for IDE pin 34 to ground in order to properly 
> signal that an 80-wire cable (or equivalent) is connected so that speeds 
> over UDMA33 can be used.
> 
> You should be able to use the libata.force=80c option on the kernel 
> command line to override the cable detection.

Further comments for the OP:

If 80c happens to be correct for this machine (since it's soldered
it's quite obvious) and the machine is quite wide-spread, perhaps one needs
to add overrides within drivers/ata/pata_via.c/via_cable_detect() functionality,
analogous to the ata_piix.c/ich_pata_cable_detect() case where it uses
an entire ich_laptop device list to match against,
to detect special 80c compatible cases.

But since pata_via.c has the insightful comment
"Perform cable detection. Actually for the VIA case the BIOS
 already did this for us."
it looks like your BIOS might be considered "broken"
due to not indicating 80c for such a solder job
--> BIOS upgrade available?



And perhaps better avoid mentioning a specific kernel in the subject
line unless it's a regression (which likely isn't the case here),
or write it like "..... (on 2.6.XXX)".

Andreas Mohr
