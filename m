Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757575Ab0CPUMF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 16:12:05 -0400
Received: from g6t0184.atlanta.hp.com ([15.193.32.61]:21157 "EHLO
	g6t0184.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756077Ab0CPUMB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 16:12:01 -0400
Subject: [PATCH] x86/PCI: pci=use_crs regression fix
To: Jesse Barnes <jbarnes@virtuousgeek.org>
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: linux-pci@vger.kernel.org, linux-acpi@vger.kernel.org,
       Pete Zaitcev <zaitcev@redhat.com>, Thomas Renninger <trenn@suse.de>,
       linux-kernel@vger.kernel.org
Date: Tue, 16 Mar 2010 14:11:29 -0600
Message-ID: <20100316201046.24527.79634.stgit@bob.kio>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes some PCI host bridge _CRS parsing problems and may fix
Pete Zaitcev's http://bugzilla.kernel.org/show_bug.cgi?id=15533 regression,
but I haven't seen any testing results yet.

I'm pretty confident this will fix pci=use_crs on *some* machines even if
Pete's problem turns out to be something else, so I think we should just
put it in.

---

Bjorn Helgaas (1):
      x86/PCI: ignore Consumer/Producer bit and parse additional _CRS resources


 arch/x86/pci/acpi.c |   77 +++++++++++++++++++++++++++++++++++++++++++++++----
 1 files changed, 71 insertions(+), 6 deletions(-)
