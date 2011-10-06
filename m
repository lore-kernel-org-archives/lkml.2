Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935865Ab1JFQRu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 12:17:50 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:37264 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751009Ab1JFQRt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 12:17:49 -0400
X-IronPort-AV: E=Sophos;i="4.68,496,1312156800"; 
   d="scan'208";a="8255994"
Date: Thu, 6 Oct 2011 17:17:42 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Ajaykumar Hotchandani <ajaykumar.hotchandani@oracle.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] PCI: Set device power state to PCI_D0 for device without
 native PM support
In-Reply-To: <CAE9FiQVyT=n18JnuBmda86D77Ai4HAC=w68Oo-Na3mCdAxsCMw@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1110061711290.3519@kaball-desktop>
References: <4E8C40A8.6080205@oracle.com> <alpine.DEB.2.00.1110061137120.3519@kaball-desktop> <CAE9FiQVyT=n18JnuBmda86D77Ai4HAC=w68Oo-Na3mCdAxsCMw@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Oct 2011, Yinghai Lu wrote:
> On Thu, Oct 6, 2011 at 3:39 AM, Stefano Stabellini
> <stefano.stabellini@eu.citrix.com> wrote:
> >
> > I had the same issue and sent a patch a while ago to fix it, adding
> >
> > current_state = PCI_D0 in acpiphp_glue.c:register_slot
> >
> > it is strange that this does not work for you:
> >
> > http://marc.info/?l=linux-kernel&m=129891002722845&w=2
> 
> So guest os has to load acpiphp instead of pciehp?
 
maybe pciehp needs to make sure that current_state = D0 in
pciehp_enable_slot, like acpiphp does
