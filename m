Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753896Ab2KZCzZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2012 21:55:25 -0500
Received: from li9-11.members.linode.com ([67.18.176.11]:34721 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753789Ab2KZCzX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2012 21:55:23 -0500
Date: Sun, 25 Nov 2012 21:55:20 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: torvalds@linux-foundation.org
Cc: Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH, 3.7-rc7, RESEND] fs: revert commit bbdd6808 to fallocate
 UAPI
Message-ID: <20121126025520.GC22858@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	torvalds@linux-foundation.org, Dave Chinner <david@fromorbit.com>,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <1353366267-15629-1-git-send-email-david@fromorbit.com>
 <20121126002814.GM32450@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121126002814.GM32450@dastard>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 26, 2012 at 11:28:14AM +1100, Dave Chinner wrote:
> fs: revert commit bbdd6808 to fallocate UAPI
> 
> From: Dave Chinner <dchinner@redhat.com>
> 
> Commit bbdd6808 ("fs: reserve fallocate flag codepoint") changes the
> fallocate(2) syscall interface. The flag that is reserved by this
> commit is for functionality that has previously been NAKed on the
> -fsdevel mailing list, and so exists out-of-tree.

Hi Linus,

It doesn't change the interface or break anything; it just reserves a
bit so that out-of-tree patches don't collide with future allocations.
There are significant usages of this bit within Google and Tao Bao.
It is true that there has been significant pushback about adding this
functionality on linux-fsdevel; I find it personally frustrating that
in effect, if enough people scream, they can veto an optional feature
that might only be implemented by a single file system.

It's not like there is any shortage of flag bits, so what's the harm
of reserving the bit?

						- Ted
