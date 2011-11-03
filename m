Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933787Ab1KCRss (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 13:48:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12951 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933174Ab1KCRsq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 13:48:46 -0400
Date: Thu, 3 Nov 2011 13:48:42 -0400
From: Josh Boyer <jwboyer@redhat.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: "Luck, Tony" <tony.luck@intel.com>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: sb_edac 32-bit compile fail due to 64-bit divide
Message-ID: <20111103174841.GH19809@zod.bos.redhat.com>
References: <20111103140716.GF19809@zod.bos.redhat.com>
 <4EB2A5FF.1040808@redhat.com>
 <20111103144347.GG19809@zod.bos.redhat.com>
 <987664A83D2D224EAE907B061CE93D5301F566BB32@orsmsx505.amr.corp.intel.com>
 <4EB2D260.7070807@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EB2D260.7070807@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 03, 2011 at 03:41:52PM -0200, Mauro Carvalho Chehab wrote:
> Em 03-11-2011 14:31, Luck, Tony escreveu:
> >>> Of course, an interim fix would be to make it depend on CONFIG_64BIT or CONFIG_X86_64.
> >>
> >> That would work I guess.  It's up to you.
> > 
> > Typically the test platforms I get have pretty much the minimum sane memory
> > configuration - my Sandy Bridge EP machine came with 32GB of memory (which
> > is theoretically bootable with a 32-bit kernel, but really isn't going to
> > be much fun to use).  So I would think that time could be spent on more
> > productive things than making this edac driver work on 32-bit.  My vote
> > is for the "depends on 64-bit" solution.
> 
> Works for me. It would be a trivial patch. We can later fix it for 32 bits, if
> someone has any usage for it with 32 bits kernels.

How's the below?

josh

---

From: Josh Boyer <jwboyer@redhat.com>
Subject: [PATCH] edac: Only build sb_edac on 64-bit

The sb_edac driver is marginally useful on a 32-bit kernel, and
currently has 64-bit divide compile errors when building that config.
For now, make this build on only for 64-bit kernels.

Signed-off-by: Josh Boyer <jwboyer@redhat.com>

---

diff --git a/drivers/edac/Kconfig b/drivers/edac/Kconfig
index 203361e..5948a21 100644
--- a/drivers/edac/Kconfig
+++ b/drivers/edac/Kconfig
@@ -214,7 +214,7 @@ config EDAC_I7300
 
 config EDAC_SBRIDGE
 	tristate "Intel Sandy-Bridge Integrated MC"
-	depends on EDAC_MM_EDAC && PCI && X86 && X86_MCE_INTEL
+	depends on EDAC_MM_EDAC && PCI && X86_64 && X86_MCE_INTEL
 	depends on EXPERIMENTAL
 	help
 	  Support for error detection and correction the Intel
