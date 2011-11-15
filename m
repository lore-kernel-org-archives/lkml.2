Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754388Ab1KOBFt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 20:05:49 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:50784 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753561Ab1KOBFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 20:05:40 -0500
X-Sasl-enc: BohwWxBd6KwMC45CzSRvwtAkQsvnOaDQXht4emHv016I 1321319138
Date: Mon, 14 Nov 2011 17:03:29 -0800
From: Greg KH <greg@kroah.com>
To: Tejun Heo <tj@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Seth Forshee <seth.forshee@canonical.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH pm 1/2] usb_storage: don't use set_freezable_with_signal()
Message-ID: <20111115010329.GA26429@kroah.com>
References: <20111101003726.GM18855@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111101003726.GM18855@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 31, 2011 at 05:37:26PM -0700, Tejun Heo wrote:
> The current implementation of set_freezable_with_signal() is buggy and
> tricky to get right.  usb-storage is the only user and its use can be
> avoided trivially.
> 
> All usb-storage wants is to be able to sleep with timeout and get
> woken up if freezing() becomes true.  This can be trivially
> implemented by doing interruptible wait w/ freezing() included in the
> wait condition.  There's no reason to use set_freezable_with_signal().
> 
> Perform interruptible wait on freezing() instead of using
> set_freezable_with_signal(), which is scheduled for removal.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Oleg Nesterov <oleg@redhat.com>
> Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
> Cc: Seth Forshee <seth.forshee@canonical.com>
> Cc: Alan Stern <stern@rowland.harvard.edu>
> Cc: Greg Kroah-Hartman <gregkh@suse.de>
> ---
> 
> These two patches are on top of "freezer: fix various bugs and
> simplify implementation, take#2" patchset[1] and are also available in
> the following git branch.
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git pm-kill-freezable_with_signal
> 
> If usb-storage ppl are okay with it, I think routing this through pm
> would be the easiest.  Oh, and this definitely is for the next merge
> window.

I'm fine with it going that way:
	Acked-by: Greg Kroah-Hartman <gregkh@suse.de>

