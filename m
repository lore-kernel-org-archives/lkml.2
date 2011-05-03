Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752213Ab1ECOHJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 10:07:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34092 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752664Ab1ECOHH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 10:07:07 -0400
Date: Tue, 3 May 2011 07:05:25 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>
Subject: Re: [RFC][PATCH] PM: Print a warning if firmware is requested when
 tasks are frozen
Message-ID: <20110503140525.GA7944@suse.de>
References: <201105030044.51661.rjw@sisk.pl>
 <20110502231234.GA6430@suse.de>
 <BANLkTikCHO1ST27uhJLU5mBxtWPuuVkNKA@mail.gmail.com>
 <20110502232820.GA9578@suse.de>
 <BANLkTimwmC=ckj4g_ct4EhOSLD7NDgxdng@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTimwmC=ckj4g_ct4EhOSLD7NDgxdng@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 02, 2011 at 05:59:22PM -0700, Linus Torvalds wrote:
> On Mon, May 2, 2011 at 4:28 PM, Greg KH <gregkh@suse.de> wrote:
> >
> > A driver that does not rely on the firmware being built in would be
> > correct in calling request_firmware_nowait() on resume, then when
> > userspace is properly woken up, the firmware would be sent to the
> > device, then the driver would be notified, load it, and handle things
> > as part of its resume sequence from that notification.
> >
> > Isn't that ideally what we want to have happen?
> 
> No. Absolutely not.
> 
> What we ideally want to happen is for the driver to not be a stupid
> piece of sh*t.

Well, we all want that :)

> A driver that needs firmware loading at resume time IS A BROKEN DRIVER.
> 
> It really is that simple.

Ok, fair enough, then I have no objection to this patch.  It will let us
catch those shitty drivers and fix them up to not do this.

thanks,

greg k-h
