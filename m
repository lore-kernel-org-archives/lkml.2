Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758577Ab1BRWJM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 17:09:12 -0500
Received: from cantor.suse.de ([195.135.220.2]:58571 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754324Ab1BRWJL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 17:09:11 -0500
Date: Fri, 18 Feb 2011 14:07:24 -0800
From: Greg KH <gregkh@suse.de>
To: KY Srinivasan <kys@microsoft.com>
Cc: Greg KH <greg@kroah.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>
Subject: Re: [PATCH]: Staging: hv: Allocate the vmbus irq dynamically
Message-ID: <20110218220724.GA28986@suse.de>
References: <1297799735-25917-1-git-send-email-kys@microsoft.com>
 <20110218211423.GH796@kroah.com>
 <6E21E5352C11B742B20C142EB499E048011604@TK5EX14MBXC124.redmond.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6E21E5352C11B742B20C142EB499E048011604@TK5EX14MBXC124.redmond.corp.microsoft.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 18, 2011 at 10:00:04PM +0000, KY Srinivasan wrote:
> 
> 
> > -----Original Message-----
> > From: Greg KH [mailto:greg@kroah.com]
> > Sent: Friday, February 18, 2011 4:14 PM
> > To: KY Srinivasan
> > Cc: gregkh@suse.de; linux-kernel@vger.kernel.org;
> > devel@linuxdriverproject.org; virtualization@lists.osdl.org
> > Subject: Re: [PATCH]: Staging: hv: Allocate the vmbus irq dynamically
> > 
> > On Tue, Feb 15, 2011 at 11:55:35AM -0800, K. Y. Srinivasan wrote:
> > >
> > > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> > > Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> > > Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
> > 
> > You didn't run this through checkpatch.pl.
> > 
> > Please do so and fix the warning it gives you.
> Greg, I did run the checkpatch script against this patch and the only
> complaint I got was with regards to the IRQF_SAMPLE_RANDOM flag that I
> pass. As a virtual machine, this is the only external event that the
> VM is going to see and so I chose to keep this flag.  Is there
> something that would replace this flag; looking at the Xen drivers
> they do pass this flag.

But that flag is going away, right?  And this really can't be a valid
source of entropy as the HV channel is pretty predictable.

If you are only using this because Xen does/did it, that's not a valid
excuse :)

thanks,

greg k-h
