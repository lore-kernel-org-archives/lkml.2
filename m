Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932467Ab1CDSnc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 13:43:32 -0500
Received: from oproxy2-pub.bluehost.com ([67.222.39.60]:52638 "HELO
	oproxy2-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759975Ab1CDSna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 13:43:30 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=r9NV2SYl41iWa4CZBM50K6V9P+CZI8oq7bsvQz2pqYYH/KqsXw4lsAgUpRNgV6BzS9OrgAjFr/hR8VfiqJCFEiBcbEv1WMy6zBHyWCa56LPZBTu4zPuFzT2pLHQds9D9;
Date: Fri, 4 Mar 2011 10:43:25 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Jiri Slaby <jslaby@suse.cz>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        jirislaby@gmail.com, Bjorn Helgaas <bjorn.helgaas@hp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Renninger <trenn@suse.de>
Subject: Re: [PATCH 2/2] PCI: do not create quirk I/O regions below
 PCIBIOS_MIN_IO for ICH
Message-ID: <20110304104325.584ed94e@jbarnes-desktop>
In-Reply-To: <1298886310-11381-2-git-send-email-jslaby@suse.cz>
References: <1298886310-11381-1-git-send-email-jslaby@suse.cz>
	<1298886310-11381-2-git-send-email-jslaby@suse.cz>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.174.193.198 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Feb 2011 10:45:10 +0100
Jiri Slaby <jslaby@suse.cz> wrote:

> Some broken BIOSes on ICH4 chipset report an ACPI region which is in
> conflict with legacy IDE ports when ACPI is disabled. Even though the
> regions overlap, IDE ports are working correctly (we cannot find out
> the decoding rules on chipsets).
> 
> So the only problem is the reported region itself, if we don't reserve
> the region in the quirk everything works as expected.
> 
> This patch avoids reserving any quirk regions below PCIBIOS_MIN_IO
> which is 0x1000. Some regions might be (and are by a fast google
> query) below this border, but the only difference is that they won't
> be reserved anymore. They should still work though the same as before.
> 
> The conflicts look like (1f.0 is bridge, 1f.1 is IDE ctrl):
> pci 0000:00:1f.1: address space collision: [io 0x0170-0x0177] conflicts with 0000:00:1f.0 [io  0x0100-0x017f]
> 
> At 0x0100 a 128 bytes long ACPI region is reported in the quirk for
> ICH4. ata_piix then fails to find disks because the IDE legacy ports
> are zeroed:
> ata_piix 0000:00:1f.1: device not available (can't reserve [io 0x0000-0x0007])

Applied both of these, thanks.

-- 
Jesse Barnes, Intel Open Source Technology Center
