Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755486Ab0JKQuV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 12:50:21 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:52074 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755432Ab0JKQuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 12:50:20 -0400
Date: Mon, 11 Oct 2010 17:50:16 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [GIT] IPS driver updates
Message-ID: <20101011165016.GA28988@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

I'd prefer not to have something this size this late in the window, but 
I've finally got hold of IPS-capable hardware myself and found that the 
driver as is basically doesn't work - it's trivial to get it to start 
complaining about thermal limits when the machine is under load. Jesse's 
provided some patches that disable some of the functionality without 
turning off the whole driver, which should still give most of the 
performance boost. There's also a couple of patches from Minskey to fix 
one or two register size issues and a potential NULL dereference.

The following changes since commit 3c06806e690885ce978ef180c8f8b6f8c17fb4b4:

  Merge branch 'merge-powerpc' of git://git.secretlab.ca/git/linux-2.6 (2010-10-04 11:45:35 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mjg59/platform-drivers-x86.git for_linus

Andy Whitcroft (1):
      intel_ips -- ensure we do not enable gpu turbo mode without driver linkage

Jesse Barnes (4):
      IPS driver: don't toggle CPU turbo on unsupported CPUs
      IPS driver: verify BIOS provided limits
      IPS driver: apply BIOS provided CPU limit if different from default
      IPS driver: disable CPU turbo

Matthew Garrett (1):
      IPS driver: Fix limit clamping when reducing CPU power

Tim Gardner (1):
      intel_ips: Print MCP limit exceeded values.

minskey guo (4):
      seqno mask of THM_ITV register is 16bit
      old_cpu_power is wrongly divided by 65535 in ips_monitor()
      Release symbol on error-handling path of ips_get_i915_syms()
      NULL pointer might be used in ips_monitor()

 drivers/platform/x86/intel_ips.c |  122 ++++++++++++++++++++++++++++----------
 1 files changed, 90 insertions(+), 32 deletions(-)

-- 
Matthew Garrett | mjg59@srcf.ucam.org
