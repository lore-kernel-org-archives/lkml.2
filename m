Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756007Ab1HXDIg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 23:08:36 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:55776 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752098Ab1HXDI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 23:08:28 -0400
X-Sasl-enc: GcZXAlSnNL83PyIgygMbKFOCGeF2cDlVTOZpWGNQ1pTt 1314155307
Date: Tue, 23 Aug 2011 19:57:37 -0700
From: Greg KH <greg@kroah.com>
To: KY Srinivasan <kys@microsoft.com>
Cc: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: Re: [PATCH 086/117] Staging: hv: storvsc: Leverage the spinlock to
 manage ref_cnt
Message-ID: <20110824025737.GA30779@kroah.com>
References: <1310752024-27854-1-git-send-email-kys@microsoft.com>
 <1310752065-27895-1-git-send-email-kys@microsoft.com>
 <1310752065-27895-86-git-send-email-kys@microsoft.com>
 <20110823231028.GO9641@kroah.com>
 <6E21E5352C11B742B20C142EB499E048081B239E@TK5EX14MBXC126.redmond.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6E21E5352C11B742B20C142EB499E048081B239E@TK5EX14MBXC126.redmond.corp.microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 24, 2011 at 12:58:36AM +0000, KY Srinivasan wrote:
> 
> 
> > -----Original Message-----
> > From: Greg KH [mailto:greg@kroah.com]
> > Sent: Tuesday, August 23, 2011 7:10 PM
> > To: KY Srinivasan
> > Cc: gregkh@suse.de; linux-kernel@vger.kernel.org;
> > devel@linuxdriverproject.org; virtualization@lists.osdl.org; Haiyang Zhang
> > Subject: Re: [PATCH 086/117] Staging: hv: storvsc: Leverage the spinlock to
> > manage ref_cnt
> > 
> > On Fri, Jul 15, 2011 at 10:47:14AM -0700, K. Y. Srinivasan wrote:
> > > Now that we have a spin lock protecting access to the stor device pointer,
> > > use it manage the reference count as well.
> > >
> > > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> > > Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> > > ---
> > >  drivers/staging/hv/hyperv_storage.h |    8 ++++----
> > >  drivers/staging/hv/storvsc.c        |   10 +++++-----
> > >  2 files changed, 9 insertions(+), 9 deletions(-)
> > >
> > > diff --git a/drivers/staging/hv/hyperv_storage.h
> > b/drivers/staging/hv/hyperv_storage.h
> > > index 53b65be..d946211 100644
> > > --- a/drivers/staging/hv/hyperv_storage.h
> > > +++ b/drivers/staging/hv/hyperv_storage.h
> > > @@ -265,7 +265,7 @@ struct storvsc_device {
> > >  	struct hv_device *device;
> > >
> > >  	/* 0 indicates the device is being destroyed */
> > > -	atomic_t ref_count;
> > > +	int	 ref_count;
> > 
> > Is this really needed?  Can't you rely on the reference count of the
> > hv_device itself?
> 
> We don't have a reference count on the hv_device

Wait, why not?  You shure better have a reference count on that device
if you have a pointer to it, if not, you have a bug, and that needs to
be fixed.  Please reread Documentation/CodingStyle for details.

> and this count is taken to deal with racing unloads and incoming
> traffic on the channel from the host. 

Is this something that all other storage drivers have to do?  If not,
then you shouldn't be doing that as well.

greg k-h
