Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753280Ab1GNAjX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 20:39:23 -0400
Received: from mail.tanisys.com ([207.114.241.63]:7228 "EHLO
	tanisys-ex2.Tanisys.Local" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753176Ab1GNAjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 20:39:12 -0400
X-Greylist: delayed 333 seconds by postgrey-1.27 at vger.kernel.org; Wed, 13 Jul 2011 20:39:11 EDT
From: Ayman El-Khashab <ayman@elkhashab.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Tony Breeds <tony@bakeyournoodle.com>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Cc: Ayman El-Khashab <ayman@elkhashab.com>
Subject: [PATCH 0/1] powerpc/4xx: enable and fix pcie gen1/gen2 on the 460sx
Date: Wed, 13 Jul 2011 19:33:30 -0500
Message-Id: <1310603611-8960-1-git-send-email-ayman@elkhashab.com>
X-Mailer: git-send-email 1.7.4.3
In-Reply-To: <y>
References: <y>
X-OriginalArrivalTime: 14 Jul 2011 00:33:37.0733 (UTC) FILETIME=[AC01DF50:01CC41BD]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Old code didn't check the proper registers for the 460sx and so the link check
would always fail.  This changes the link check to use the config space reg and
adds the definition for the register.  Also changes the vc0 to a pll check.  
Sets up the port for gen2 speeds.

This uses the check_link function to specialize the link detect for the 460sx.
Tested on an eiger and custom board.  Note that is swaps the order of the link
check and dcr initialization since the config space needs the DCRs setup before
it can be mapped and used to check the link.


Ayman El-Khashab (1):
  powerpc/4xx: enable and fix pcie gen1/gen2 on the 460sx

 arch/powerpc/sysdev/ppc4xx_pci.c |   83 +++++++++++++++++++++++++++++--------
 arch/powerpc/sysdev/ppc4xx_pci.h |    3 +
 2 files changed, 68 insertions(+), 18 deletions(-)

-- 
1.7.4.3

