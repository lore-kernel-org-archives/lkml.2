Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759249Ab1D2P14 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 11:27:56 -0400
Received: from cantor.suse.de ([195.135.220.2]:48287 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759147Ab1D2P1n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 11:27:43 -0400
Date: Fri, 29 Apr 2011 08:10:52 -0700
From: Greg KH <gregkh@suse.de>
To: KY Srinivasan <kys@microsoft.com>
Cc: Greg KH <greg@kroah.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "Abhishek Kane (Mindtree Consulting PVT LTD)" 
	<v-abkane@microsoft.com>
Subject: Re: [PATCH 08/25] Staging: hv: vmbus_driver cannot be unloaded;
 cleanup accordingly
Message-ID: <20110429151052.GC12142@suse.de>
References: <1303834785-4981-1-git-send-email-kys@microsoft.com>
 <1303834842-5022-1-git-send-email-kys@microsoft.com>
 <1303834842-5022-8-git-send-email-kys@microsoft.com>
 <20110426224545.GC31974@kroah.com>
 <6E21E5352C11B742B20C142EB499E0481DD1C9@TK5EX14MBXC124.redmond.corp.microsoft.com>
 <20110428002018.GC14294@kroah.com>
 <6E21E5352C11B742B20C142EB499E0481DD55F@TK5EX14MBXC124.redmond.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6E21E5352C11B742B20C142EB499E0481DD55F@TK5EX14MBXC124.redmond.corp.microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 29, 2011 at 01:49:21PM +0000, KY Srinivasan wrote:
> > > 2) Windows host would not permit reloading the driver without
> > > rebooting the guest.
> > 
> > That's a different issue, and one that I am very surprised to hear.
> > That kind of invalidates ever being able to update the driver in a guest
> > for a long-running system that you want to migrate and not reboot.  That
> > sounds like a major bug in hyper-v, don't you agree?
> 
> In practical terms, I am not sure this is a major problem. If the root device
> Is managed by a Hyper-V driver, then you cannot unload that driver and 
> drivers it depends on anyway.

I don't run my hyper-v guests using the hyper-v driver for my root
devices, so in my setup, it is possible to unload the whole vmbus
subsystem and drivers and reload it without any system interruption.

Now I have never tried that... :)

> Greg, I am open to either approach here: 1) I could drop this patch and restore the 
> exit function. 2) I could keep the patch as is, but add additional comments to
> capture this discussion. Let me know what you prefer and I will send the remaining 
> patch-set with the agreed upon changes.

As you all are happy with not having this be unloaded, I'll go with 2)
as it is your code to maintain and support, not mine.

Just resend it with some more comments as I explained, and the rest, and
I'll queue them up when I get caught up on my patch queue (I only have
381 to get through, the end is near!)

thanks,

greg k-h
