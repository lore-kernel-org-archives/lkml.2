Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754686Ab1HWAzt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 20:55:49 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:36819 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753119Ab1HWAzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 20:55:46 -0400
X-Sasl-enc: nw6N6muqAIs+gm7t8wYG91LJEBFsVsNXR87jRf72ybgb 1314060945
Date: Mon, 22 Aug 2011 17:48:39 -0700
From: Greg KH <greg@kroah.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Wanlong Gao <wanlong.gao@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [Doc] class_find_device: fix reference to argument
Message-ID: <20110823004839.GA29215@kroah.com>
References: <201108211256.43836.eike@sf-mail.de>
 <loom.20110821T164259-39@post.gmane.org>
 <20110821145355.94fb7923.rdunlap@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110821145355.94fb7923.rdunlap@xenotime.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 21, 2011 at 02:53:55PM -0700, Randy Dunlap wrote:
> On Sun, 21 Aug 2011 14:46:04 +0000 (UTC) Wanlong Gao wrote:
> 
> > Rolf Eike Beer <eike <at> sf-mail.de> writes:
> > 
> > > 
> > > Signed-off-by: Rolf Eike Beer <eike-kernel <at> sf-tec.de>
> > > ---
> > >  drivers/base/class.c |    2 +-
> > >  1 files changed, 1 insertions(+), 1 deletions(-)
> > > 
> > 
> > > - * @fn is allowed to do anything including calling back into class
> > > + * @match is allowed to do anything including calling back into class
> > >   * code.  There's no locking restriction.
> > >   */
> > >  struct device *class_find_device(struct class *class, struct device *start,
> > 
> > NACK, it means the function class_find_device but not the @match.
> 
> Are you sure?  Looks to me like a comment that was copied from
> class_for_each_device() but shouldn't have been copied.
> 
> Anyway, I'll cc: Greg to see if he knows.

I think the above patch is probably correct, as it can reenter if
needed.

thanks,

greg k-h
