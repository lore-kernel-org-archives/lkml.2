Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756205Ab0IXQyE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 12:54:04 -0400
Received: from cpoproxy1-pub.bluehost.com ([69.89.21.11]:58966 "HELO
	cpoproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753822Ab0IXQx6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 12:53:58 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=Yw48KHfM8vyPEF+sQVKRFRvpGS3kA+Fwx/IJ0zJLaDeikuKYb9E1/GIVxFNP2GhTwCJtykW0ShDVzSU0hYoNieu0TvZSzSNjr5z+BNomk1jFbPdALbtwUTCHaVEt1eSu;
Date: Fri, 24 Sep 2010 09:53:55 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Chen Gong <gong.chen@linux.intel.com>, LKML <linux-kernel@vger.kernel.org>,
        linux-pci@vger.kernel.org, Huang Ying <ying.huang@intel.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Subject: Re: [PATCH] PCI / PCIe / AER: Disable native AER service if BIOS
 has precedence (v2) (was: Re: [PATCH]  PCI / PCIe / AER ...)
Message-ID: <20100924095355.36a7b064@jbarnes-desktop>
In-Reply-To: <201009201850.00626.rjw@sisk.pl>
References: <201009200002.15609.rjw@sisk.pl>
	<4C96FCA3.2060704@linux.intel.com>
	<201009201850.00626.rjw@sisk.pl>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.174.193.198 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Sep 2010 18:50:00 +0200
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> On Monday, September 20, 2010, Chen Gong wrote:
> > 于 9/20/2010 6:02 AM, Rafael J. Wysocki 写道:
> > > From: Rafael J. Wysocki<rjw@sisk.pl>
> > >
> > > There is a design issue related to PCIe AER and _OSC that the BIOS
> > > may be asked to grant control of the AER service even if some
> > > Hardware Error Source Table (HEST) entries contain information
> > > meaning that the BIOS really should control it.  Namely,
> > > pcie_port_acpi_setup() calls pcie_aer_get_firmware_first() that
> > > determines whether or not the AER service should be controlled by
> > > the BIOS on the basis of the HEST information for the given PCIe
> > > port.  The BIOS is asked to grant control of the AER service for
> > > a PCIe Root Complex if pcie_aer_get_firmware_first() returns 'false'
> > > for at least one root port in that complex, even if all of the other
> > > root ports' HEST entries have the FIRMWARE_FIRST flag set (and none
> > > of them has the GLOBAL flag set).  However, if the AER service is
> > > controlled by the kernel, that may interfere with the BIOS' handling
> > > of the error sources having the FIRMWARE_FIRST flag.  Moreover,
> > > there may be PCIe endpoints that have the FIRMWARE_FIRST flag set in
> > > HEST and are attached to the root ports in question, in which case it
> > > also may be unsafe to ask the BIOS for control of the AER service.
> > >
> > > For this reason, introduce a function checking if there's at least
> > > one PCIe-related HEST entry with the FIRMWARE_FIRST flag set and
> > > disable the native AER service altogether if this function returns
> > > 'true'.

Applied the second patch to my linux-next branch, thanks.

-- 
Jesse Barnes, Intel Open Source Technology Center
