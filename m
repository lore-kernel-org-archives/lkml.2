Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754010Ab1KUNDP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 08:03:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41998 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753494Ab1KUNDO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 08:03:14 -0500
Date: Mon, 21 Nov 2011 14:05:28 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: =?utf-8?B?VG9tw6HFoSBKYW5vdcWhZWs=?= <tomi@nomi.cz>
Cc: linux-kernel@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>,
        linux-wireless@vger.kernel.org
Subject: Re: iwlagn: memory corruption with WPA enterprise
Message-ID: <20111121130527.GA4010@redhat.com>
References: <20111109165158.GA2254@redhat.com>
 <20111110091816.GA2247@nomi.cz>
 <20111110114732.GA2217@redhat.com>
 <20111110125347.GA29415@nomi.cz>
 <20111110160703.GA2775@redhat.com>
 <20111110163051.GA24533@nomi.cz>
 <20111111054731.GA2292@redhat.com>
 <20111111150105.GA25437@nomi.cz>
 <20111114140714.GD2513@redhat.com>
 <20111119181106.GA5515@nomi.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20111119181106.GA5515@nomi.cz>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomáš

On Sat, Nov 19, 2011 at 07:11:06PM +0100, Tomáš Janoušek wrote:
> On Mon, Nov 14, 2011 at 03:07:15PM +0100, Stanislaw Gruszka wrote:
> > On Fri, Nov 11, 2011 at 04:01:05PM +0100, Tomáš Janoušek wrote:
> > > Could you please elaborate on that thing with enabling IOMMU? The only thing I
> > > know about IOMMU is that it is somehow related to VT-d (passing whole PCI
> > > devices to virtual guests), and that I have to pass intel_iommu=off to kernel
> > > command line, otherwise the machine doesn't even boot. Is that a problem?
> > Yes. That mean iommu software or hardware is broken on your system.
> >
> > I have no other ideas how to track this down. I think now, this is
> > a firwmare issue. BTW, you suspected that from very beginning :-)
> > This could be also a driver issue, but AFAICT programing DMA do not
> > differ on 6205 from other devices, so bug in firmware is much more
> > probable reason of corruption.
> 
> I have some news. I got IOMMU to work, because I identified the problem [1]
> and disabled firewire-ohci for the time being completely, but I'm not sure
> what do I need to do to make it catch the problem. I assumed that all I need
> is to intel_iommu=on and then all devices do DMA stuff in isolation, but I can
> still reproduce the issue without the smallest hint of an error in dmesg. Does
> it tell us anything, or shall I enable some more debugging stuff?
> 
> [1] http://thread.gmane.org/gmane.linux.kernel.pci/8765/focus=1217800

The farther we get the problem is more and more strange.

Device that write to wrong address, would generate:

DMAR:[DMA Write] Request device [00:02.0] fault addr 6df084000
DMAR:[fault reason 05] PTE Write access is not set

But only if

PCI-DMA: Using DMAR IOMMU

was printed in dmesg before. DMAR can be disabled by graphics
driver, or maybe by other drivers too. Then above print will
be missed in dmesg and protection would not work.

Try "dmesg | grep DMAR" to see if DMA remapping is really is
in use. 

Stanislaw
