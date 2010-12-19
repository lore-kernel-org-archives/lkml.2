Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757317Ab0LSVm7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Dec 2010 16:42:59 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:13582 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757281Ab0LSVm5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Dec 2010 16:42:57 -0500
X-PGP-Universal: processed;
	by hqnvupgp03.nvidia.com on Sun, 19 Dec 2010 13:42:38 -0800
From: Robert Morell <rmorell@nvidia.com>
To: David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>, Benoit Goby <benoit@android.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        Ming Lei <tom.leiming@gmail.com>, Jacob Pan <jacob.jun.pan@intel.com>
Cc: Olof Johansson <olof@lixom.net>, Erik Gilling <konkers@android.com>,
        Colin Cross <ccross@android.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: [PATCH] Align tegra-ehci DMA transfers to 32B
Date: Sun, 19 Dec 2010 13:38:16 -0800
Message-Id: <1292794698-19534-1-git-send-email-rmorell@nvidia.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1292636971-17701-1-git-send-email-rmorell@nvidia.com>
References: <1292636971-17701-1-git-send-email-rmorell@nvidia.com>
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This small set of patches fixes an issue where DMA from the tegra EHCI
controller could be corrupted.  It was most commonly seen with USB network
adapters, though in theory it could happen with any USB traffic.

Note: An attempt was made to fix this specifically for network devices with
commit 367c3aab, which set NET_IP_ALIGN to 0 and NET_SKB_PAD to 32.
Unfortunately, not all network drivers honor them (presumably since these are
intended as optimizations rather than hard rules).  This does mean that
properly behaved network drivers should fall through this code with very little
overhead, however.

Version 3 of this patchset makes the hook definition and commit message much
more verbose, and moves the new flag from the second patch to the first.

