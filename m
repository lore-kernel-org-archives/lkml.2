Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754730Ab1LMVGH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 16:06:07 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:56145 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753324Ab1LMVGD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 16:06:03 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH][Regression fix] PCI / Hotplug: Always allow acpiphp to handle non-PCIe bridges
Date: Tue, 13 Dec 2011 22:09:04 +0100
User-Agent: KMail/1.13.6 (Linux/3.2.0-rc5+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-pci@vger.kernel.org,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
References: <201112130002.28907.rjw@sisk.pl> <20111213104220.5cfb78b2@jbarnes-desktop>
In-Reply-To: <20111213104220.5cfb78b2@jbarnes-desktop>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201112132209.04185.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, December 13, 2011, Jesse Barnes wrote:
> On Tue, 13 Dec 2011 00:02:28 +0100
> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > 
> > Commit 0d52f54e2ef64c189dedc332e680b2eb4a34590a (PCI / ACPI: Make
> > acpiphp ignore root bridges using PCIe native hotplug) added code
> > that made the acpiphp driver completely ignore PCIe root complexes
> > for which the kernel had been granted control of the native PCIe
> > hotplug feature by the BIOS through _OSC.  Unfortunately, however,
> > this was a mistake, because on some systems there were PCI bridges
> > supporting PCI (non-PCIe) hotplug under such root complexes and
> > those bridges should have been handled by acpiphp.
> > 
> > For this reason, revert the changes made by the commit mentioned
> > above and make register_slot() in drivers/pci/hotplug/acpiphp_glue.c
> > avoid registering hotplug slots for PCIe ports that belong to
> > root complexes with native PCIe hotplug enabled (which means that
> > the BIOS has granted the kernel control of this feature for the
> > given root complex).  This is reported to address the original
> > issue fixed by commit 0d52f54e2ef64c189dedc332e680b2eb4a34590a and
> > to work on the system where that commit broke things.
> > 
> > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> > ---
> 
> Applied to my for-linus branch.  I'll probably send to Linus on Thu. or
> so.
> 
> I also rebased the breakage out of linux-next.

Thanks a lot!

Rafael
