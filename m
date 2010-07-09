Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754936Ab0GIDtq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 23:49:46 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:58279 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751227Ab0GIDto (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 23:49:44 -0400
Date: Fri, 9 Jul 2010 13:49:39 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
       Paul Mundt <lethal@linux-sh.org>, Alan Cox <alan@linux.intel.com>
Subject: linux-next: manual merge of the tty tree with the genesis tree
Message-Id: <20100709134939.71170dae.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Today's linux-next merge of the tty tree got a conflict in
include/linux/serial_core.h between commit
75b93489b449db4a34f0424c72f51821d985f52f ("serial: add a new port type,
found on some sh-mobile SoCs") from the genesis tree and commit
4286e9ca73813ee0ab5b0bd63b7eaefeb4994334 ("serial: max3107: Abstract out
the platform specific bits") from the tty tree.

Just overlapping additions.  I fixed it up (see below) and can carry the
fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc include/linux/serial_core.h
index 5228320,9ddc866..0000000
--- a/include/linux/serial_core.h
+++ b/include/linux/serial_core.h
@@@ -186,9 -186,10 +186,13 @@@
  #define PORT_ALTERA_JTAGUART	91
  #define PORT_ALTERA_UART	92
  
 +/* SH-SCI */
 +#define PORT_SCIFB	93
 +
+ /* MAX3107 */
+ #define PORT_MAX3107	94
+ 
+ 
  #ifdef __KERNEL__
  
  #include <linux/compiler.h>
