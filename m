Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760062Ab0JGDC1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 23:02:27 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:53153 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760050Ab0JGDCZ (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Wed, 6 Oct 2010 23:02:25 -0400
Date: Wed, 6 Oct 2010 22:59:23 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Bruce Edge <bruce.edge@gmail.com>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com, hpa@zytor.com,
        alex.williamson@redhat.com, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: Re: [Xen-devel] Re: [PATCH 16/20] x86: Introduce x86_msi_ops
Message-ID: <20101007025923.GB8272@dumpdata.com>
References: <1280945955-14229-1-git-send-email-konrad.wilk@oracle.com>
 <1280945955-14229-17-git-send-email-konrad.wilk@oracle.com>
 <20100831183140.GA3431@dumpdata.com>
 <20100923144826.GA29015@dumpdata.com>
 <AANLkTinor8_okhpQ1M_DGubAp50M4j2T1RFO-TTi0Q2b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinor8_okhpQ1M_DGubAp50M4j2T1RFO-TTi0Q2b@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 23, 2010 at 04:18:42PM -0700, Bruce Edge wrote:
> On Thu, Sep 23, 2010 at 7:48 AM, Konrad Rzeszutek Wilk
> <konrad.wilk@oracle.com> wrote:
> > On Tue, Aug 31, 2010 at 02:31:40PM -0400, Konrad Rzeszutek Wilk wrote:
> >> On Wed, Aug 04, 2010 at 02:19:11PM -0400, Konrad Rzeszutek Wilk wrote:
> >> > From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> >> >
> >> > Introduce an x86 specific indirect mechanism to setup MSIs.
> >> > The MSI setup functions become function pointers in an x86_msi_ops
> >> > struct, that defaults to the implementation in io_apic.c
> >>
> >> Hey Peter,
> >>
> >> I was wondering if you have time to take a look at this?
> >
> > ping?
> >>
> >> The patchset introduces a driver which takes care of allowing
> >> pci_conf_read/write in a virtualized environements with PCI
> >> passthrough devices. Unfortunatly for MSI operations that is not
> >> so simple, so this patch alongside with the previous one
> >> (https://patchwork.kernel.org/patch/117105/)
> >> expands the arch_* calls. This makes it possible to register on top
> >> of the native callback (the virtualized ones can), if required.
> >>
> 
> Is this patch required for PCI passthrough devices that use MSI interrupts?

Yes. And also for MSI-X. However, I've just posted a new updated mechanism based
on Thomas's idea - which is superior to this one.

> 
> I'm wondering because I'm seeing drivers for PCI passthrough  are able
> to init the MSI interrupts OK, but never get any interrupts with pvops
> domU kernels.

The problem you are seeing is different, I think we can narrow it down
to the dom0 doing something wacked.

