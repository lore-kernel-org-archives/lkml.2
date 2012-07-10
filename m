Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751308Ab2GJS2M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 14:28:12 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:37468 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751058Ab2GJS2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 14:28:10 -0400
Date: Tue, 10 Jul 2012 11:28:04 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Devendra Naga <devendra.aaru@gmail.com>, Lior Dotan <liodot@gmail.com>,
        Christopher Harrer <charrer@alacritech.com>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCH 2/3] staging/slicoss: disable pci device at remove
Message-ID: <20120710182804.GA24666@kroah.com>
References: <1341855260-9037-1-git-send-email-devendra.aaru@gmail.com>
 <1341855260-9037-2-git-send-email-devendra.aaru@gmail.com>
 <20120709200604.GA2536@kroah.com>
 <877guc4ryk.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <877guc4ryk.fsf@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 09, 2012 at 01:09:23PM -0700, Eric W. Biederman wrote:
> Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:
> 
> > On Mon, Jul 09, 2012 at 11:04:19PM +0530, Devendra Naga wrote:
> >> at probe we enabled the device, and we should disable it at remove.
> >> 
> >> Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
> >> ---
> >>  drivers/staging/slicoss/slicoss.c |    1 +
> >>  1 file changed, 1 insertion(+)
> >> 
> >> diff --git a/drivers/staging/slicoss/slicoss.c b/drivers/staging/slicoss/slicoss.c
> >> index a511a2b..5bd3825 100644
> >> --- a/drivers/staging/slicoss/slicoss.c
> >> +++ b/drivers/staging/slicoss/slicoss.c
> >> @@ -3234,6 +3234,7 @@ static void __devexit slic_entry_remove(struct pci_dev *pcidev)
> >>  	}
> >>  	free_netdev(dev);
> >>  	pci_release_regions(pcidev);
> >> +	pci_disable_device(pcidev);
> >
> > No, you really shouldn't do this, see the many times this has come up on
> > the linux-kernel mailing list for why.
> 
> I haven't see this?  Why don't you want to disable a device at remove
> time?  Because we put the disable in the generic pci layer?

For some reason, I thought we didn't do this because of other
"interfaces" on the same card might then be shut down.  But I must have
been thinking of something else, as lots of drivers do this, so adding
it here looks to be correct.

So, sorry Devendra, you were right, care to resend this so I can apply
it?

thanks,

greg k-h
