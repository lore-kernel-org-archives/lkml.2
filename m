Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754100Ab1BQOaA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 09:30:00 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:36412 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751745Ab1BQO36 (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Thu, 17 Feb 2011 09:29:58 -0500
Date: Thu, 17 Feb 2011 09:28:07 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Ian Campbell <Ian.Campbell@citrix.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
Subject: Re: [Xen-devel] [PATCH] Xen PCI fronted fixes for 2.6.39
Message-ID: <20110217142807.GD5987@dumpdata.com>
References: <1297894638-28007-1-git-send-email-konrad.wilk@oracle.com>
 <1297931344.16356.1268.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1297931344.16356.1268.camel@zakaz.uk.xensource.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4D5D30DB.01A5:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 17, 2011 at 08:29:04AM +0000, Ian Campbell wrote:
> On Wed, 2011-02-16 at 22:17 +0000, Konrad Rzeszutek Wilk wrote:
> > I am proposing these three patches for 2.6.39.
> > 
> > The first is to take advantage of the new method of requesting
> > a Linux IRQ and providing the Xen PIRQ value. The second
> > makes it possible for a PV guest to bootup if the backend has provided
> > incorrect values. [*2]
> 
> I approve of being liberal in what is accepted but do we also have a
> handle on why the backend is providing incorrect values in the first
> place?

I got those fixed too - was using 'xen_irq_from_gsi' while
it should have used 'xen_irq_from_pirq'. This was the new mechanism
to obtain the vector values after .. 2.6.38-rc1 ish.. (as the
GSI values now have the correct value of zero, and the vector value
for MSI/MSI-X is written in the PIRQ entry).

But those patches are in a different branch (devel/xen-pciback-0.3).
