Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754278Ab1DRNqC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 09:46:02 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.31]:52500
	"EHLO VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754195Ab1DRNp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 09:45:56 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzzz32i668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LJUOWE-01-FT5-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/4] gart cleanups and fixes
Date: Mon, 18 Apr 2011 15:45:42 +0200
Message-ID: <1303134346-5805-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

here is a patch-set to clean things up and fix certain issues with the
GART driver in x86-linux. The first patch changes the alignment
requirements for the aperture to be aper_size instead of hard-coded
512MB as discussed in another thread.
Patch two is preperation for patch three which makes sure that the bit
to disable cache probes on gart table walks is always set, even when the
BIOS sets up the aperture correctly and Linux does not remap then.
The last patch adds a check for a GART hardware constraint. The GART can
only map addresses in the first 1TB of physical memory. This is now
checked with the last patch.

Regards,

	Joerg

Diffstat:

 arch/x86/include/asm/gart.h   |   24 ++++++++++++------------
 arch/x86/kernel/aperture_64.c |   36 ++++++++++++++++++++----------------
 arch/x86/kernel/pci-gart_64.c |    9 ++++++++-
 3 files changed, 40 insertions(+), 29 deletions(-)

Shortlog:

Joerg Roedel (4):
      x86, gart: Don't enforce GART aperture lower-bound by alignment
      x86, gart: Convert spaces to tabs in enable_gart_translation
      x86, gart: Set DISTLBWALKPRB bit always
      x86, gart: Make sure GART does not map physmem above 1TB



