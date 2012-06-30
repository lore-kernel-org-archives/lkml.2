Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752160Ab2F3DIm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 23:08:42 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:42749 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750989Ab2F3DIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 23:08:41 -0400
Date: Fri, 29 Jun 2012 23:08:36 -0400
From: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To: "Boie, Andrew P" <andrew.p.boie@intel.com>
Cc: NeilBrown <neilb@suse.de>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "arve@android.com" <arve@android.com>,
        "ccross@android.com" <ccross@android.com>,
        "rebecca@android.com" <rebecca@android.com>
Subject: Re: [PATCH] bcb: Android bootloader control block driver
Message-ID: <20120630030836.GA3972@kroah.com>
References: <1340998590-23042-1-git-send-email-andrew.p.boie@intel.com>
 <20120630072519.71835f43@notabene.brown>
 <2E57EB624252DB47AFBC064A9AFBA980077EE18B@ORSMSX105.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2E57EB624252DB47AFBC064A9AFBA980077EE18B@ORSMSX105.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 29, 2012 at 09:56:36PM +0000, Boie, Andrew P wrote:
> > From: NeilBrown [mailto:neilb@suse.de]
> > Sent: Friday, June 29, 2012 2:25 PM
> > 
> > On Fri, 29 Jun 2012 12:36:30 -0700 Andrew Boie <andrew.p.boie@intel.com>
> > wrote:
> > 
> > > Android userspace tells the kernel that it wants to boot into recovery
> > > or some other non-default OS environment by passing a string argument
> > > to reboot(). It is left to the OEM to hook this up to their specific
> > > bootloader.
> 
> > Maybe I'm missing something obvious, but why does this need to be
> > implemented
> > in the kernel?  Can't some user-space process just write to that partition
> > using open/read/seek/write/close before calling 'reboot'.
> 
> Thanks for reviewing. The way Android is currently designed, all calls
> to reboot the system into an alternate target go into android_reboot()
> in libcutils which then make the reboot() system call with a string
> argument. How this is actually done on a particular board is not
> specified in the Android Open Source Project as far as I can see. The
> particular bootloader is not specified either, many different ones are
> being used in practice.

Which is fine, the kernel doesn't, and shouldn't care about this.

> Not  every architecture is going to be using the Bootloader Control
> Block to handle these boots into alternate targets. For example, I
> worked on one Android-based device that didn't have a traditional
> bootloader at all and the reboot hook in the kernel was radically
> different. In this case the BCB ended up only being used by the
> recovery console to stash its command line arguments.

So what architectures are going to be using this?

> If this were all done in userspace, then I think there would have to
> be separate code paths in libcutils for different board
> implementations of this policy. As of right now libcutils doesn't have
> any hardware-specific stuff in it and the mechanism to effect these
> policies is left to the kernel, libcutils works everywhere without
> modification.

So, without that, the kernel is setting the policy here instead?  That's
generally the opposite of what we want to do, it's up to userspace to
determine things like this.

confused,

greg k-h
