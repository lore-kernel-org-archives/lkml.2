Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751572Ab1I0O7u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 10:59:50 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:43897 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751130Ab1I0O7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 10:59:49 -0400
X-Sasl-enc: jad5SYntZ/qZhFGMFRsFLnZohEKPaJ1RYDLc8W0/NnPV 1317135587
Date: Tue, 27 Sep 2011 07:56:05 -0700
From: Greg KH <greg@kroah.com>
To: "Serge E. Hallyn" <serge.hallyn@canonical.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        "Serge E. Hallyn" <serge@hallyn.com>, Oleg Nesterov <oleg@redhat.com>,
        lkml <linux-kernel@vger.kernel.org>, richard@nod.at,
        Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>, Tejun Heo <tj@kernel.org>,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH 2/2] user namespace: usb: make usb urbs user namespace
 aware (v2)
Message-ID: <20110927145605.GB17524@kroah.com>
References: <20110926151829.GA5190@peqn>
 <20110926154518.GA6897@peqn>
 <20110926234540.GA28525@kroah.com>
 <20110927124156.GA3111@sergelap>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110927124156.GA3111@sergelap>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 27, 2011 at 07:41:57AM -0500, Serge E. Hallyn wrote:
> Quoting Greg KH (greg@kroah.com):
> > On Mon, Sep 26, 2011 at 10:45:18AM -0500, Serge Hallyn wrote:
> > > Add to the dev_state and alloc_async structures the user namespace
> > > corresponding to the uid and euid.  Pass these to kill_pid_info_as_uid(),
> > > which can then implement a proper, user-namespace-aware uid check.
> > > 
> > > Changelog:
> > > Sep 20: Per Oleg's suggestion: Instead of caching and passing user namespace,
> > > 	uid, and euid each separately, pass a struct cred.
> > > Sep 26: Address Alan Stern's comments: don't define a struct cred at
> > > 	usbdev_open(), and take and put a cred at async_completed() to
> > > 	ensure it lasts for the duration of kill_pid_info_as_cred().
> > > 
> > > Signed-off-by: Serge Hallyn <serge.hallyn@canonical.com>
> > > Cc: Greg KH <greg@kroah.com>
> > 
> > I have no objection to this, is it going to go through your tree, or
> > somewhere else?
> 
> (Silly question from me, but just to make sure - were you asking this of
> Alan?)

Nope, you.  Do you have a tree for this type of namespace work?  I
haven't been paying attention to it at all.

If not, I'll gladly take it myself, I just don't want to cause any merge
conflicts anywhere else if at all possible.

thanks,

greg k-h
