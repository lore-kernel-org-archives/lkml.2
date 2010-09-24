Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753274Ab0IXRVv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 13:21:51 -0400
Received: from cpoproxy1-pub.bluehost.com ([69.89.21.11]:39035 "HELO
	cpoproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752165Ab0IXRVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 13:21:49 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=BEEpxwdgTJTvqMq9JWzmiIS11s4iQm1SgN0b7C4JFv5BJy+pgkb66QwvO7k3vwTmlhLg3Ifl1PCiCH8H8iJDvoXD6FjksKthP50fNuoaFXC2Nj6zLoXVo2ksH0WQY7FY;
Date: Fri, 24 Sep 2010 10:21:46 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Jean Delvare <khali@linux-fr.org>
Cc: Seth Heasley <seth.heasley@intel.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH 2.6.35.4] irq: irq and pci_ids patch for Intel Patsburg
 DeviceIDs
Message-ID: <20100924102146.445943b8@jbarnes-desktop>
In-Reply-To: <20100911105706.75c74a26@hyperion.delvare>
References: <201003251611.37706.seth.heasley@intel.com>
	<201009101636.39962.seth.heasley@intel.com>
	<20100911105706.75c74a26@hyperion.delvare>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.174.193.198 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 11 Sep 2010 10:57:06 +0200
Jean Delvare <khali@linux-fr.org> wrote:

> Hi Seth,
> 
> On Fri, 10 Sep 2010 16:36:39 -0700, Seth Heasley wrote:
> > This patch adds the LPC Controller DeviceIDs for the Intel Patsburg PCH.
> > 
> > Signed-off-by: Seth Heasley <seth.heasley@intel.com>
> > 
> > --- linux-2.6.35.4/include/linux/pci_ids.h.orig	2010-08-26 16:47:12.000000000 -0700
> > +++ linux-2.6.35.4/include/linux/pci_ids.h	2010-09-10 16:34:06.000000000 -0700
> > @@ -2423,6 +2423,7 @@
> >  #define PCI_DEVICE_ID_INTEL_CPT_SMBUS	0x1c22
> >  #define PCI_DEVICE_ID_INTEL_CPT_LPC_MIN	0x1c41
> >  #define PCI_DEVICE_ID_INTEL_CPT_LPC_MAX	0x1c5f
> > +#define PCI_DEVICE_ID_INTEL_PBG_LPC	0x1d40
> >  #define PCI_DEVICE_ID_INTEL_82801AA_0	0x2410
> >  #define PCI_DEVICE_ID_INTEL_82801AA_1	0x2411
> >  #define PCI_DEVICE_ID_INTEL_82801AA_3	0x2413
> > --- linux-2.6.35.4/arch/x86/pci/irq.c.orig	2010-08-26 16:47:12.000000000 -0700
> > +++ linux-2.6.35.4//arch/x86/pci/irq.c	2010-09-10 16:30:39.000000000 -0700
> > @@ -589,6 +589,7 @@
> >  	case PCI_DEVICE_ID_INTEL_ICH10_1:
> >  	case PCI_DEVICE_ID_INTEL_ICH10_2:
> >  	case PCI_DEVICE_ID_INTEL_ICH10_3:
> > +	case PCI_DEVICE_ID_INTEL_PBG_LPC:
> >  		r->name = "PIIX/ICH";
> >  		r->get = pirq_piix_get;
> >  		r->set = pirq_piix_set;
> 
> Could Intel please stop using abbreviations for their chip names? If
> the chip is named Patsburg then please use PATSBURG in the symbol names
> too. MRST, PGB, etc. make me sick.

Agreed.  Do you want to submit a rename patch for the existing stuff?
You can do it on top of this one if you like, I'll put it into
linux-next.

I guess this means more typing for you in future patches, Seth. :)

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
