Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752653Ab2GTXMN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 19:12:13 -0400
Received: from mail.linux-iscsi.org ([67.23.28.174]:42251 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751768Ab2GTXML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 19:12:11 -0400
Subject: Re: linux-next: manual merge of the staging tree with the
 target-merge tree
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Greg KH <greg@kroah.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>
In-Reply-To: <20120720184228.GA19243@redhat.com>
References: <20120719145301.b8992aa986b47d7c44651710@canb.auug.org.au>
	 <20120719235523.GA13623@kroah.com>
	 <1342806778.25472.1.camel@haakon2.linux-iscsi.org>
	 <20120720180358.GA9134@kroah.com>  <20120720184228.GA19243@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 20 Jul 2012 16:12:08 -0700
Message-ID: <1342825928.25472.68.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Fri, 2012-07-20 at 21:42 +0300, Michael S. Tsirkin wrote:
> On Fri, Jul 20, 2012 at 11:03:58AM -0700, Greg KH wrote:
> > On Fri, Jul 20, 2012 at 10:52:58AM -0700, Nicholas A. Bellinger wrote:
> > > Hi Greg,
> > > 

<SNIP>

> > > This was a request from MST (CC'ed) in order to have TCM_VHOST show up
> > > under the staging configuration options..
> > 
> > If you really want it to show up there, then send me a patch adding the
> > code to drivers/staging/.  Otherwise it really makes no sense.
> > 
> > > If that's really not what should be done, I'm happy to drop this part
> > > and just use CONFIG_STAGING again.
> > 
> > Why are you wanting to depend on CONFIG_STAGING in the first place?
> > What is wrong with the code that it can't be merged "properly" now?
> > Don't use CONFIG_STAGING as a "crutch" unless you really need it.
> > 
> > thanks,
> > 
> > greg k-h
> 
> It's very similar to how it was with nouveau: we are not sure
> we can commit to the userspace ABI yet.
> 
> Most importantly, it still seems not 100% clear whether this driver will
> have major userspace using it. And if not, it would be very hard to
> support a driver when recent userspace does not use it in the end.
> 
> At the moment arguments on upstream mailing list seem to be
> a bit circular: there's no module in upstream kernel so
> userspace does not want to accept the patches.
> 
> If we put enabling this driver in staging, then it works out in one of
> two ways
> - userspace starts using it then this effectively freezes the ABI and
>   we move it out of staging next release
> - no userspace uses it and we drop it completely or rework ABI
> 
> On the other hand, it is marginally better to not want code in staging
> for two reasons:
> - there are dependencies between this code and other code in
>   drivers/vhost which are easier for me to handle if it's all
>   in one place
> - a bit easier to track history if we do not move code
> 
> What do you think?
> 

After chatting with MST off-list he asked for a RFC-v4 series with one
extra change to vhost.h wrt the vhost-scsi ioctl defs.  He also said he
is OK with taking the first three patches -v4 through vhost.git and
letting staging take tcm_vhost.   Of course we'd need staging to depend
on vhost for that to work <cough> (compile) properly..  ;)

I'd like to re-spin -v4 this evening so that he can review + ACK the
full series before leaving for holiday tomorrow, so please let me know
what you'd prefer to do here.

So that said, do you prefer having tcm_vhost moved into drivers/staging
for -v4, or should we just be using a CONFIG_STAGING tag in
drivers/vhost/ and be done with it..?

Thank you!

--nab

