Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030536Ab2CBUS0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 15:18:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41496 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754787Ab2CBUSZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 15:18:25 -0500
Subject: Re: [PATCH] x86/PCI: add spinlock held check to
 'pcibios_fwaddrmap_lookup()'
From: Myron Stowe <mstowe@redhat.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Myron Stowe <myron.stowe@redhat.com>, jbarnes@virtuousgeek.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20120302200027.GA4817@kroah.com>
References: <20120302194501.26152.22845.stgit@amt.stowe>
	 <20120302200027.GA4817@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 02 Mar 2012 13:18:20 -0700
Message-ID: <1330719500.2378.20.camel@zim.stowe>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-03-02 at 12:00 -0800, Greg KH wrote:
> On Fri, Mar 02, 2012 at 12:45:01PM -0700, Myron Stowe wrote:
> > 'pcibios_fwaddrmap_lookup()' is used to maintain FW-assigned BIOS BAR
> > values for reinstatement when normal resource assignment attempts
> > fail and must be called with the 'pcibios_fwaddrmap_lock' spinlock
> > held.
> > 
> > This patch adds a WARN_ON notification if the spinlock is not currently
> > held by the caller.
> > 
> > Signed-off-by: Myron Stowe <myron.stowe@redhat.com>
> > ---
> > 
> >  arch/x86/pci/i386.c |    2 ++
> >  1 files changed, 2 insertions(+), 0 deletions(-)
> > 
> > diff --git a/arch/x86/pci/i386.c b/arch/x86/pci/i386.c
> > index 33e6a0b..831971e 100644
> > --- a/arch/x86/pci/i386.c
> > +++ b/arch/x86/pci/i386.c
> > @@ -57,6 +57,8 @@ static struct pcibios_fwaddrmap *pcibios_fwaddrmap_lookup(struct pci_dev *dev)
> >  {
> >  	struct pcibios_fwaddrmap *map;
> >  
> > +	WARN_ON(!spin_is_locked(&pcibios_fwaddrmap_lock));
> > +
> 
> What is this going to help with?  How can someone then recover from this
> issue?  Just adding a warning message isn't going to fix any problems
> here, why not fix the root cause?

Greg:

We have not seen any issues.  Jesse just asked me to consider adding
such as a sanity check (I believe he said something to the effect: "I
had to read the code a couple of times to assure myself that the lock
was held" - but I should let Jesse comment himself).

Myron
> 
> thanks,
> 
> greg k-h


