Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756548Ab0DIUJc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 16:09:32 -0400
Received: from sous-sol.org ([216.99.217.87]:45918 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754961Ab0DIUJb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 16:09:31 -0400
Date: Fri, 9 Apr 2010 13:09:08 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Tom Lyon <pugs@lyon-about.com>
Cc: Avi Kivity <avi@redhat.com>, Greg KH <gregkh@suse.de>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, "Hans J. Koch" <hjk@linutronix.de>
Subject: Re: [PATCH 0/1] uio_pci_generic: extensions to allow access
 for?non-privileged processes
Message-ID: <20100409200908.GM3168@sequoia.sous-sol.org>
References: <201003311708.38961.pugs@lyon-about.com>
 <20100402170515.GA32579@suse.de>
 <4BBEFA3B.8070609@redhat.com>
 <201004090934.16891.pugs@lyon-about.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201004090934.16891.pugs@lyon-about.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Tom Lyon (pugs@lyon-about.com) wrote:
> On Friday 09 April 2010 02:58:19 am Avi Kivity wrote:
> > - access to all config space, but BARs must be translated so userspace 
> > cannot attack the host
> Please elaborate. All of PCI config? All of PCIe config? Seems like a huge mess.

All of config space, but not raw access to all bits.  So the MSI/MSI-X
capability writes need to be intermediated.  There's bits in the
header too.  And it's not just PCI, it's extended config space as well,
drivers may care about finding their whizzybang PCIe capability and doing
someting with it (and worse...they are allowed to put device specific
registers there, and worse yet...they do!).

thanks,
-chris
