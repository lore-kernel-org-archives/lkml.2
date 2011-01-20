Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755413Ab1ATVmk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 16:42:40 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:8361 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755137Ab1ATVmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 16:42:38 -0500
X-PGP-Universal: processed;
	by hqnvupgp03.nvidia.com on Thu, 20 Jan 2011 13:42:13 -0800
From: Robert Morell <rmorell@nvidia.com>
To: David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>, Benoit Goby <benoit@android.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        Ming Lei <tom.leiming@gmail.com>, Jacob Pan <jacob.jun.pan@intel.com>,
        Oliver Neukum <oliver@neukum.org>
Cc: Olof Johansson <olof@lixom.net>, Erik Gilling <konkers@android.com>,
        Colin Cross <ccross@android.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: [PATCH v5] Align tegra-ehci DMA transfers to 32B
Date: Thu, 20 Jan 2011 13:41:53 -0800
Message-Id: <1295559715-14264-1-git-send-email-rmorell@nvidia.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1294356045-1018-1-git-send-email-rmorell@nvidia.com>
References: <1294356045-1018-1-git-send-email-rmorell@nvidia.com>
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

Version 2 of this patchset gets rid of the HCD placeholder in the flags and
instead simply reserves the flag globally for this use.

Version 3 makes the hook definition and commit message much more verbose, and
moves the new flag from the second patch to the first.

Version 4 adds logic to prevent data copy-out on failure.

Version 5 rebases against linux-tegra-2.6.37.

