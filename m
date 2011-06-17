Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757155Ab1FQNcm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 09:32:42 -0400
Received: from smtprelay05.ispgateway.de ([80.67.31.97]:45681 "EHLO
	smtprelay05.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753987Ab1FQNcl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 09:32:41 -0400
Message-ID: <4DFB582E.7070909@ladisch.de>
Date: Fri, 17 Jun 2011 15:35:42 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
CC: Randy Dunlap <randy.dunlap@oracle.com>, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: non-printable characters in /proc/interrupts
References: <201106101040.20282.toralf.foerster@gmx.de> <20110610091132.90531e0e.randy.dunlap@oracle.com> <201106110038.43139.toralf.foerster@gmx.de>
In-Reply-To: <201106110038.43139.toralf.foerster@gmx.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Df-Sender: linux-kernel@cl.domainfactory-kunde.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Toralf Förster wrote:
> Randy Dunlap wrote at 18:11:32
> > On Fri, 10 Jun 2011 10:40:19 +0200 Toralf Förster wrote:
> > > I've wondering about this entry at my ThinkPad T400 (kernel 2.6.39.1):
> > > ...
> > >  44:     484163      55698   PCI-MSI-edge      ahci
> > >  45:        750       1809   PCI-MSI-edge      eth0
> > >  46:         94        213   PCI-MSI-edge      hda_intel
> > >  47:      44399      70713   PCI-MSI-edge      l▒��@�E�
> > >  48:      71969     102457   PCI-MSI-edge      iwlagn
> > 
> > Is there any other info (like dmesg or boot log) that tells what
> > device/driver uses interrupt 47 ?
> 
> I attached the dmesg output

> ahci 0000:00:1f.2: irq 44 for MSI/MSI-X
> e1000e 0000:00:19.0: irq 45 for MSI/MSI-X
> iwlagn 0000:03:00.0: irq 46 for MSI/MSI-X
> HDA Intel 0000:00:1b.0: irq 47 for MSI/MSI-X
> i915 0000:00:02.0: irq 48 for MSI/MSI-X

These interrupt numbers do not match; I'd guess that you rebooted and
that the drivers were initialized in a different order.

Anyway, it looks as if the i915 driver is the culprit.

A quick look into the DRM code shows that it uses dev->devname as
interrupt name, but that field might get freed by drm_setversion().
(Or I might be wrong; I don't have this hardware.)


Regards,
Clemens
