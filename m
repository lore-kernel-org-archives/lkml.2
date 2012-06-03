Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754770Ab2FCUkp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2012 16:40:45 -0400
Received: from mga10.intel.com ([192.55.52.92]:40787 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753690Ab2FCUkm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2012 16:40:42 -0400
Subject: Re: [GIT PULL] x86/efi changes for v3.5
From: Matt Fleming <matt.fleming@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Henrik Rydberg <rydberg@euromail.se>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org,
        Jordan Justen <jordan.l.justen@intel.com>,
        Matthew Garrett <mjg@redhat.com>
In-Reply-To: <4FCAD63D.7070604@zytor.com>
References: <20120523075433.GA12526@gmail.com>
	 <20120602183827.GA4020@polaris.bitmath.org>  <4FCAD63D.7070604@zytor.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Intel Corporation (UK) Ltd. - Registered No. 1134945 - Pipers
 Way, Swindon SN3 1RJ
Date: Sun, 03 Jun 2012 21:40:27 +0100
Message-ID: <1338756027.4584.3.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14)
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-06-02 at 20:13 -0700, H. Peter Anvin wrote:
> On 06/02/2012 11:38 AM, Henrik Rydberg wrote:
> > Hi Ingo, Hans Peter, Matt, Jordan,
> > 
> >> This patchset makes changes to the bzImage EFI header, so that 
> >> it can be signed with a secure boot signature tool. It should 
> >> not affect anyone who is not using the EFI self-boot feature in 
> >> any way.
> > 
> > Commit 2e064b1 (Fix issue of overlapping .reloc section for EFI_STUB)
> > breaks EFI boot on my MacBookAir3,1. The efi firmware no longer
> > recognizes the bzImage and falls back to BIOS emulation boot.
> > 
> > Reverting 2e064b1 works for me, but I am happy to test other options
> > as well.
> > 
> 
> Matt, Jordan,
> 
> Could you look into this please?

Yeah, there's a bug report for this here,

	https://bugzilla.kernel.org/show_bug.cgi?id=43309

I suspect that older firmware doesn't handle a zero .reloc section
properly. So, unfortunately we will have to leave the .reloc section
with a dummy reloc, rather than having one with no entries.

I'll put a patch together.

