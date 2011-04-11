Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752493Ab1DKRFp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 13:05:45 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:42337 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751673Ab1DKRFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 13:05:44 -0400
Date: Mon, 11 Apr 2011 13:05:41 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Roedel, Joerg" <Joerg.Roedel@amd.com>
cc: Borislav Petkov <bp@alien8.de>, Greg Kroah-Hartman <gregkh@suse.de>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        "Xu, Andiry" <Andiry.Xu@amd.com>, USB list <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5] USB host: Fix lockdep warning in AMD PLL quirk
In-Reply-To: <20110411163711.GA20607@amd.com>
Message-ID: <Pine.LNX.4.44L0.1104111304080.1975-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Apr 2011, Roedel, Joerg wrote:

> > > > > +		ret = amd_chipset.probe_result;
> > > > > +
> > > > > +		spin_unlock_irqrestore(&amd_lock, flags);
> > > > > +
> > > > > +		if (info.nb_dev)
> > > > > +			pci_dev_put(info.nb_dev);
> > > > > +		if (info.smbus_dev)
> > > > > +			pci_dev_put(info.smbus_dev);
> > > > > +
> > > > > +	} else {
> > > > > +		/* no race - commit the result */
> > > > > +		info.probe_count++;
> > > > 
> > > > This isn't right, because info.probe_count was initialized to 0.  Maybe 
> > > > amd_chipset.probe_count should be made into a separate variable, not a 
> > > > part of the structure, like amd_lock.
> > > 
> > > The purpose of the struct is structuring of data. In theory all of its
> > > members could be turned into global variables. The amd_lock is different
> > > because it does not only protect the struct but also access to the
> > > hardware while the quirk is applied/unapplied.
> > 
> > Do it however you prefer.  But as it stands now, the patch is wrong.
> 
> Hmm, I see how it can be done differently, but no real bug.

Never mind, you're right.  In the no-race case, the initial count is 
always going to be 0, and so incrementing info.probe_count is the right 
thing to do.

Alan Stern

