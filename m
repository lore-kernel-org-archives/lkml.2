Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752259Ab2AVTWh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jan 2012 14:22:37 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:55092 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751982Ab2AVTWf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jan 2012 14:22:35 -0500
MIME-Version: 1.0
In-Reply-To: <1327141448-15281-1-git-send-email-yinghai@kernel.org>
References: <1327141448-15281-1-git-send-email-yinghai@kernel.org>
Date: Sun, 22 Jan 2012 11:22:34 -0800
X-Google-Sender-Auth: itrVUKRALmJh6kEA3BW_PKGxu4Y
Message-ID: <CAE9FiQVwU9gW2UsxbBxvdSJPFVFZOrgAha6TKvLqC4Ao3eD36g@mail.gmail.com>
Subject: Re: [RFC PATCH 0/3] PCI: allocate pci bus num range for bridge scan
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 21, 2012 at 2:24 AM, Yinghai Lu <yinghai@kernel.org> wrote:
>
> could be found at:
>        git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git for-pci-busn-alloc
>
>
>  arch/ia64/pci/pci.c              |    9 +
>  arch/powerpc/kernel/pci-common.c |   12 ++-
>  arch/x86/include/asm/topology.h  |    3 +-
>  arch/x86/pci/acpi.c              |   15 ++-
>  arch/x86/pci/bus_numa.c          |    8 +-
>  arch/x86/pci/common.c            |   11 +-
>  drivers/parisc/dino.c            |    9 +
>  drivers/parisc/lba_pci.c         |    8 +
>  drivers/pci/probe.c              |  298 +++++++++++++++++++++++++++++---------
>  drivers/pci/remove.c             |    1 +
>  include/linux/ioport.h           |    1 +
>  include/linux/pci.h              |    5 +
>  kernel/resource.c                |    8 +
>  13 files changed, 310 insertions(+), 78 deletions(-)

update the branch to have less change to other arch and add one patch
to separate
pci_scan_child_bus to two passes.

5cb2147: PCI: Seperate child bus scanning to two passes overall
0cfebdb: PCI: kill pci_fixup_parent_subordinate_busnr()
cd03e86: PCI: Allocate bus range instead of use max blindly
e3edd5b: PCI: Add iobusn_resource and insert root bus range to that tree.

 arch/ia64/pci/pci.c              |    2 +
 arch/powerpc/kernel/pci-common.c |    7 +-
 arch/x86/include/asm/topology.h  |    3 +-
 arch/x86/pci/acpi.c              |    8 +-
 arch/x86/pci/bus_numa.c          |    8 +-
 arch/x86/pci/common.c            |   11 +-
 drivers/parisc/dino.c            |    2 +
 drivers/parisc/lba_pci.c         |    3 +
 drivers/pci/probe.c              |  427 ++++++++++++++++++++++++++++++--------
 drivers/pci/remove.c             |    1 +
 include/linux/ioport.h           |    1 +
 include/linux/pci.h              |    8 +
 kernel/resource.c                |    8 +
 13 files changed, 395 insertions(+), 94 deletions(-)
