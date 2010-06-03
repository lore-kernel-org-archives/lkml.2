Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751857Ab0FCLu7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 07:50:59 -0400
Received: from vs81.sauer-cs.de ([80.244.252.81]:55437 "EHLO kbdbabel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751726Ab0FCLu6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 07:50:58 -0400
Date: Thu, 3 Jun 2010 15:50:24 +0400 (MSD)
From: Alexander Kurz <linux@blala.de>
X-X-Sender: linux@blala.de
To: Randy Dunlap <randy.dunlap@oracle.com>
cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Alexander Kurz <linux@kbdbabel.org>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, gregkh@suse.de
Subject: [PATCH] staging/comedi: fixing ni_labpc to mite dependancy
In-Reply-To: <20100602100735.0812c063.randy.dunlap@oracle.com>
Message-ID: <alpine.DEB.1.10.1006031545010.23736@blala.de>
References: <20100602151439.6de66132.sfr@canb.auug.org.au> <20100602100735.0812c063.randy.dunlap@oracle.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
 the dependancy of ni_labpc on mite was missing,
 it will be fixed with this patch
 thanks for the report,
 Alexander

>From d310498ef2a61057c3f28b10bb417238f33e8265 Mon Sep 17 00:00:00 2001
From: Alexander Kurz <linux@kbdbabel.org>
Date: Thu, 3 Jun 2010 12:00:37 +0200
Subject: [PATCH] staging/comedi: fixing ni_labpc to mite dependancy

Signed-off-by: Alexander Kurz <linux@kbdbabel.org>
---
 drivers/staging/comedi/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/comedi/Kconfig b/drivers/staging/comedi/Kconfig
index 0aa2b0d..79f5f2e 100644
--- a/drivers/staging/comedi/Kconfig
+++ b/drivers/staging/comedi/Kconfig
@@ -1272,6 +1272,7 @@ config COMEDI_NI_TIO
 
 config COMEDI_NI_LABPC
 	tristate "NI Lab-PC and compatibles ISA and PCI support"
+	depends on COMEDI_MITE
 	select COMEDI_8255
 	select COMEDI_FC
 	default N
-- 
1.7.1


On Wed, 2 Jun 2010, Randy Dunlap wrote:
> On Wed, 2 Jun 2010 15:14:39 +1000 Stephen Rothwell wrote:
> > 
> > Changes since 20100601:
> randconfig build ends with:
> 
> ERROR: "mite_list_devices" [drivers/staging/comedi/drivers/ni_labpc.ko] undefined!
> ERROR: "mite_unsetup" [drivers/staging/comedi/drivers/ni_labpc.ko] undefined!
> ERROR: "mite_setup" [drivers/staging/comedi/drivers/ni_labpc.ko] undefined!
> ERROR: "mite_devices" [drivers/staging/comedi/drivers/ni_labpc.ko] undefined!
