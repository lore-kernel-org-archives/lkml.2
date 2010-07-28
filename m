Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754821Ab0G1Kvr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 06:51:47 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38631 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754397Ab0G1Kvo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 06:51:44 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Subject: Re: [RFC][PATCH] PCI / PCIe: Ask BIOS for control of all native services simultaneously
Date: Wed, 28 Jul 2010 12:49:56 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-rc6-rjw+; KDE/4.4.4; x86_64; ; )
Cc: linux-pci@vger.kernel.org, Len Brown <lenb@kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        linux-pm@lists.linux-foundation.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Matthew Garrett <mjg@redhat.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
References: <201007250105.23610.rjw@sisk.pl> <4C4FA663.9090204@jp.fujitsu.com>
In-Reply-To: <4C4FA663.9090204@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201007281249.56722.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, July 28, 2010, Hidetoshi Seto wrote:
> Hi,
> 
> (2010/07/25 8:05), Rafael J. Wysocki wrote:
> > It turns out that asking ACPI BIOS, through _OSC, for control of each
> > PCIe port native service individually sometimes confuses the BIOS if
> > one sevice is requested while the others are not (eg. requesting
> > control of the native PCIe PME without requesting control of the
> > native PCIe hot-plug at the same time leads to interrupt storms on
> > some systems).
> 
> Then why not invent quirks or something for such systems?
> 
> IMHO it sounds like a BIOS bug since it should grant PME control to
> OS only when both of PME and pciehp (plus PCIe caps) are requested
> at same time.
> 
> Did you confirm that the system also confuses when pciehp is requested
> without requesting PME?
> e.g. assume that some BIOS might behave:
>   _OSC(pciehp)         =>  OK
>   _OSC(PME)            =>  NG (bugs on shared interrupt?)
>   _OSC(pciehp|PME)     =>  OK
>   _OSC(SHPC)           =>  OK
>   _OSC(pciehp|SHPC)    =>  NG (must choose one, not both)
>   _OSC(AER|SHPC)       =>  OK

The problem is the PCIe capability structure that is requested by each of
them (except for SHPC).  After granting it, the BIOS can't legitimately write
to the PCIe standard config registers, so it's reasonable to assume the kernel
will configure them from its perspective.

> I don't doubt that handling of _OSC needs some improvement...

Good. :-)

Rafael
