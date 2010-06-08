Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756761Ab0FHWtb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 18:49:31 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:39239 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754344Ab0FHWt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 18:49:29 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH -v2] pci: clear bridge resource size if BIOS assign bad one
Date: Tue, 8 Jun 2010 16:48:58 -0600
User-Agent: KMail/1.13.2 (Linux/2.6.32-22-generic; KDE/4.4.2; x86_64; ; )
Cc: Yinghai Lu <yinghai.lu@oracle.com>,
       Yannick Roehlly <yannick.roehlly@free.fr>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <bug-16009-13546@https.bugzilla.kernel.org/> <4C0813D7.7080900@oracle.com> <20100608144350.366071fd@virtuousgeek.org>
In-Reply-To: <20100608144350.366071fd@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006081649.00332.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, June 08, 2010 03:43:50 pm Jesse Barnes wrote:
> On Thu, 03 Jun 2010 13:43:03 -0700
> Yinghai Lu <yinghai.lu@oracle.com> wrote:
> 
> > 
> > Make sure We can reject wrong size from BIOS.
> > 
> > https://bugzilla.kernel.org/show_bug.cgi?id=16009
> > Yannick found that video does not work with 2.6.34
> > 
> > the root cause:
> > BIOS assigned wrong range to pci bridge.  and before 2.6.34 kernel will
> > just get range that is needed.
> > for 2.6.34.
> > |	d65245c PCI: don't shrink bridge resources
> > will try to range size is bigger than old one.
> > (used by boot stage multi-try to get big BAR size for pci bridge,
> >  and pcie hotplug to get big range)
> > 
> > So try to 0 for old size for pci bridge in this boot stage case.
> > 
> > Reported-by: Yannick <yannick.roehlly@free.fr>
> > Analyzed-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
> > Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> > 
> 
> Bjorn, are you ok with this version?  It would probably help to have
> some comments here too (I can add them), indicating that we'll try to
> reassign the resource later, rather than just ignoring it as the
> existing comment implies.

I guess I'm ok with it.  I can't make much sense out of the changelog,
and I don't really understand how the reallocation stuff works.

In this case, the aperture *size* from the BIOS is actually OK, but
the beginning of the aperture overlaps system memory.  With Yinghai's
patch, we reduce the size and move the start.  Windows was able to
just move the start of the aperture and preserve the original
0x20000000 size (but I think it had to move something else out of
the way).

Bjorn
