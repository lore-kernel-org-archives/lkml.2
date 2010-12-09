Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755870Ab0LIVBZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 16:01:25 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:64832 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753Ab0LIVBY (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Thu, 9 Dec 2010 16:01:24 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: xen-devel@lists.xensource.com, Jeremy Fitzhardinge <jeremy@goop.org>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>
Subject: [PATCH] Fix when booting Xen+Linux under QEMU.
Date: Thu,  9 Dec 2010 16:01:35 -0500
Message-Id: <1291928497-5599-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please take a look. The first patch just cleans up the find_unbound_irq
so it is easier to understand what it does.

The second patch hardness the Xen IRQ (event channels) allocation finder
if you try to boot a minimalistic 32-bit Linux kernel along with a
Xen hypervisor under QEMU.

We end up with a weird scenario where the nr_irq_gsi was greater than nr_irq
by 16. This code hardness it by pointing out the issue to the user and tries
to continue - BUT this might impact the PCI device allocation.

Tested also on normal machine with no regressions found.
