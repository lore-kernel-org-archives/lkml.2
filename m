Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933603Ab0HEPQt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 11:16:49 -0400
Received: from gate.crashing.org ([63.228.1.57]:52422 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933597Ab0HEPQp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 11:16:45 -0400
From: Kumar Gala <galak@kernel.crashing.org>
To: gregkh@suse.de
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        akpm@linux-foundation.org
Subject: [PATCH 0/3] driver core: Add ability for arch code to setup pdev_archdata
Date: Thu,  5 Aug 2010 10:15:44 -0500
Message-Id: <1281021347-1278-1-git-send-email-galak@kernel.crashing.org>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On PPC we need to set the dma_mask pointer for platform_devices to point to
the pdev_archdata.  We can't wait for a bus_notifier as we need the dma_mask
setup before the platform_device_add happens so that the bus_notifiers can
check the dma_mask to determine if we need things like the SWIOTLB dma_ops.

The patch series introduces an arch specific call out (arch_setup_pdev_archdata)
and provide an implementation on PPC to handle our specific issue.

- k
