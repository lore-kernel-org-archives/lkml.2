Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753079Ab1AYDAi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 22:00:38 -0500
Received: from kroah.org ([198.145.64.141]:34524 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752919Ab1AYDAh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 22:00:37 -0500
Date: Tue, 25 Jan 2011 11:01:05 +0800
From: Greg KH <greg@kroah.com>
To: Mike Waychison <mikew@google.com>
Cc: torvalds@linux-foundation.org, San Mehat <san@google.com>,
        Aaron Durbin <adurbin@google.com>, Duncan Laurie <dlaurie@google.com>,
        linux-kernel@vger.kernel.org, Tim Hockin <thockin@google.com>
Subject: Re: [PATCH v1 0/6] google firmware support
Message-ID: <20110125030105.GA8761@kroah.com>
References: <20110125002433.12637.51091.stgit@mike.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110125002433.12637.51091.stgit@mike.mtv.corp.google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 24, 2011 at 04:24:34PM -0800, Mike Waychison wrote:
> This patchset applies to v2.6.38-rc2.
> 
> The following series implements support for interfaces exposed by
> google's servers' firmware.
> 
> We'd like to have these small drivers included as they are required for
> proper use of the kernel in our infrastructure.  They may not seem like
> much, but a lot of our health automation as well as our human debugging
> efforts are dependent on the functionality herein.
> 
> I'm pretty happy with the way this patchset looks and would like to ask
> that they be merged at some point if there aren't any big objections.
> Getting these in the public Linux tree would bring us closer to being
> able to easily test kernels as they are released.
> 
> I wasn't certain who to send these patches to, please advise if I should
> be CCing anyone else.

I can take these, once they get all worked out, as I think I'm still the
de-facto firmware maintainer.

> [1] and [5] are the only ones that touch the 'core' kernel.
> 
> 
>    - [1] adds a notifier_block that is called on Oops.

This seems like a duplication of the existing infrastructure we already
have for getting notified of oopses.

>    - [2] introduces CONFIG_GOOGLE_FIRMWARE which all Google firmware
>      drivers can depend upon.
> 
>    - [3] and [4] are drivers we use that are ready for inclusion.  [3]
>      communicates with our EFI images via an SMI handshake.  [4] works
>      with our older BIOSes to construct a log of reboot reasons.
> 
>    - [5] prepares for [6] by introducing prepend_to_dmesg() which
>      allows drivers to prepend pre-kernel messages to the dmesg at
>      bootup.

That seems "rude".  Why can't you just pick out from the kernel log the
data you need when it gets printed?  This seems like you feel your code
should always get a "First Post!" message.  What happens when someone
else wants this and you get dueling "firsts"?

thanks,

greg k-h
