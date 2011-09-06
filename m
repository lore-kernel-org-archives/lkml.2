Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752900Ab1IFGZi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 02:25:38 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:47598 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730Ab1IFGZW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 02:25:22 -0400
Subject: Re: linux-3.1-0-rc4 bus error ... MPS configured higher than
 maximum supported by the device. If a bus issue occurs, try running with
 pci=pcie_bus_safe.
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Jeff Chua <jeff.chua.linux@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Jordan_Hargrave@dell.com,
        Jon Mason <mason@myri.com>, Jesse Barnes <jbarnes@virtuousgeek.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <CAAJw_ZvP6m=3T0YoYq6VJdOKMxzm3fDcdJoDY8wqqDV8GZB+Dg@mail.gmail.com>
References: <CAAJw_Zv9LaOut6+aQWki_-nCngEEfh-OVqF4rsUwb-LPfLk8Ug@mail.gmail.com>
	 <CAAJw_ZvP6m=3T0YoYq6VJdOKMxzm3fDcdJoDY8wqqDV8GZB+Dg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 06 Sep 2011 08:25:13 +0200
Message-ID: <1315290313.2565.0.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 06 septembre 2011 à 14:09 +0800, Jeff Chua a écrit :
> On Mon, Sep 5, 2011 at 10:55 PM, Jeff Chua <jeff.chua.linux@gmail.com> wrote:
> > Got the following error after upgrading from linux-2.6.36 to
> > linux-3.1.0-rc4 on a Dell PowerEdge 2950 that has a PCIe fax card, and
> > the system LED panel shows "Bus Fatal Error".
> >
> >
> > Is is normal or should I try out "pci=pcie_bus_safe" or "pci=pci" as
> > suggested in the dmesg?
> >
> > There was another error that also showed up on 2.6.36 but I'm ignoring
> > that for now ( ... disabling ASPM on pre-1.1 PCIe device.  You can
> > enable it with 'pcie_aspm=force')
> >
> > pci 0000:07:00.0: Dev MPS 128 MPSS 256 MRRS 4096
> > pci 0000:07:00.0: Dev MPS 256 MPSS 256 MRRS 128
> > pci 0000:08:00.0: Dev MPS 128 MPSS 128 MRRS 128
> > pci 0000:08:00.0: MPS configured higher than maximum supported by the
> > device.  If a bus issue occurs, try running with pci=pcie_bus_safe.
> > pci 0000:08:00.0: Dev MPS 256 MPSS 256 MRRS 128
> > Uhhuh. NMI received for unknown reason 31 on CPU 0.
> > Do you have a strange power saving mode enabled?
> > Dazed and confused, but trying to continue
> > pci 0000:07:01.0: Dev MPS 128 MPSS 256 MRRS 4096
> > pci 0000:07:01.0: Dev MPS 256 MPSS 256 MRRS 128
> > pci 0000:00:06.0: Dev MPS 256 MPSS 256 MRRS 128
> > pci 0000:0e:00.0: Dev MPS 128 MPSS 128 MRRS 512
> > pci 0000:0e:00.0: MPS configured higher than maximum supported by the
> > device.  If a bus issue occurs, try running with pci=pci
> 
> The above aspm and bus error went away after I added pcie_aspm=force
> and pci=pcie_bus_safe.
> 
> Instead of default to pcie_bus_perf that caused problems, why not
> default to the formal behavior (see commit
> b03e7495a862b028294f59fc87286d6d78ee7fa1).

I believe a revert is in progress anyway, see my other thread (scsi:
hpsa: how to destroy your files)



