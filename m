Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759821Ab2FHO3E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 10:29:04 -0400
Received: from fias.uni-frankfurt.de ([141.2.248.1]:37918 "EHLO
	fias.uni-frankfurt.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752725Ab2FHO3C convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 10:29:02 -0400
Message-ID: <1339165738.3870.18.camel@blech>
Subject: Re: [PATCH] uio_pci_generic does not export memory resources
From: Dominic Eschweiler <eschweiler@fias.uni-frankfurt.de>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: "Hans J. Koch" <hjk@hansjkoch.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Fri, 08 Jun 2012 16:28:58 +0200
In-Reply-To: <20120608130351.GB1964@redhat.com>
References: <1339156616.3870.9.camel@blech>
	 <20120608130351.GB1964@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 8BIT
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, den 08.06.2012, 16:03 +0300 schrieb Michael S. Tsirkin:
> Why is this needed?
> What's wrong with mapping resources through
>  /sys/bus/pci/devices/XXXXXresourceX
> ?
> 
Mmmh ok, the problem here is, that the UIO documentation states:

"/dev/uioX is used to access the address space of the card. Just use
mmap() to access registers or RAM locations of your card."

and

"From userspace, the different mappings are distinguished by adjusting
the offset parameter of the mmap() call."


This does not work and the "/sys/class/uio/uioX/maps/mapX/" directories
do also not appear. I was very confused when I tried UIO the first time
and it did not behave like it is described in the documentation.

Anyway, the patch adds the described behaviour and I would more than
happy, if it would be accepted for the mainline kernel. 
> 
> uio currently only supports devices which do not
> do DMA.
> 
> DMA from uio controlled devices is a no no unless
> it's behind an IOMMU which can protect us from
> random memory corruptions this could cause.
> 
> In the later case it's OK but we need some code
> to check this and program the IOMMU appropriately. 

OK, I see. Might it be OK if I just remove the DMA stuff from this patch
and resubmit it?

-- 
Gruß
  Dominic

Frankfurt Institute for Advanced Studies (FIAS)
Ruth-Moufang-Straße 1
D-60438 Frankfurt am Main
Germany

Phone:  +49 69 79844114

