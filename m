Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753239Ab2GIKk5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 06:40:57 -0400
Received: from smtp.citrix.com ([66.165.176.89]:6124 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752811Ab2GIKjh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 06:39:37 -0400
X-IronPort-AV: E=Sophos;i="4.77,551,1336363200"; 
   d="scan'208";a="30818188"
From: David Vrabel <david.vrabel@citrix.com>
To: xen-devel@lists.xensource.com
CC: "David Vrabel" <david.vrabel@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] x86/xen: page fault and context switch performance (v2)
Date: Mon, 9 Jul 2012 11:39:04 +0100
Message-ID: <1341830348-15529-1-git-send-email-david.vrabel@citrix.com>
X-Mailer: git-send-email 1.7.2.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series improves the performance of Xen PV guests when doing page
faults (32-bit guests only) and context switches.

Can an x86 maintainer ack patch 3 (x86: add desc_equal() to compare
GDT descriptors) so this series can go via Konrad's tree?  The other
patches are Xen-specific.

Changes since v1:

- fix (very!) slow boot on x86_64 by avoiding hypercalls when building
  the initial page tables.  These updates were mostly a) done to
  unpinned pages and b) often had invalid MFNs that Xen warns about.

- When building the initial page tables, zero PTEs for pages without
  an MFN yet.

- add desc_equal() instead of open coding it.

David

