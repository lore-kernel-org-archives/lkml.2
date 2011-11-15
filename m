Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932272Ab1KOUcK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 15:32:10 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:40915 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932120Ab1KOUcI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 15:32:08 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Greg KH <greg@kroah.com>
Subject: Re: [PATCH pm 1/2] usb_storage: don't use set_freezable_with_signal()
Date: Tue, 15 Nov 2011 21:34:49 +0100
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc10+; KDE/4.6.0; x86_64; ; )
Cc: Tejun Heo <tj@kernel.org>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Seth Forshee <seth.forshee@canonical.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        "Greg Kroah-Hartman" <gregkh@suse.de>
References: <20111101003726.GM18855@google.com> <20111115010329.GA26429@kroah.com>
In-Reply-To: <20111115010329.GA26429@kroah.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201111152134.50007.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, November 15, 2011, Greg KH wrote:
> On Mon, Oct 31, 2011 at 05:37:26PM -0700, Tejun Heo wrote:
> > The current implementation of set_freezable_with_signal() is buggy and
> > tricky to get right.  usb-storage is the only user and its use can be
> > avoided trivially.
> > 
> > All usb-storage wants is to be able to sleep with timeout and get
> > woken up if freezing() becomes true.  This can be trivially
> > implemented by doing interruptible wait w/ freezing() included in the
> > wait condition.  There's no reason to use set_freezable_with_signal().
> > 
> > Perform interruptible wait on freezing() instead of using
> > set_freezable_with_signal(), which is scheduled for removal.
> > 
> > Signed-off-by: Tejun Heo <tj@kernel.org>
> > Cc: Oleg Nesterov <oleg@redhat.com>
> > Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
> > Cc: Seth Forshee <seth.forshee@canonical.com>
> > Cc: Alan Stern <stern@rowland.harvard.edu>
> > Cc: Greg Kroah-Hartman <gregkh@suse.de>
> > ---
> > 
> > These two patches are on top of "freezer: fix various bugs and
> > simplify implementation, take#2" patchset[1] and are also available in
> > the following git branch.
> > 
> >  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git pm-kill-freezable_with_signal
> > 
> > If usb-storage ppl are okay with it, I think routing this through pm
> > would be the easiest.  Oh, and this definitely is for the next merge
> > window.
> 
> I'm fine with it going that way:
> 	Acked-by: Greg Kroah-Hartman <gregkh@suse.de>

It's there in my tree already (through the Tejun's pm-freezer branch).

Thanks,
Rafael
