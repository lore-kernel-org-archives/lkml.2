Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750900Ab1IWEWm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 00:22:42 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:48198 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750706Ab1IWEWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 00:22:41 -0400
Date: Fri, 23 Sep 2011 14:22:33 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Xen Devel <Xen-devel@lists.xensource.com>
Subject: linux-next: manual merge of the xen-two tree with the xen tree
Message-Id: <20110923142233.316b994baac3adffcf4afdbc@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Konrad,

Today's linux-next merge of the xen-two tree got a conflict in
arch/x86/xen/Kconfig between commit 430bdcaf0b96 ("xen: add CPU microcode
update driver") from the xen tree and commit 10fe570fc167 ("Revert
"xen/debug: WARN_ON when identity PFN has no _PAGE_IOMAP flag set."")
from the xen-two tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.

[Jeremy: the xen patch is missing a new-line at the end of the file ...]
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/x86/xen/Kconfig
index c5d7ccb,ae559fe..0000000
--- a/arch/x86/xen/Kconfig
+++ b/arch/x86/xen/Kconfig
@@@ -49,15 -49,3 +49,7 @@@ config XEN_DEBUG_F
  	help
  	  Enable statistics output and various tuning options in debugfs.
  	  Enabling this option may incur a significant performance overhead.
 +
- config XEN_DEBUG
- 	bool "Enable Xen debug checks"
- 	depends on XEN
- 	default n
- 	help
- 	  Enable various WARN_ON checks in the Xen MMU code.
- 	  Enabling this option WILL incur a significant performance overhead.
- 
 +config MICROCODE_XEN
 +       def_bool y
-        depends on XEN_DOM0 && MICROCODE
++       depends on XEN_DOM0 && MICROCODE
