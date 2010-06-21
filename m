Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751818Ab0FUE6q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 00:58:46 -0400
Received: from adelie.canonical.com ([91.189.90.139]:39744 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751449Ab0FUE6o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 00:58:44 -0400
Date: Sun, 20 Jun 2010 22:58:33 -0600
From: Alex Chiang <achiang@canonical.com>
To: David Miller <davem@davemloft.net>
Cc: bmb@athenacr.com, jbarnes@virtuousgeek.org, rjw@sisk.pl, mikpe@it.uu.se,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       maciej.rutecki@gmail.com
Subject: Re: [Bug #16161] [2.6.35-rc1 regression] sysfs: cannot create
 duplicate filename ... XVR-600 related?
Message-ID: <20100621045832.GA2274@canonical.com>
Mail-Followup-To: Alex Chiang <achiang@canonical.com>,
	David Miller <davem@davemloft.net>, bmb@athenacr.com,
	jbarnes@virtuousgeek.org, rjw@sisk.pl, mikpe@it.uu.se,
	linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
	maciej.rutecki@gmail.com
References: <20100618131049.462ca7ce@virtuousgeek.org>
 <20100618.132655.260090086.davem@davemloft.net>
 <4C1BD9CC.5060300@athenacr.com>
 <20100618.140110.246534188.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100618.140110.246534188.davem@davemloft.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* David Miller <davem@davemloft.net>:
> From: Brian Bloniarz <bmb@athenacr.com>
> Date: Fri, 18 Jun 2010 16:40:44 -0400
> 
> > In the patch, 2 individual code paths were trying to
> > create the same symlinks:
> > pci-sysfs.c:pci_create_slot_links(struct pci_dev *dev)
> > and
> > slot.c:create_sysfs_files(struct pci_slot *slot).
> > I think some archs managed to call those both during
> > initialization, and some not.
> 
> Right, and if I recall correctly when adding sparc64 support for
> the sysfs slot stuff if you wanted to create the slots in a
> non-hotplug situation (which all of the sparc64 cases are) you
> had to defer the sysfs node creation to later in the boot than
> when the PCI buses are actually probed and populated.

Yeah, we call pci_create_sysfs_dev_files() from pci_sysfs_init()
and from pci_bus_add_device().

I haven't figured out why it is that creating other sysfs files,
e.g. rom files, capabilities, etc. don't also result in duplicate
entries while the slots do.

Clearly my expectation was incorrect for the cases when
pci_create_sysfs_dev_files() gets called on the different
architectures.

Anyhow, thanks for the revert Jesse. I wish I had more
time/energy to dig into this right now, but I really don't.
Sorry.

/ac
