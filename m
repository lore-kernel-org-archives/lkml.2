Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753767Ab2E1NVT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 09:21:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28657 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752105Ab2E1NVS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 09:21:18 -0400
Date: Mon, 28 May 2012 16:21:10 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Jan Kiszka <jan.kiszka@web.de>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Alexey Kardashevskiy <aik@ozlabs.ru>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Alexander Graf <agraf@suse.de>, kvm <kvm@vger.kernel.org>
Subject: Re: [PATCH] PCI: Mark INTx masking support of Chelsio T310 10GbE NIC
 as broken
Message-ID: <20120528132109.GB22623@redhat.com>
References: <4FBF90E5.8030800@siemens.com>
 <20120528123934.GB21778@redhat.com>
 <4FC374CD.5000509@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FC374CD.5000509@web.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 28, 2012 at 02:51:25PM +0200, Jan Kiszka wrote:
> On 2012-05-28 14:39, Michael S. Tsirkin wrote:
> > On Fri, May 25, 2012 at 11:02:13AM -0300, Jan Kiszka wrote:
> >> According to Alexey, the T310 does not properly support INTx masking as
> >> it fails to keep the PCI_STATUS_INTERRUPT bit updated once the interrupt
> >> is masked. Mark this adapter as broken so that pci_intx_mask_supported
> >> won't report it as compatible.
> >>
> >> Reported-by: Alexey Kardashevskiy <aik@ozlabs.ru>
> >> Signed-off-by: Jan Kiszka <jan.kiszka@web.de>
> > 
> > 
> > Just a thought: would be nice to have a way to discover
> > the quirk was activated. Add an attribute so that
> > userspace can detect and report this properly to users?
> > Or just log a warning message ...
> 
> pr_notice_once?

OK IMO.

> A flag for userspace would be significantly more
> complicated (and not PCI layer hands).

Why not? I meant e.g. an attribute in pci-sysfs.

> Jan
> 
