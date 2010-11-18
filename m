Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932562Ab0KRRT7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 12:19:59 -0500
Received: from cantor.suse.de ([195.135.220.2]:54775 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756877Ab0KRRT6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 12:19:58 -0500
Date: Thu, 18 Nov 2010 09:18:56 -0800
From: Greg KH <gregkh@suse.de>
To: Timur Tabi <timur@freescale.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Scott Wood <scottwood@freescale.com>,
        Stuart Yoder <stuart.yoder@freescale.com>
Subject: Re: How do I choose an arbitrary minor number for my tty device?
Message-ID: <20101118171856.GA4283@suse.de>
References: <20101117221903.GA4066@suse.de>
 <4CE45A4E.70308@freescale.com>
 <20101118022434.GA9833@suse.de>
 <4CE546C5.8060401@freescale.com>
 <20101118153912.GA1443@suse.de>
 <4CE54E40.9040503@freescale.com>
 <20101118163321.GA2723@suse.de>
 <4CE5562B.8080604@freescale.com>
 <20101118165136.GA3103@suse.de>
 <4CE55ACB.80207@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CE55ACB.80207@freescale.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 18, 2010 at 10:56:43AM -0600, Timur Tabi wrote:
> Greg KH wrote:
> > Why?  Again, it doesn't matter, and no other tty driver does it.
> > 
> > Actually you do have control over it, if you really want it, but again,
> > don't do that :)
> 
> Because the only way to know which byte channel tty you want is via the byte
> channel handle.
> 
> Think of the situation where you have two serial ports on the back of your
> computer.  One of them is /dev/ttyS0, and the other is /dev/ttyS1.  But which
> one is which?  The only way to find out is try one and see if it works.

No, you can use the /dev/serial/ links to determine exactly which is
which depending on the pci id, and other unique identifiers (serial
numbers, etc.)

> Now that might be acceptable for serial ports that are fixed physically.  But
> byte channels handles are completely arbitrary and easily change with even the
> slightest re-configuration of the partitions under the hypervisor.  I need to
> have some way to tell userspace that /dev/ttybc0 is byte channel handle 73.

Then again, just use the /dev/serial/ symlinks that are there for you.

> > Sorry, I can't do code review, or accept code that is not allowed to be
> > sent to the public, as, surprise, I'm public :)
> 
> Well, ok.  I didn't want to spam the mailing list with something that only you
> asked for, but here it is:

Is this somehow not public code?  What just changed in the past 15
minutes?

confused,

greg k-h
