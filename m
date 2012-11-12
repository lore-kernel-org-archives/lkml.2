Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752114Ab2KLSlN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 13:41:13 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:51714 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751576Ab2KLSlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 13:41:12 -0500
MIME-Version: 1.0
In-Reply-To: <ADE657CA350FB648AAC2C43247A983F00206B25884B1@AUSP01VMBX24.collaborationhost.net>
References: <ADE657CA350FB648AAC2C43247A983F00206B25884B1@AUSP01VMBX24.collaborationhost.net>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 12 Nov 2012 11:40:50 -0700
Message-ID: <CAErSpo6WG2R_8sa=rOmAOci-3iFpDs2NFzNkZYxDnD2oTiMQJg@mail.gmail.com>
Subject: Re: Q: Kconfig option VIRT_TO_BUS
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 12, 2012 at 9:18 AM, H Hartley Sweeten
<hartleys@visionengravers.com> wrote:
> Hello all,
>
> Does anyone know what the Kconfig option VIRT_TO_BUS does?
> There are a number of "depends on" that option but it does not
> seem to directly enable any code in the kernel.

virt_to_bus() is a deprecated interface for converting a kernel
virtual address to a bus address.  It's deprecated because it's
impossible to implement correctly when there are multiple bus address
spaces, because you don't know which bus address space the caller has
in mind.

See Documentation/DMA-API-HOWTO.txt and
Documentation/bus-virt-phys-mapping.txt for more details about
virt_to_bus() and its replacements (dma_map_*()).

It looks like f057eac0d7ad967138390a9dd7fd8267e1e39d19 added
CONFIG_VIRT_TO_BUS as a way to prevent drivers that use virt_to_bus()
from being built on architectures that can't support virt_to_bus().

Architectures that can't implement virt_to_bus() set
CONFIG_ARCH_NO_VIRT_TO_BUS.  It looks like powerpc, sh, and sparc
currently set it, but ia64, x86, and probably other arches should also
set it.

Bjorn
