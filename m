Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753226Ab2FRUYM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 16:24:12 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:48792 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751700Ab2FRUYK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 16:24:10 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH]: In kernel hibernation, suspend to both
Date: Mon, 18 Jun 2012 22:29:31 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0-rc3+; KDE/4.6.0; x86_64; ; )
Cc: Bojan Smojver <bojan@rexursive.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
References: <90304ca8-31ef-4919-bf9d-e0498b0de87b@email.android.com> <1339979586.1666.13.camel@shrek.rexursive.com> <20120618123205.GA5319@x1.osrc.amd.com>
In-Reply-To: <20120618123205.GA5319@x1.osrc.amd.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201206182229.32055.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, June 18, 2012, Borislav Petkov wrote:
> On Mon, Jun 18, 2012 at 10:33:06AM +1000, Bojan Smojver wrote:
> > On Sun, 2012-06-17 at 22:21 +0200, Rafael J. Wysocki wrote:
> > > Yeah, that will do.
> > 
> > Something like this maybe. I didn't really test this, so Borislav,
> > please let me know whether this is something that may works for you.
> 
> Yeah, this could probably work but it changes the progress indicator
> unconditionally.
> 
> I don't know what the general consensus is about the progress indicator
> but if you want to keep the old behavior too, you probably need to carve
> out the printk functionality from save_image() and pass flags to the new
> function which printks different output depending on how it is.
> 
> If we don't want the current output with how many pages it needs to use
> on swap, then we can do the dots.
> 
> Frankly, I don't have a preference.

I'm not sure if the current behavior is worth preserving.  It's a bit hackish
and doesn't work with dmesg buffer, as you have noticed.

So, I think printing a status line every 10% would be fine.

Thanks,
Rafael
