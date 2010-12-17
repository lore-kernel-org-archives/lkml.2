Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756637Ab0LQWA2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 17:00:28 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:8074 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755824Ab0LQWA1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 17:00:27 -0500
X-PGP-Universal: processed;
	by hqnvupgp03.nvidia.com on Fri, 17 Dec 2010 13:58:59 -0800
From: Robert Morell <rmorell@nvidia.com>
To: David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>, Benoit Goby <benoit@android.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        Ming Lei <tom.leiming@gmail.com>, Jacob Pan <jacob.jun.pan@intel.com>
Cc: Olof Johansson <olof@lixom.net>, Erik Gilling <konkers@android.com>,
        Colin Cross <ccross@android.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC] Align tegra-ehci DMA transfers to 32B
Date: Fri, 17 Dec 2010 13:58:47 -0800
Message-Id: <1292623129-26361-1-git-send-email-rmorell@nvidia.com>
X-Mailer: git-send-email 1.7.2.2
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This small set of patches fixes an issue where DMA from the tegra EHCI
controller could be corrupted.  It was most commonly seen with USB network
adapters, though in theory it could happen with any USB traffic.

(Note: An attempt was made to fix this with commit 367c3aab, which set
NET_IP_ALIGN to 0 and NET_SKB_PAD to 32.  Unfortunately, not all network
drivers honor them (presumably since these are intended as optimizations rather
than hard rules).  This does mean that properly-written network drivers should
fall through this code with very little overhead, however.)

