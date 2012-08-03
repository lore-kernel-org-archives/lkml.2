Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753178Ab2HCSMP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 14:12:15 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:47269 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751470Ab2HCSMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 14:12:13 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1208031728120.9164@bwv190.internetdsl.tpnet.pl>
References: <Pine.LNX.4.64.1208031728120.9164@bwv190.internetdsl.tpnet.pl>
Date: Fri, 3 Aug 2012 11:12:11 -0700
X-Google-Sender-Auth: jTMYi4QJVjlqDLVVKcB-a3eLXQ8
Message-ID: <CAE9FiQXzyxSNiPW96mqcN-Ki2RYZeKyYMJ39R50yjkgHnLMnYQ@mail.gmail.com>
Subject: Re: bisected pcmcia bug - unable to map card memory on old laptops
From: Yinghai Lu <yinghai@kernel.org>
To: Piotr Gluszenia Slawinski <curious@bwv190.internetdsl.tpnet.pl>,
        "H. Peter Anvin" <hpa@zytor.com>, Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-kernel@vger.kernel.org, linux-pcmcia@lists.infradead.org,
        linux-pci@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 3, 2012 at 8:32 AM, Piotr Gluszenia Slawinski
<curious@bwv190.internetdsl.tpnet.pl> wrote:
> Hello. I've bisected bug which makes old laptops fail to detect (any) pcmcia
> cards with message 'unable to map card memory!' .
> commit in question is :
>
> 30919b0bf356a8ee0ef4f7d38ca8ad99b96820b2 is the first bad commit
> commit 30919b0bf356a8ee0ef4f7d38ca8ad99b96820b2
> Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
> Date:   Thu Dec 16 10:38:51 2010 -0700
>
>     x86: avoid low BIOS area when allocating address space
>
>     This implements arch_remove_reservations() so allocate_resource() can
>     avoid any arch-specific reserved areas.  This currently just avoids the
>     BIOS area (the first 1MB), but could be used for E820 reserved areas if
>     that turns out to be necessary.
>
>     We previously avoided this area in pcibios_align_resource().  This patch
>     moves the test from that PCI-specific path to a generic path, so *all*
>     resource allocations will avoid this area.
>
>     Acked-by: H. Peter Anvin <hpa@zytor.com>
>     Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
>     Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
>
> :040000 040000 58cf7334131f8ad10bc814e56ef6538781b01add
> 2434a5e5da4eabf3e413ac694c0cdeef91e17680 M      arch
>
> bug is present in all kernels since late 2.6.36

can you send the boot log with working and not working kernel?
Please make sure you have PCI_DEBUG set in your config.

Thanks

Yinghai
