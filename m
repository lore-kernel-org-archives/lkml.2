Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753286Ab1F3XsF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 19:48:05 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:33188 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752346Ab1F3XsC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 19:48:02 -0400
From: Ram Pai <linuxram@us.ibm.com>
To: jbarnes@virtuousgeek.org, torvalds@linux-foundation.org
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, bhutchings@solarflare.com, socketcan@hartkopp.net,
        bhelgaas@google.com, linux@dominikbrodowski.net,
        Ram Pai <linuxram@us.ibm.com>
Subject: [PATCH 0/5 v2] PCI: fix cardbus and sriov regressions
Date: Thu, 30 Jun 2011 16:47:37 -0700
Message-Id: <1309477662-18680-1-git-send-email-linuxram@us.ibm.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patch-set fixes regressions caused by:

the commit "PCI: update bridge resources to get more big ranges when allocating space (again)"
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=da7822e5ad71ec9b745b412639f1e5e0ba795a20

patch 1/5: fix calculation of additional resource size for hotplug bridges
patch 2/5: ability to resize assigned pci-resource
patch 3/5: make SRIOV BARs resources optional
patch 4/5: make cardbus bridge resources optional
patch 5/5: code and terminology cleanup

The regression was caused on some platforms with limited i/o and memory
resources, the optional resources were allocated ahead of required resources,
thus starving the latter. The patchset ensures that all the required resources
are satisfied before any optional resources are satisfied.
