Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751477Ab2GBEOm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 00:14:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3190 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750732Ab2GBEOk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 00:14:40 -0400
Message-ID: <1341202460.1207.384.camel@bling.home>
Subject: Re: Request VFIO inclusion in linux-next
From: Alex Williamson <alex.williamson@redhat.com>
To: Alexey Kardashevskiy <aik@ozlabs.ru>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        linux-pci <linux-pci@vger.kernel.org>,
        iommu <iommu@lists.linux-foundation.org>,
        qemu-devel <qemu-devel@nongnu.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        chrisw <chrisw@sous-sol.org>, "Roedel, Joerg" <Joerg.Roedel@amd.com>,
        linux-next@vger.kernel.org
Date: Sun, 01 Jul 2012 22:14:20 -0600
In-Reply-To: <4FF11855.2060605@ozlabs.ru>
References: <1340686552.1207.128.camel@bling.home>
	 <20120627123733.GA5449@mwanda> <4FF11855.2060605@ozlabs.ru>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-07-02 at 13:41 +1000, Alexey Kardashevskiy wrote:
> On 27/06/12 22:37, Dan Carpenter wrote:
> > On Mon, Jun 25, 2012 at 10:55:52PM -0600, Alex Williamson wrote:
> >> Hi,
> >>
> >> VFIO has been kicking around for well over a year now and has been
> >> posted numerous times for review.  The pre-requirements are finally
> >> available in linux-next (or will be in the 20120626 build) so I'd like
> >> to request a new branch be included in linux-next with a goal of being
> >> accepted into v3.6.
> >>
> > 
> > Could you run Sparse over the driver?
> > http://lwn.net/Articles/205624/
> > 
> > It reports a bunch of endian problems.  Some are definitely bugs
> > like:
> > 	*prev |= cpu_to_le32((u32)epos << 20);
> 
> 
> What is wrong here?

I believe the only thing wrong here was that prev was a u32* instead of
a __le32*.  The new version in my tree has much better endian annotation
after going through all the sparse errors.  The only bug I found in the
cleanup was the handling of rbar.  It was missing the le32_to_cpu as we
copied it out of vconfig.  This is later used with
pci_user_write_config_dword, so it needs to be in native endian.
Thanks,

Alex

