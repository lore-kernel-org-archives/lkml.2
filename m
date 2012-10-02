Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753716Ab2JBNG7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 09:06:59 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:18702 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753174Ab2JBNG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 09:06:57 -0400
Date: Tue, 2 Oct 2012 08:55:20 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Jan Beulich <JBeulich@suse.com>
Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>
Subject: Re: linux-next: manual merge of the xen-two tree with Linus' tree
Message-ID: <20121002125519.GB9009@phenom.dumpdata.com>
References: <20121002141949.f6e61437bdce0d56d9d4321e@canb.auug.org.au>
 <alpine.DEB.2.02.1210021141370.29232@kaball.uk.xensource.com>
 <506AEE0C020000780009F0A1@nat28.tlf.novell.com>
 <alpine.DEB.2.02.1210021240020.29232@kaball.uk.xensource.com>
 <506AF20C020000780009F0B5@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <506AF20C020000780009F0B5@nat28.tlf.novell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 02, 2012 at 12:54:20PM +0100, Jan Beulich wrote:
> >>> On 02.10.12 at 13:45, Stefano Stabellini <stefano.stabellini@eu.citrix.com> wrote:
> >> > Considering that dbgp doesn't seem to be very useful without PCI at the
> >> > moment, could we just turn it into:
> >> > 
> >> > dom0-$(CONFIG_PCI) += dbgp.o
> >> > 
> >> > ?
> >> 
> >> Better not - the code is specifically not PCI-only. And I can't see
> >> how it would be harmful to be compiled on e.g. ARM (so the
> >> merge perhaps really should use XEN_DOM0 alone, without
> >> X86. If anything (and that may indeed be a minor oversight of
> >> the original patch) one might want it to depend on USB_SUPPORT,
> >> as without that no in-tree debug port capable driver would be
> >> able to load (and hence interfere with Xen's use of the debug
> >> port). However, as long as it builds fine with USB_SUPPORT
> >> undefined (which I believe it does), having it in the shape it
> >> is allows for out-of-tree drivers as well (as long as they make
> >> use of the designated interface).
> > 
> > OK for PCI.
> > Regarding USB_SUPPORT, considering that gbgp.c calls hcd_to_bus, I think
> > it would make sense to make it depend on it.
> 
> As said - I'd prefer to do that only if indeed needed to get things
> to build without that option. Since include/usb/* doesn't reference
> CONFIG_USB_SUPPORT, I'm in favor of supporting at least those
> eventual out-of-tree drivers that do use the pre-existing data
> structures (and others shouldn't be calling pre-existing APIs
> anyway). But I wouldn't NAK a patch doing what you suggest
> either.

Could it depend on EARLY_PRINTK_DBGP ?

> 
> Jan
