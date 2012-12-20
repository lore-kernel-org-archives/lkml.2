Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751842Ab2LTVQq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 16:16:46 -0500
Received: from g6t0187.atlanta.hp.com ([15.193.32.64]:38223 "EHLO
	g6t0187.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113Ab2LTVQh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 16:16:37 -0500
Message-ID: <1356037647.18964.384.camel@misato.fc.hp.com>
Subject: Re: [PATCH 0/16] ACPI: Rework ACPI namespace scanning for devices
From: Toshi Kani <toshi.kani@hp.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>, Myron Stowe <myron.stowe@redhat.com>,
        Yijing Wang <wangyijing0307@gmail.com>, Jiang Liu <liuj97@gmail.com>
Date: Thu, 20 Dec 2012 14:07:27 -0700
In-Reply-To: <1855256.SyhOJGYMIh@vostro.rjw.lan>
References: <8498184.VilrUmatxI@vostro.rjw.lan>
	 <1355789297.18964.334.camel@misato.fc.hp.com>
	 <4082842.31rfDviYHK@vostro.rjw.lan> <1855256.SyhOJGYMIh@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael,

The changes look very good.  It's much cleaner and consistent. :-)  For
the series:

Acked-by: Toshi Kani <toshi.kani@hp.com>

Thanks,
-Toshi


On Thu, 2012-12-20 at 02:45 +0100, Rafael J. Wysocki wrote:
> Hi all,
> 
> I've finally cut the patches removing acpi_pci_bind() and acpi_pci_unbind(),
> so I'm kind of ready to post the entire series reworking the ACPI namespace
> scanning code.
> 
> Patches [1-6/16] are essentially these ones:
> 
> https://patchwork.kernel.org/patch/1889821/
> https://patchwork.kernel.org/patch/1876481/
> https://patchwork.kernel.org/patch/1876531/
> https://patchwork.kernel.org/patch/1876571/
> https://patchwork.kernel.org/patch/1876511/
> https://patchwork.kernel.org/patch/1876401/
> 
> but [2-6/16] have been rebased on top of the first one.
> 
> Patches [7-12/16] are essentially these:
> 
> https://patchwork.kernel.org/patch/1884721/
> https://patchwork.kernel.org/patch/1884701/
> https://patchwork.kernel.org/patch/1884761/
> https://patchwork.kernel.org/patch/1884731/
> https://patchwork.kernel.org/patch/1884751/
> https://patchwork.kernel.org/patch/1884661/
> 
> but they have been rebased on top of https://patchwork.kernel.org/patch/1889821/.
> I added Yinghai's ACKs to them tentatively, although they are a bit different
> from the previous versions.  The difference is not too important, however,
> because the following patches finally remove the acpi_pci_bind()/acpi_pci_unbind()
> stuff:
> 
> [13/16] Add .setup() and .cleanup() callbacks to struct acpi_bus_type.
> [14/16] Rework the setup and cleanup of ACPI/PCI device wakeup.
> [15/16] Move the _PRT setup and cleanup code to pci-acpi.c.
> [16/16] Drop ACPI device .bind() and .unbind() callbacks.
> 
> This is done a bit differently than I thought it would be, mostly because the
> _PRT-related operations require the "subordinate" pointers of bridges to be
> populated.  I think it may be possible to simplify this further if that
> requirement can be removed (I haven't looked into that).
> 
> In fact, patches [13-15/16] do not essentially depend on [1-12/16], only the
> last one does.
> 
> The patches are on top of my master branch and I'm going to rebase them when
> v3.8-rc1 is out.
> 
> There is a git tree you can pull them from at:
> 
> http://git.kernel.org/?p=linux/kernel/git/rafael/linux-pm.git;a=summary acpi-scan-temp-new
> 
> It's v3.7 with my master branch merged and the new patches on top.
> 
> 
> Thanks,
> Rafael
> 
> 


