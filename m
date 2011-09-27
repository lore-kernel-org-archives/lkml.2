Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751540Ab1I0PTP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 11:19:15 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43524 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751444Ab1I0PTN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 11:19:13 -0400
Date: Tue, 27 Sep 2011 10:18:59 -0500
From: Serge Hallyn <serge.hallyn@canonical.com>
To: Greg KH <greg@kroah.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        "Serge E. Hallyn" <serge@hallyn.com>, Oleg Nesterov <oleg@redhat.com>,
        lkml <linux-kernel@vger.kernel.org>, richard@nod.at,
        Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>, Tejun Heo <tj@kernel.org>,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH 2/2] user namespace: usb: make usb urbs user namespace
 aware (v2)
Message-ID: <20110927151859.GA2952@peqn>
References: <20110926151829.GA5190@peqn>
 <20110926154518.GA6897@peqn>
 <20110926234540.GA28525@kroah.com>
 <20110927124156.GA3111@sergelap>
 <20110927145605.GB17524@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110927145605.GB17524@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Greg KH (greg@kroah.com):
> On Tue, Sep 27, 2011 at 07:41:57AM -0500, Serge E. Hallyn wrote:
> > Quoting Greg KH (greg@kroah.com):
> > > On Mon, Sep 26, 2011 at 10:45:18AM -0500, Serge Hallyn wrote:
> > > > Add to the dev_state and alloc_async structures the user namespace
> > > > corresponding to the uid and euid.  Pass these to kill_pid_info_as_uid(),
> > > > which can then implement a proper, user-namespace-aware uid check.
> > > > 
> > > > Changelog:
> > > > Sep 20: Per Oleg's suggestion: Instead of caching and passing user namespace,
> > > > 	uid, and euid each separately, pass a struct cred.
> > > > Sep 26: Address Alan Stern's comments: don't define a struct cred at
> > > > 	usbdev_open(), and take and put a cred at async_completed() to
> > > > 	ensure it lasts for the duration of kill_pid_info_as_cred().
> > > > 
> > > > Signed-off-by: Serge Hallyn <serge.hallyn@canonical.com>
> > > > Cc: Greg KH <greg@kroah.com>
> > > 
> > > I have no objection to this, is it going to go through your tree, or
> > > somewhere else?
> > 
> > (Silly question from me, but just to make sure - were you asking this of
> > Alan?)
> 
> Nope, you.  Do you have a tree for this type of namespace work?  I
> haven't been paying attention to it at all.

No, at the moment I don't.

> If not, I'll gladly take it myself, I just don't want to cause any merge
> conflicts anywhere else if at all possible.

Great, thanks.

-serge
