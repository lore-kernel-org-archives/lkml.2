Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756733Ab1HaPrv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 11:47:51 -0400
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:48379 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756563Ab1HaPrt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 11:47:49 -0400
Date: Wed, 31 Aug 2011 08:47:38 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Deng-Cheng Zhu <dczhu@mips.com>, ralf@linux-mips.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mips@linux-mips.org, eyal@mips.com, zenon@mips.com,
        dengcheng.zhu@gmail.com
Subject: Re: [PATCH v3 0/2] Pass resources to pci_create_bus() and fix MIPS
 PCI resources
Message-ID: <20110831084738.406d7055@jbarnes-desktop>
In-Reply-To: <CAErSpo69wROKy-4jtFteeSTUSWXiX+qk7YQTvcotstCL=cjUdA@mail.gmail.com>
References: <1314349633-13155-1-git-send-email-dczhu@mips.com>
	<CAErSpo5PgXs4tuihh_JZCePzD8FWWzwp=-VHxFGCCuRKRKOYFQ@mail.gmail.com>
	<CAErSpo506Mz3QSxxdpbxyCUuZvqMTNL+fT5R81ivoj7cDTFyJg@mail.gmail.com>
	<4E5DBDB0.4070505@mips.com>
	<CAErSpo69wROKy-4jtFteeSTUSWXiX+qk7YQTvcotstCL=cjUdA@mail.gmail.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Aug 2011 07:48:16 -0600
Bjorn Helgaas <bhelgaas@google.com> wrote:

> On Tue, Aug 30, 2011 at 10:50 PM, Deng-Cheng Zhu <dczhu@mips.com> wrote:
> > Hi, Bjorn
> >
> >
> > Thanks for your constructive review.
> >
> >> One logistical issue here is that the first patch touches several
> >> architectures at once, which puts Jesse in a bit of a pinch.  If he
> >> applies it, there's always the possibility that an arch patch will
> >> conflict with it, which makes merging harder.
> >
> > In case the conflicts happen, the effort to resolve them should be
> > trivial (a matter of an extra NULL argument), I suppose. Also, the odds
> > of other incoming arch patches making a reference to pci_create_bus()
> > should not be great.
> >
> >> It might be easier if, instead of changing the pci_create_bus()
> >> interface, you added a new one (it could call pci_create_bus() then
> >> replace the resources, so the implementation could still be mostly
> >> shared.)  We already have a plethora of "create bus" methods
> >> (pci_create_bus(), pci_scan_bus_parented(), pci_scan_bus()), but if
> >> you added a pci_create_root_bus() or something similar, maybe we could
> >> try to converge on it and obsolete the others.
> >>
> >> Then the first patch would touch only the PCI core, and the second
> >> would touch only MIPS, which would make merging more straightforward.
> >>
> >
> > Hmm.. Adding a wrapper of pci_create_bus() does leave other
> > architectures alone for this merging. But before all of them converge on
> > it (a long way to go), the wrapper is adding naming confusion to the
> > PCI core. Personally I think the current low-level transparent change to
> > pci_create_bus() is appropriate enough. Does anybody have comments?
> >
> >
> > Deng-Cheng
> 
> Just to be clear, I'm fine with it either way, as long as Jesse and
> the arch maintainers are OK with it.

I'm fine merging the arch bits too, as long as you can get some arch
maintainer acks.  If there are conflicts Linus will flag them (he likes
to fix the occasional merge problem anyway).

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
