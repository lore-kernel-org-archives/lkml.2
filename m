Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756678Ab0FHViq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 17:38:46 -0400
Received: from cpoproxy1-pub.bluehost.com ([69.89.21.11]:41196 "HELO
	cpoproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756484Ab0FHVio (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 17:38:44 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=EyTvcG/EPZloKTfG5p32NvxTw90Tv9mtDDzbHKSZhEKNCjpmYj40XCEvIailb3LZ7WE/M5Glvq57TASWi6gR3w52Zu4UEMsuljCdVInjmeIuL0iNxNKKuCSMKbYTOxyo;
Date: Tue, 8 Jun 2010 14:37:39 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Jiri Slaby <jslaby@suse.cz>
Cc: linux-pci@vger.kernel.org,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Jiri Slaby <jirislaby@gmail.com>, achiang@hp.com
Subject: Re: cpqphp: NULL ptr deref in cpqhpc_probe
Message-ID: <20100608143739.192a94cd@virtuousgeek.org>
In-Reply-To: <4C0774C6.4090000@suse.cz>
References: <4C0774C6.4090000@suse.cz>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.110.194.140 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 03 Jun 2010 11:24:22 +0200
Jiri Slaby <jslaby@suse.cz> wrote:

> Hi,
> 
> we have a system where there is a pci hotplug class device to be handled
> by cpqphp, but it is not a bridge. But in cpqhpc_probe there is:
> struct pci_bus *bus;
> ...
> bus = pdev->subordinate;
> ...
> bus->max_bus_speed = PCI_SPEED_66MHz_PCIX;
> 
> But as it is not a bridge, subordinate is NULL and the kernel crashes.
> 
> Any idea what would be a correct fix here?
> 
> The bugzilla entry is at:
> https://bugzilla.novell.com/show_bug.cgi?id=609338

I don't think we have anyone actively working on CPQHPC these days.
Seems like the simple patch would be to check whether pdev->subordinate
or bus exists before using it...  Have you poked around for specs on
this at all?

-- 
Jesse Barnes, Intel Open Source Technology Center
