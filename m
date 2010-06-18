Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752186Ab0FRVBA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 17:01:00 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35268
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751771Ab0FRVA6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 17:00:58 -0400
Date: Fri, 18 Jun 2010 14:01:10 -0700 (PDT)
Message-Id: <20100618.140110.246534188.davem@davemloft.net>
To: bmb@athenacr.com
Cc: jbarnes@virtuousgeek.org, rjw@sisk.pl, mikpe@it.uu.se,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       maciej.rutecki@gmail.com, achiang@canonical.com
Subject: Re: [Bug #16161] [2.6.35-rc1 regression] sysfs: cannot create
 duplicate filename ... XVR-600 related?
From: David Miller <davem@davemloft.net>
In-Reply-To: <4C1BD9CC.5060300@athenacr.com>
References: <20100618131049.462ca7ce@virtuousgeek.org>
	<20100618.132655.260090086.davem@davemloft.net>
	<4C1BD9CC.5060300@athenacr.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Brian Bloniarz <bmb@athenacr.com>
Date: Fri, 18 Jun 2010 16:40:44 -0400

> In the patch, 2 individual code paths were trying to
> create the same symlinks:
> pci-sysfs.c:pci_create_slot_links(struct pci_dev *dev)
> and
> slot.c:create_sysfs_files(struct pci_slot *slot).
> I think some archs managed to call those both during
> initialization, and some not.

Right, and if I recall correctly when adding sparc64 support for
the sysfs slot stuff if you wanted to create the slots in a
non-hotplug situation (which all of the sparc64 cases are) you
had to defer the sysfs node creation to later in the boot than
when the PCI buses are actually probed and populated.
