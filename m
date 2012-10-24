Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757853Ab2JXGl6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 02:41:58 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:24296 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757799Ab2JXGl5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 02:41:57 -0400
Date: Wed, 24 Oct 2012 09:41:36 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: KY Srinivasan <kys@microsoft.com>
Cc: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>
Subject: Re: 3.7 RC1
Message-ID: <20121024064135.GF20754@mwanda>
References: <1350949065-24655-1-git-send-email-kys@microsoft.com>
 <20121023054716.GA20120@mwanda>
 <426367E2313C2449837CD2DE46E7EAF930A45A90@SN2PRD0310MB382.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <426367E2313C2449837CD2DE46E7EAF930A45A90@SN2PRD0310MB382.namprd03.prod.outlook.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2012 at 02:24:58PM +0000, KY Srinivasan wrote:
> 
> 
> > -----Original Message-----
> > From: Dan Carpenter [mailto:dan.carpenter@oracle.com]
> > Sent: Tuesday, October 23, 2012 1:47 AM
> > To: KY Srinivasan
> > Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> > devel@linuxdriverproject.org; olaf@aepfle.de; apw@canonical.com;
> > jasowang@redhat.com
> > Subject: Re: 3.7 RC1
> > 
> > On Mon, Oct 22, 2012 at 04:37:45PM -0700, K. Y. Srinivasan wrote:
> > >
> > > While testing 3.7 RC1 I discovered that invoking the function
> > orderly_poweroff()
> > > from an interrupt context will trigger an ASSERT(). This was not the case till
> > > recently. The comment preceding the orderly_poweroff() function claims that
> > this
> > > function can be invoked from any context and in the current Hyper-V util driver,
> > > we support host-driven orderly shut down of the guest by invoking this
> > > orderly_poweroff() function in the context of the message callback. This code
> > has
> > > been working for a very long time and it is broken now. Is my assumption that
> > > orderly_poweroff() could be invoked from the interrupt context a wrong
> > assumption?
> > 
> > You can't call orderly_poweroff() from interrupt context.
> 
> Thanks Dan; I am curious  to understand the basis for your assertion.
> As I noted earlier  the documentation for this function clearly says it can
> be called from any context. Furthermore, __orderly_poweroff(), the helper
> function allocates memory with the GFP_ATOMIC flag set. Lastly, the behavior
> of orderly_poweroff() has been such that this function could be called from interrupt context
> for a very long time and something has changed now. For what it is worth, there are other users in
> the kernel (in 3.7 RC1) that are invoking the orderly_poweroff() function from interrupt
> context other than the Hyper-V shutdown handler:  fsl_hv_shutdown_isr() in drivers/virt/fsl_hypervisor.c.
> I suspect there are other users as well that have made this similar assumption.
> 

Aw crap.  I was wrong.  Sorry about that.

regards,
dan carpenter

