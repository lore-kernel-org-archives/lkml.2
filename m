Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751542Ab1GFQHv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 12:07:51 -0400
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:57286 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750958Ab1GFQHt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 12:07:49 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=jVrm7XIpPjI9vEFMaYZgE9GNJIUlTu/g4F1H8wEkKATjFvuGyKksEmr1G/tnEhjpVYVt/e0OUY9/82Hq8rWcvvgDnFAlLvB9Qlwp+Ufx+NSmrnLJpCdvTEk/BUrQzk9L;
Date: Wed, 6 Jul 2011 09:07:33 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Ram Pai <linuxram@us.ibm.com>
Cc: torvalds@linux-foundation.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, yinghai@kernel.org
Subject: Re: [PATCH] PCI: conditional resource-reallocation through kernel
 parameter pci=realloc
Message-ID: <20110706090733.1158d959@jbarnes-desktop>
In-Reply-To: <20110706090638.GA29266@ram-ThinkPad-T61>
References: <1309421379-24995-1-git-send-email-linuxram@us.ibm.com>
	<20110706090638.GA29266@ram-ThinkPad-T61>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Jul 2011 02:06:38 -0700
Ram Pai <linuxram@us.ibm.com> wrote:

> On Thu, Jun 30, 2011 at 01:09:39AM -0700, Ram Pai wrote:
> > Multiple attempts to dynamically reallocate pci resources have unfortunately
> > lead to regressions. Though we continue to fix the regressions and fine tune the
> > dynamic-reallocation behavior, we have not reached a acceptable state yet.
> > 
> > This patch provides a interim solution. It disables dynamic-reallocation; by
> > default, with the ability to enable it through pci=realloc kernel command line
> > parameter.
> 
> > 
> > Signed-off-by: Ram Pai <linuxram@us.ibm.com>
> > ---
> >  Documentation/kernel-parameters.txt |    2 ++
> >  arch/x86/pci/common.c               |    4 ++++
> >  drivers/pci/setup-bus.c             |    7 +++++++
> >  include/linux/pci.h                 |    2 ++
> >  4 files changed, 15 insertions(+), 0 deletions(-)
> > 
> > diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> > index fd248a3..aa47be7 100644
> > --- a/Documentation/kernel-parameters.txt
> > +++ b/Documentation/kernel-parameters.txt
> > @@ -2015,6 +2015,8 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
> >  				the default.
> >  				off: Turn ECRC off
> >  				on: Turn ECRC on.
> > +		realloc		reallocate PCI resources if allocations done by BIOS
> > +				are erroneous.
> > 
> >  	pcie_aspm=	[PCIE] Forcibly enable or disable PCIe Active State Power
> >  			Management.
> 
> Linus/Jesse,
> 
> 	Are we merging this patch in 3.0.0 ?

Yeah I think we probably should, since the alternative is still pretty
large.

I'll queue it up with any other small patches that are needed at this
point and send them over to Linus.

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
