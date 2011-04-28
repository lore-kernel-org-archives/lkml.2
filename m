Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932562Ab1D1Nkd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 09:40:33 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43086 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759516Ab1D1Nkc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 09:40:32 -0400
Date: Thu, 28 Apr 2011 06:40:36 -0700
From: Greg KH <gregkh@suse.de>
To: "Weil, Oren jer" <oren.jer.weil@intel.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alan@linux.intel.com" <alan@linux.intel.com>,
        "david@woodhou.se" <david@woodhou.se>
Subject: Re: [PATCH 6/8] staging/mei: Header file contain the Userland API,
 (IOCTL and its struct)
Message-ID: <20110428134036.GC4861@suse.de>
References: <1303900057-21694-1-git-send-email-oren.jer.weil@intel.com>
 <1303900057-21694-7-git-send-email-oren.jer.weil@intel.com>
 <20110427081541.80cc591a.randy.dunlap@oracle.com>
 <20110427153335.GA25973@suse.de>
 <F28B59AD52D84B479DCA469824475335065AF92F69@hasmsx503.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <F28B59AD52D84B479DCA469824475335065AF92F69@hasmsx503.ger.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 28, 2011 at 09:29:05AM +0300, Weil, Oren jer wrote:
> 
> >From: Greg KH [mailto:gregkh@suse.de]
> >On Wed, Apr 27, 2011 at 08:15:41AM -0700, Randy Dunlap wrote:
> >> Please update Documentation/ioctl/ioctl-number.txt.
> >
> >Not yet, this code might get that ioctl removed before it gets merged into 
> >the
> >main part of the kernel.
> >
> >Or at least I can hope :)
> 
> We discuss this IOCTL issue with Alan C. and David W. and I didn't see any 
> other solution for this.

Was this discussed in public?

> if someone has a good solution for that we are happy to hear it.

Did you rule out sysfs, configfs, netlink, etc.?

> the reason that we use IOCTL is that we need to "associate" (Connect)
> the current file description to a FW Client/Feature.  (opening a comm
> channel) .

As you didn't document this ioctl interface anywhere, saying exactly
what you are trying to do, it makes it a bit hard to review your
existing interface to determine that ioctls are the correct thing for
your device.

Care to document it, or at least describe it in the patches somewhere so
we know it and can properly review it?

> and in addition there is a security issue that we would like limit the access 
> to mei driver to system admins.
> 
> From what I read we can't get those requirements with Netlinks, right?
> If there other methods for achieving this ?

sysfs, configfs, your own filesystem, etc.  There are lots of options.

thanks,

greg k-h
