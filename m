Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753570Ab2HCPbT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 11:31:19 -0400
Received: from bwv190.internetdsl.tpnet.pl ([83.18.229.190]:56546 "EHLO
	bwv190.internetdsl.tpnet.pl" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752976Ab2HCPbS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 11:31:18 -0400
Date: Fri, 3 Aug 2012 17:32:56 +0200 (CEST)
From: Piotr Gluszenia Slawinski <curious@bwv190.internetdsl.tpnet.pl>
To: linux-kernel@vger.kernel.org
cc: linux-pcmcia@lists.infradead.org
Subject: bisected pcmcia bug - unable to map card memory on old laptops
Message-ID: <Pine.LNX.4.64.1208031728120.9164@bwv190.internetdsl.tpnet.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello. I've bisected bug which makes old laptops fail to detect 
(any) pcmcia cards with message 'unable to map card memory!' .
commit in question is :

30919b0bf356a8ee0ef4f7d38ca8ad99b96820b2 is the first bad commit
commit 30919b0bf356a8ee0ef4f7d38ca8ad99b96820b2
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Thu Dec 16 10:38:51 2010 -0700

     x86: avoid low BIOS area when allocating address space

     This implements arch_remove_reservations() so allocate_resource() can
     avoid any arch-specific reserved areas.  This currently just avoids 
the
     BIOS area (the first 1MB), but could be used for E820 reserved areas 
if
     that turns out to be necessary.

     We previously avoided this area in pcibios_align_resource().  This 
patch
     moves the test from that PCI-specific path to a generic path, so *all*
     resource allocations will avoid this area.

     Acked-by: H. Peter Anvin <hpa@zytor.com>
     Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
     Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>

:040000 040000 58cf7334131f8ad10bc814e56ef6538781b01add 
2434a5e5da4eabf3e413ac694c0cdeef91e17680 M      arch

bug is present in all kernels since late 2.6.36

-- 
