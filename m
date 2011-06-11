Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754286Ab1FKK3y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jun 2011 06:29:54 -0400
Received: from am1ehsobe002.messaging.microsoft.com ([213.199.154.205]:27611
	"EHLO AM1EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751258Ab1FKK3x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jun 2011 06:29:53 -0400
X-SpamScore: -18
X-BigFish: VPS-18(zz1432N98dKzz1202hzz15d4Rz32i668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LMMFSW-02-BNJ-02
X-M-MSG: 
Date: Sat, 11 Jun 2011 12:29:47 +0200
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Chris Wright <chrisw@sous-sol.org>
CC: "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 8/9] x86/amd-iommu: Search for existind dev_data before
 allocting a new one
Message-ID: <20110611102947.GC29908@amd.com>
References: <1307707729-29767-1-git-send-email-joerg.roedel@amd.com>
 <1307707729-29767-9-git-send-email-joerg.roedel@amd.com>
 <20110610205226.GN23047@sequoia.sous-sol.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20110610205226.GN23047@sequoia.sous-sol.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 10, 2011 at 04:52:26PM -0400, Chris Wright wrote:
> * Joerg Roedel (joerg.roedel@amd.com) wrote:
> > +static struct iommu_dev_data *search_dev_data(u16 devid)
> > +{
> > +     struct iommu_dev_data *dev_data;
> > +     unsigned long flags;
> > +
> > +	spin_lock_irqsave(&dev_data_list_lock, flags);
> > +	list_for_each_entry(dev_data, &dev_data_list, dev_data_list) {
> > +		if (dev_data->devid == devid)

Right, multiple segments are not handled at all by the driver. The ACPI
tables support them in theory, but there are no systems to test those
things on.

	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

