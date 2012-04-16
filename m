Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754496Ab2DPTzW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 15:55:22 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:46358 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753639Ab2DPTzU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 15:55:20 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mikko Vinni <mmvinni@yahoo.com>
Subject: Re: [linux-pm] "i8042: Can't reactivate AUX port" after s2ram on 3.4-rc2
Date: Mon, 16 Apr 2012 21:59:55 +0200
User-Agent: KMail/1.13.6 (Linux/3.4.0-rc3+; KDE/4.6.0; x86_64; ; )
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Allen Kay <allen.m.kay@intel.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
References: <1334310754.17013.YahooMailNeo@web161804.mail.bf1.yahoo.com> <201204161817.21800.rjw@sisk.pl> <1334602665.33371.YahooMailNeo@web161806.mail.bf1.yahoo.com>
In-Reply-To: <1334602665.33371.YahooMailNeo@web161806.mail.bf1.yahoo.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201204162159.55539.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, April 16, 2012, Mikko Vinni wrote:
> From: Rafael J. Wysocki:
> 
> >>  Ok, I tested v4 and also v3, which is in 3.4-rc3. On this laptop both 
> > versions
> >>  work equally: touchpad works after resume (no help for the card reader
> >>  problem, though).
> > 
> > [...]
> > 
> >>  Difference from v3:
> >>  --- /tmp/v3-uniq        2012-04-16 09:57:42.880521878 +0300
> >>  +++ /tmp/v4-uniq        2012-04-16 09:58:03.880545386 +0300
> >>  @@ -1019,11 +1018,11 @@
> >>         1 Booting Node 0 Processor 1 APIC 0x1
> >>         1 CPU1 is up
> >>         1 ACPI: Waking up from system sleep state S3
> >>  -     11 pcieport 0000:00:02.0: restoring config space at offset 0x1c (was 
> > 0x20005151, writing 0x5151)
> >>  +      1 pcieport 0000:00:02.0: restoring config space at offset 0x1c (was 
> > 0x20005151, writing 0x5151)
> > 
> > OK, so clearly we need to prevent the writes into the secondary status register
> > of the PCIe port from being repreated pointlessly.
> > 
> > Can you please test the appended patch from completness on top of 3.4-rc3?
> 
> I think that's what I did already :)
> 
> git pull to 3.4-rc3
> (test, result as v3 output/diff in the previous email)
> Revert "PCI: Fix regression in pci_restore_state(), v3"
> apply v4 of the patch
> (test, result as v4 output in the previous email)
> git diff v3.4-rc3 -- drivers/pci/pci.c --> matches the patch below

Well, that's correct. :-)

Thanks a lot anyway,
Rafael
