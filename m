Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754358Ab1EBX2b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 19:28:31 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36752 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751151Ab1EBX2a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 19:28:30 -0400
Date: Mon, 2 May 2011 16:28:20 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>
Subject: Re: [RFC][PATCH] PM: Print a warning if firmware is requested when
 tasks are frozen
Message-ID: <20110502232820.GA9578@suse.de>
References: <201105030044.51661.rjw@sisk.pl>
 <20110502231234.GA6430@suse.de>
 <BANLkTikCHO1ST27uhJLU5mBxtWPuuVkNKA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTikCHO1ST27uhJLU5mBxtWPuuVkNKA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 02, 2011 at 04:21:09PM -0700, Linus Torvalds wrote:
> On Mon, May 2, 2011 at 4:12 PM, Greg KH <gregkh@suse.de> wrote:
> >
> > But you can safely call this function with nowait set, and this warning
> > should not be triggered, right?
> 
> Why would you want that?
> 
> It's _always_ wrong to ask for firmware during resume. "nowait" or not
> is totally irrelevant. A driver that depends on the firmware being
> built in to the kernel is a buggy driver, why would you want to
> silently allow that kind of crap? It's just a timebomb waiting for
> somebody to compile the kernel differently.

A driver that does not rely on the firmware being built in would be
correct in calling request_firmware_nowait() on resume, then when
userspace is properly woken up, the firmware would be sent to the
device, then the driver would be notified, load it, and handle things
as part of its resume sequence from that notification.

Isn't that ideally what we want to have happen?

Or am I missing something else?

thanks,

greg k-h
