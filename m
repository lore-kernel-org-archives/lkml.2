Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753088Ab2DDHAF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 03:00:05 -0400
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:54608 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751659Ab2DDHAD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 03:00:03 -0400
Date: Wed, 4 Apr 2012 10:00:01 +0300 (EEST)
From: Meelis Roos <mroos@linux.ee>
To: Clemens Ladisch <clemens@ladisch.de>
cc: Dave Airlie <airlied@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fix warnings from vgaarb.h
In-Reply-To: <4F7BEE91.1070309@ladisch.de>
Message-ID: <alpine.SOC.1.00.1204040947170.26551@math.ut.ee>
References: <alpine.SOC.1.00.1204040912210.26551@math.ut.ee> <4F7BEE91.1070309@ladisch.de>
User-Agent: Alpine 1.00 (SOC 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-7
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Meelis Roos wrote:
> > in 3.4-rc1-144, I get the following warnings. Fix them by including
> > <linux/pci.h> to get struct pci_dev.
> >
> >   CC [M]  drivers/gpu/drm/i915/intel_display.o
> > In file included from drivers/gpu/drm/i915/intel_display.c:33:0:
> > include/linux/vgaarb.h:66:9: warning: ¡struct pci_dev¢ declared inside parameter list [enabled by default]
> 
> Or you could simply declare it:
> 
>   struct pci_dev;

Right, but any actual user of vgaarb would still need real pci_dev 
anyway. But yes, nothing in vgaarb.h uses pci_dev contents, so the 
following also compiles without warnings:

-

in 3.4-rc1-144, I get several warnings like this

  CC [M]  drivers/gpu/drm/i915/intel_display.o                                                                                                                                                                                             
In file included from drivers/gpu/drm/i915/intel_display.c:33:0:                                                                                                                                                                           
include/linux/vgaarb.h:66:9: warning: ¡struct pci_dev¢ declared inside parameter list [enabled by default]

Fix them by forward declaring struct pci_dev:

Signed-off-by: Meelis Roos <mroos@linux.ee>

diff --git a/include/linux/vgaarb.h b/include/linux/vgaarb.h
index 9c3120d..b572f80 100644
--- a/include/linux/vgaarb.h
+++ b/include/linux/vgaarb.h
@@ -47,6 +47,8 @@
  */
 #define VGA_DEFAULT_DEVICE     (NULL)
 
+struct pci_dev;
+
 /* For use by clients */
 
 /**
'

-- 
Meelis Roos (mroos@linux.ee)
