Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756010Ab1JGVvR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 17:51:17 -0400
Received: from smtp-out.google.com ([74.125.121.67]:61253 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754672Ab1JGVvP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 17:51:15 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=cswvRyEOvXoIo94yjTvhJ8IoA+2f1F70CDZVdialb+/iklPlzi3pkMlG0KR4YvdWf
	ue6Eevz6NtcYSliFTaeHA==
MIME-Version: 1.0
In-Reply-To: <1314845309-3277-1-git-send-email-dczhu@mips.com>
References: <1314845309-3277-1-git-send-email-dczhu@mips.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 7 Oct 2011 15:50:49 -0600
Message-ID: <CAErSpo5py82G1=6BOTG4RSAj6_SRzN4fng6sECU2sS+u9quixw@mail.gmail.com>
Subject: Re: [RESEND PATCH v3 0/2] Pass resources to pci_create_bus() and fix
 MIPS PCI resources
To: Deng-Cheng Zhu <dczhu@mips.com>
Cc: jbarnes@virtuousgeek.org, ralf@linux-mips.org, monstr@monstr.eu,
        benh@kernel.crashing.org, paulus@samba.org, davem@davemloft.net,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mips@linux-mips.org, eyal@mips.com, zenon@mips.com,
        dengcheng.zhu@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 31, 2011 at 8:48 PM, Deng-Cheng Zhu <dczhu@mips.com> wrote:
> (Resending the patch set to include more arch maintainers.)
>
> Change the pci_create_bus() interface to pass in available resources to get them
> settled down early. This is to avoid possible resource conflicts while doing
> pci_scan_slot() in pci_scan_child_bus(). Note that pcibios_fixup_bus() can get
> rid of such conflicts, but it's done AFTER scanning slots.
>
> In addition, MIPS PCI resources are now fixed using this new interface.

Jesse, I assume these are headed for the 3.2 merge window, right?

Do you have a git tree anywhere where we could check without having to
bother you?

Bjorn

> -- Changes --
> v3 - v2:
> o Do not do fixups for root buses in pcibios_fixup_bus().
> o Skip bus creation when bus resources cannot be allocated.
> o PCI domain/bus numbers added to the error info in controller_resources().
>
> v2 - v1:
> o Merge [PATCH 1/3] to [PATCH 3/3], so now 2 patches in total.
> o Add more info to patch description.
> o Fix arch breaks in default resource setup discovered by Bjorn Helgaas.
>
> Deng-Cheng Zhu (2):
>  PCI: Pass available resources into pci_create_bus()
>  MIPS: PCI: Pass controller's resources to pci_create_bus() in
>    pcibios_scanbus()
>
>  arch/microblaze/pci/pci-common.c |    3 +-
>  arch/mips/pci/pci.c              |   61 +++++++++++++++++++++++++++++++++-----
>  arch/powerpc/kernel/pci-common.c |    3 +-
>  arch/sparc/kernel/pci.c          |    3 +-
>  arch/x86/pci/acpi.c              |    2 +-
>  drivers/pci/probe.c              |   15 +++++++--
>  include/linux/pci.h              |    3 +-
>  7 files changed, 73 insertions(+), 17 deletions(-)
>
>
