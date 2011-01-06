Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754591Ab1AFXXc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 18:23:32 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:15916 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752543Ab1AFXXa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 18:23:30 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Thu, 06 Jan 2011 15:11:16 -0800
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
Subject: [PATCH v4] Align tegra-ehci DMA transfers to 32B
Date: Thu,  6 Jan 2011 15:20:43 -0800
Message-Id: <1294356045-1018-1-git-send-email-rmorell@nvidia.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1292794698-19534-1-git-send-email-rmorell@nvidia.com>
References: <1292794698-19534-1-git-send-email-rmorell@nvidia.com>
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

Version 4 of this patchset adds logic to prevent data copy-out on failure.

