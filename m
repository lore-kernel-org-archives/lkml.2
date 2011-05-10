Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755471Ab1EJNZS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 09:25:18 -0400
Received: from cantor.suse.de ([195.135.220.2]:33300 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752357Ab1EJNZP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 09:25:15 -0400
Date: Tue, 10 May 2011 06:16:15 -0700
From: Greg KH <gregkh@suse.de>
To: KY Srinivasan <kys@microsoft.com>
Cc: Christoph Hellwig <hch@infradead.org>, Greg KH <greg@kroah.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>
Subject: Re: various vmbus review comments
Message-ID: <20110510131615.GA7113@suse.de>
References: <20110503204641.GA11132@kroah.com>
 <6E21E5352C11B742B20C142EB499E0481DFCFA@TK5EX14MBXC124.redmond.corp.microsoft.com>
 <20110504163228.GA19754@kroah.com>
 <6E21E5352C11B742B20C142EB499E0481E0694@TK5EX14MBXC124.redmond.corp.microsoft.com>
 <20110509143352.GB29635@infradead.org>
 <6E21E5352C11B742B20C142EB499E0481E95C6@TK5EX14MBXC128.redmond.corp.microsoft.com>
 <20110510052425.GA31087@infradead.org>
 <6E21E5352C11B742B20C142EB499E0481EEFF1@TK5EX14MBXC128.redmond.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6E21E5352C11B742B20C142EB499E0481EEFF1@TK5EX14MBXC128.redmond.corp.microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 10, 2011 at 01:00:26PM +0000, KY Srinivasan wrote:
> 
> 
> > -----Original Message-----
> > From: Christoph Hellwig [mailto:hch@infradead.org]
> > Sent: Tuesday, May 10, 2011 1:24 AM
> > To: KY Srinivasan
> > Cc: Christoph Hellwig; Greg KH; gregkh@suse.de; linux-kernel@vger.kernel.org;
> > devel@linuxdriverproject.org; virtualization@lists.osdl.org
> > Subject: Re: various vmbus review comments
> > 
> > On Mon, May 09, 2011 at 02:56:52PM +0000, KY Srinivasan wrote:
> > > I will address this. Greg had a concern about module reference counting
> > > and looking at the current code, it did not appear to be an issue. The
> > > change you are suggesting will not affect the vmbus core which is what I want
> > > to focus on. I will however, fix this issue in the current round of patches I will
> > > send out this week.
> > 
> > It very clearly affects the interface between the core and the
> > functional drivers.  Trying to submit the core without making sure the
> > interface is exports works properly is not an overly good idea.
> 
> I must be missing something here. As I look at the block driver (and
> this is indicative of other drivers as well); the exit routine -
> blkvsc_drv_exit, first iterates through all the devices it manages
> and invokes device_unregister() on each of the devices and then 
> invokes vmbus_child_driver_unregister() which is just a wrapper on
> driver_unregister(). So, if I understand you correctly, you want the devices to
> persist even if there is no driver bound to them.

That's how the Linux driver model should be used, so yes, that is the
correct thing to do.

thanks,

greg k-h
