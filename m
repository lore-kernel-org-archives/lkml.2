Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752512Ab1GYUJP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 16:09:15 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:49935 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752441Ab1GYUJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 16:09:13 -0400
From: Ram Pai <linuxram@us.ibm.com>
To: jbarnes@virtuousgeek.org
Cc: torvalds@linux-foundation.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, yinghai@kernel.org,
        bhutchings@solarflare.com, socketcan@hartkopp.net, bhelgaas@google.com,
        linux@dominikbrodowski.net, linuxram@us.ibm.com
Subject: [PATCH 0/5 v3] PCI: fix cardbus and sriov regressions
Date: Mon, 25 Jul 2011 13:08:37 -0700
Message-Id: <1311624522-30242-1-git-send-email-linuxram@us.ibm.com>
X-Mailer: git-send-email 1.7.4.1
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

Changelog: patch 2/5 is split into two patches. The changes corresponding to
	resource.c is upstream; commit 23c570a67448e803408191f529ed9a83fd34a25a.
	This patch has the remaining changes.
