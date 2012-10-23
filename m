Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757164Ab2JWQ1W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 12:27:22 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:35163 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755465Ab2JWQ1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 12:27:20 -0400
Date: Tue, 23 Oct 2012 17:27:18 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: rwright@hp.com
Cc: linux-kernel@vger.kernel.org, tmac@hp.com, hpa@zytor.com
Subject: Re: [PATCH RFC] function probe_roms accessing improper addresses
Message-ID: <20121023162718.GA32085@srcf.ucam.org>
References: <20121019153015.GD28212@srcf.ucam.org>
 <201210231605.q9NG51KW022791@filesys1.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201210231605.q9NG51KW022791@filesys1.fc.hp.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2012 at 10:05:01AM -0600, Randy Wright wrote:

> On the first: one way to be compliant with such a requirement would be 
> to design systems that implement softfail in this particular region.   
> What about a system that hardfails, but on which the resulting machine
> check can be handled by the kernel machine check handler?  Would
> appropriate re-ordering of the kernel initialization code to support
> such systems be acceptable?

Good question. I don't maintain that code, so I can't really answer 
it...

> Also, let me mention a possible amendment to your first idea: what if
> the mandate that probing be supported were qualified by some attribute
> that could be indicated in the UEFI environment?  For example: instead
> of just a hole in the UEFI memory map, what if this range was
> specifically present and typed as EfiUnusableMemory?  Another idea for
> UEFI systems - but one requiring a UEFI specification change - might be
> adding a UEFI variable that if present, indicates any area not
> explicitly included and typed in the UEFI memory map (including the
> legacy adapter region) must be explicitly avoided by an OS.

Yeah, I think if it were marked unusable we could probably justify 
staying away from it.

> > 2) Don't call probe_roms() by default, but leave it up to the graphics 
> > drivers. If they can get the rom by any other means then don't call it.
> 
> One the second idea: there are a quite a lot of video drivers in the kernel
> source tree.  Do you have a suggestion for how to evaluate which ones 
> rely on the setup performed by probe_roms?

Realistically - intel, radeon and nouveau. Basically, anything that 
calls pci_map_rom() and is under drivers/gpu/drm. I'll look into a patch 
that does that.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
