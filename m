Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760179Ab1CDUcj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 15:32:39 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:52784 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751746Ab1CDUch (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 15:32:37 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: Re: [PATCH 0/2] Re: 2.6.38 regression caused by commit 415e12b
Date: Fri, 4 Mar 2011 21:32:35 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc7+; KDE/4.4.4; x86_64; ; )
Cc: linux-usb@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>,
        Ozan Caglayan <ozan@pardus.org.tr>
References: <20110228014218.GA11083@xanatos> <201103022330.49297.rjw@sisk.pl> <20110304175210.GA3798@xanatos>
In-Reply-To: <20110304175210.GA3798@xanatos>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201103042132.35711.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, March 04, 2011, Sarah Sharp wrote:
> On Wed, Mar 02, 2011 at 11:30:49PM +0100, Rafael J. Wysocki wrote:
> > On Wednesday, March 02, 2011, Rafael J. Wysocki wrote:
> > > There are two problems.  First, your BIOS says that ASPM is not supported
> > > by it, so we don't call _OSC, which should be fixed by the previous patch.
> > > Second, pci_msi_enabled() returns 0 on your system, which is kind of strange,
> > > because it evidently uses MSIs (as visible in the dmesg).
> > > 
> > > While I think we can safely request _OSC control even if ASPM is not supported
> > > by the hardware (according to the BIOS), which is done after the first patch,
> > > we need to figure out why 0 is returned by pci_msi_enabled() on your system
> > > and try to work around that.
> > 
> > Regardless, I think we should report MSI and ASPM support to the BIOS unless
> > directly disabled via the kernel command line or .config.
> > 
> > I'm going to send two patches in replies to this message.  Please apply them
> > both on top of 2.6.38-rc7 and report back.
> 
> I applied your patches on top of 2.6.38-rc6 again and tested them.
> dmesg is attached.  Let me know if you need me to test Linus' latest
> instead.

-rc6 should be fine.

I don't understand why pci_no_msi_support() is called on your system even
though pci=nomsi is not in the kernel command line.

Please apply this patch on top of the previous two and send me dmesg.

---
 drivers/pci/msi.c |    2 ++
 1 file changed, 2 insertions(+)

Index: linux-2.6/drivers/pci/msi.c
===================================================================
--- linux-2.6.orig/drivers/pci/msi.c
+++ linux-2.6/drivers/pci/msi.c
@@ -858,6 +858,8 @@ void pci_no_msi(void)
 
 void pci_no_msi_support(void)
 {
+	dump_stack();
+
 	msi_support_enabled = false;
 	pci_no_msi();
 }
