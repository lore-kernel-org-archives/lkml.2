Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756393Ab1HXDJH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 23:09:07 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:38872 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755959Ab1HXDId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 23:08:33 -0400
X-Sasl-enc: Xsu6Xa5DwD0tB9pg5ZiddrjGr1kIh3JSDVhweuLsck+e 1314155312
Date: Tue, 23 Aug 2011 20:00:25 -0700
From: Greg KH <greg@kroah.com>
To: KY Srinivasan <kys@microsoft.com>
Cc: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: Re: [PATCH 019/117] Staging: hv: vmbus: Cleanup vmbus_uevent() code
Message-ID: <20110824030025.GD30779@kroah.com>
References: <1310752024-27854-1-git-send-email-kys@microsoft.com>
 <1310752065-27895-1-git-send-email-kys@microsoft.com>
 <1310752065-27895-19-git-send-email-kys@microsoft.com>
 <20110823224932.GF9641@kroah.com>
 <6E21E5352C11B742B20C142EB499E048081B2356@TK5EX14MBXC126.redmond.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6E21E5352C11B742B20C142EB499E048081B2356@TK5EX14MBXC126.redmond.corp.microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 24, 2011 at 12:38:09AM +0000, KY Srinivasan wrote:
> 
> 
> > -----Original Message-----
> > From: Greg KH [mailto:greg@kroah.com]
> > Sent: Tuesday, August 23, 2011 6:50 PM
> > To: KY Srinivasan
> > Cc: gregkh@suse.de; linux-kernel@vger.kernel.org;
> > devel@linuxdriverproject.org; virtualization@lists.osdl.org; Haiyang Zhang
> > Subject: Re: [PATCH 019/117] Staging: hv: vmbus: Cleanup vmbus_uevent() code
> > 
> > On Fri, Jul 15, 2011 at 10:46:07AM -0700, K. Y. Srinivasan wrote:
> > > Now generate appropriate uevent based on the modalias string. As part of this,
> > > cleanup the existing uevent code.
> > 
> > Note, you just change the user api here, did you have tools that relied
> > on the old format?  If so, they just broke :(
> 
> Prior to this, I don't think autoloading worked the way it should for these
> modules. 

It didn't?  How did the mouse driver get autoloaded then, through the
pci/dmi tables?

> > > +	for (i = 0; i < (sizeof(struct hv_vmbus_device_id) * 2); i += 2)
> > > +		sprintf(&alias_name[i], "%02x", dev->dev_type.b[i/2]);
> > 
> > Don't we have a type for printing out a uuid already?
> 
> I did not see one; could you point me to the right place.
> > 
> > And what's with the jumping by 2 yet dividing?  What am I missing here?
> 
> Each byte of the uuid is represented by 2 bytes in the string; thus the magic with 2.

Ok, wierd, but it makes sense, thanks.

greg k-h
