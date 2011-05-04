Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754657Ab1EDBjG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 21:39:06 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:38577 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754593Ab1EDBjE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 21:39:04 -0400
Subject: Re: Long timeout when booting >= 2.6.38
From: john stultz <johnstul@us.ibm.com>
To: Christian Hoffmann <email@christianhoffmann.info>
Cc: lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <4DC04E15.2030308@christianhoffmann.info>
References: <4DBEFCBA.3070501@christianhoffmann.info>
	 <1304363375.3226.5.camel@work-vm> <4DBF1725.3030800@christianhoffmann.info>
	 <1304372955.3226.15.camel@work-vm>
	 <4DBF2FB4.8000304@christianhoffmann.info>
	 <1304382664.3226.24.camel@work-vm>
	 <4DC04E15.2030308@christianhoffmann.info>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 03 May 2011 18:38:54 -0700
Message-ID: <1304473134.3037.14.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-03 at 20:48 +0200, Christian Hoffmann wrote:
> Hi,
> 
> > Could you send me the full dmesg output both with and without the
> > 08ec0c58fb8a05d3191d5cb6f5d6f81adb419798 commit applied?
> 
> broken.dmesg is kernel at 08ec0c58fb8a05d3191d5cb6f5d6f81adb419798
> working.dmesg is 08ec0c58fb8a05d3191d5cb6f5d6f81adb419798 - 1
> 
> >
> > Also, does the same issue crop up if you compile the kernel with
> > CONFIG_PCI_MSI disabled?
> >
> 
> I can't really disable this, can I? This gets set by other presets. I 
> tried to use pci=nomsi, but i see same issue (but I also see the MSI 
> quirks in dmesg, so not sure if this is working).
> 
> I didn't cc the linux-kernel, as I don't know if I am supposed to post 
> dmesg/attachements.

Can you send dmesg on a broken kernel with the following patch added?

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 5129ed6..6718e7f 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -2791,6 +2791,7 @@ static void pci_do_fixups(struct pci_dev *dev, struct pci_fixup *f,
 		if ((f->vendor == dev->vendor || f->vendor == (u16) PCI_ANY_ID) &&
 		    (f->device == dev->device || f->device == (u16) PCI_ANY_ID)) {
 			dev_dbg(&dev->dev, "calling %pF\n", f->hook);
+			printk("Calling fixup hook: %pF\n", f->hook);
 			f->hook(dev);
 		}
 		f++;






