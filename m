Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753968Ab0FCNHy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 09:07:54 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:28296 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752823Ab0FCNHw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 09:07:52 -0400
X-IronPort-AV: E=Sophos;i="4.53,354,1272844800"; 
   d="scan'208";a="227938"
Date: Thu, 3 Jun 2010 14:07:33 +0100
From: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
       "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
       Don Dutile <ddutile@redhat.com>, Sheng Yang <sheng@linux.intel.com>,
       Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
Subject: [PATCH 0/12] PV on HVM Xen
Message-ID: <alpine.DEB.2.00.1006011435570.3401@kaball-desktop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,
the last update on the PV on HVM Xen series contains the following
changes:

- some variables and functions have been renamed following Jeremy's
suggestions, in particular:
s/init_shared_info/xen_hvm_init_shared_info
s/xen_platform_pci/xen_platform_pci_enabled
s/UNPLUG_/XEN_UNPLUG_

- the two platform_pci.h header files have been merged and the useless
intro has been removed;

- the xen platform pci product number and driver versions have been made
static;

- the description on the VIRQ_TIMER patch has been improved;

- a new patch to fix hpet behaviour has been introduced: hpet_disable is
called unconditionally on machine shutdown, and doesn't check whether
hpet has been actually enabled, causing trouble if it hasn't;

- the vector callback patch has been improved: we don't use the ipi
vector anymore but we allocate our own so that we can avoid useless and
expensive vlapic acks.


Meanwhile the vector callback patch for xen has been checked into
xen-unstable, so you don't need a separate patch for xen anymore to take
full advantage of this patch series.

A git tree is available here:

git://xenbits.xen.org/people/sstabellini/linux-pvhvm.git

branch name 2.6.34-pvhvm-v3.

Cheers,

Stefano
