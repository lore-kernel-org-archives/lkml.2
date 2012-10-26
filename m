Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934323Ab2JZXzu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 19:55:50 -0400
Received: from mail.kernel.org ([198.145.19.201]:47587 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934214Ab2JZXzt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 19:55:49 -0400
Date: Fri, 26 Oct 2012 16:55:47 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Robert Jennings <rcj@linux.vnet.ibm.com>
Subject: Re: [PATCH] debugfs: add get/set for atomic types
Message-ID: <20121026235547.GA12136@kroah.com>
References: <1351266541-17268-1-git-send-email-sjenning@linux.vnet.ibm.com>
 <20121026161315.GA13134@kroah.com>
 <508ADA8E.9000604@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <508ADA8E.9000604@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 26, 2012 at 01:46:38PM -0500, Seth Jennings wrote:
> On 10/26/2012 11:13 AM, Greg Kroah-Hartman wrote:
> > On Fri, Oct 26, 2012 at 10:49:01AM -0500, Seth Jennings wrote:
> >> debugfs currently lacks the ability to create attributes
> >> that set/get atomic_t values.
> >>
> >> This patch adds support for this through a new
> >> debugfs_create_atomic_t() function.
> > 
> > Why would you want to set an atomic variable type from userspace?
> 
> In my particular use case, I'm not setting from userspace, only getting.

That's good, you wouldn't want to set an atomic from userspace.

> All the other types are symmetric, being both settable and gettable,
> so I was just trying to blend with the other types.

Fair enough.

> > What in-kernel code needs this?
> 
> None, yet.  I am working on code that does.
> 
> If you would rather me send this as part of the patchset for that
> code, I can.  I just wanted to get this in early if I could since it
> is functionality I can see others using.
> 
> For an example, see drivers/staging/ramster/zcache-main.c:132 where
> both atomic and non-atomic version of stats are being maintained so
> that the non-atomic version can be read by debugfs.
> 
> Beside not having an in-kernel user yet, does this approach look good
> to you?

It looks reasonable, but please hold off and submit this as part of a
patch series that needs it.  No need to add it now.

thanks,

greg k-h
