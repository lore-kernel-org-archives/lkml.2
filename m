Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758590Ab1DMWh3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 18:37:29 -0400
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:59952 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754508Ab1DMWh1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 18:37:27 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=dT+DpnfOTU/HCcCoztVuk5XaYnoO/lVPDKElH/VM4nk/yw9j96iwCJb0FwlpfkmI2Xtnt4RZaByDbgyYxVGsEowcf7jWAMAyYiEJMNu+ZPTN0bw32pQGE2Ok1Z0q9dU3;
Date: Wed, 13 Apr 2011 15:37:24 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Xianghua Xiao <xiaoxianghua@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: Disable PCI while CONFIG_PCI=y
Message-Id: <20110413153724.5776f7e5.rdunlap@xenotime.net>
In-Reply-To: <BANLkTi=KvxPNuvZnL90SAmkQna=ARE6xyQ@mail.gmail.com>
References: <BANLkTikAqz5xBRfpxBuwxVujE--Qam2FsQ@mail.gmail.com>
	<20110413131054.8771d855.rdunlap@xenotime.net>
	<BANLkTi=KvxPNuvZnL90SAmkQna=ARE6xyQ@mail.gmail.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Apr 2011 17:01:38 -0500 Xianghua Xiao wrote:

> Yes I read that but my ARCH is arm.
> 

It would probably make sense to implement
	pci=off
for any $arch.

Any problem with that, linux-pci??


> 
> On Wed, Apr 13, 2011 at 3:10 PM, Randy Dunlap <rdunlap@xenotime.net> wrote:
> > On Wed, 13 Apr 2011 15:05:59 -0500 Xianghua Xiao wrote:
> >
> >> Is it possible to do something like 'pci=off' to have the same effect
> >> as turning of CONFIG_PCI during menuconfig?
> >> I want to build one image for both PCIE RC and PCIE EP(endpoint), for
> >> EP I do not need PCI to be enabled at all.
> >>
> >> looking at drivers/pci/pci.c I don't see such option exists, am I
> >> missing something?
> >
> > Hm. Documentation/kernel-parameters.txt says:
> >
> >
> >        pci=option[,option...]  [PCI] various PCI subsystem options:
> >                earlydump       [X86] dump PCI config space before the kernel
> >                                changes anything
> >                off             [X86] don't probe for the PCI bus
> >
> > What $ARCH are you using?
> >
> > See arch/x86/pci/common.c::pcibios_setup() for code that handles
> >        pci=off
> >
> > ---

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
