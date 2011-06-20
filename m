Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756133Ab1FTWre (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 18:47:34 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:35703 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755928Ab1FTWrd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 18:47:33 -0400
From: Ram Pai <linuxram@us.ibm.com>
To: jbarnes@virtuousgeek.org
Cc: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org, svenkatr@ti.com,
        yinghai@kernel.org, cjb@laptop.org, linux-pci@vger.kernel.org,
        linux-net-drivers@solarflare.com, bhutchings@solarflare.com,
        Ram Pai <linuxram@us.ibm.com>
Subject: [PATCH 0/4] PCI: fix cardbus and sriov regressions
Date: Mon, 20 Jun 2011 15:47:13 -0700
Message-Id: <1308610037-6261-1-git-send-email-linuxram@us.ibm.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patch-set fixes regressions caused by:

the commit "PCI: update bridge resources to get more big ranges when allocating space (again)"
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=da7822e5ad71ec9b745b412639f1e5e0ba795a20

patch 1/4: correctly calculates the additional resource size for hotplug bridges.
patch 2/4: ability to resize assigned pci-resource.
patch 3/4: makes SRIOV BARs a nice-to-have resource, which means resources will
		be attempted to assign, but not gauranteed to succeed.
patch 4/4: makes cardbus bridge resources nice-to-have resource.


The regression was caused because on some platforms with limited i/o and mem
resources, the nice-to-have resources were allocated ahead of
absolutely-required resources, thus starving the latter. The patchset will
ensure that all the mandatory resource requirements are satisfied before any
nice-to-have resource requirements are satisfied.
