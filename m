Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753653Ab1HVUaB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 16:30:01 -0400
Received: from vostochny.stro.at ([78.47.22.85]:42484 "EHLO vostochny.stro.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753153Ab1HVU3v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 16:29:51 -0400
Date: Mon, 22 Aug 2011 22:31:02 +0200
From: maximilian attems <max@stro.at>
To: Mike Waychison <mikew@google.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, "Andrew G. Morgan" <agm@google.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Eric Northup <digitaleric@google.com>,
        Eric Paris <eparis@parisplace.org>, klibc@zytor.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] kinit: Add drop_capabilities support.
Message-ID: <20110822203102.GA22687@stro.at>
References: <CABV1ukEiHm2kHwLxFzAdSVix3Kuc1gvgHPZxU3OZ6M_E7DMgWQ@mail.gmail.com>
 <20110803163046.29085.89618.stgit@mike2.sea.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110803163046.29085.89618.stgit@mike2.sea.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 03 Aug 2011, Mike Waychison wrote:

> This patch adds the ability to kinit to allow the dropping of POSIX
> capabilities.
> 
> kinit is modified by this change, such that it understands the new
> kernel command line "drop_capabilities=" that specifies a comma
> separated list of capability names that should be dropped before
> switching over to the next init in the boot strap (typically on the root
> disk).
> 
> Dropping of capabilities happens in three parts.  We explicitly drop the
> capability from init's inherited masks.  We also drop the capability
> from the bounding set using PR_CAPBSET_DROP so that later setuid execs
> are bounded.  Lastly, we drop the capabilities from the bset and
> inherited masks exposed at /proc/sys/kernel/usermodehelper if available
> (introduced in Linux v3.0.0).
> 
> In all paths, we treat errors as fatal, as we do not want to continue to
> boot if there was a problem dropping capabilities.  We fail because the
> new drop_capabilities= option on the command line mandates enforcement
> of a security policy, and we should err on the side of caution if we
> ever fail to satisfy the administrator's intention.
> 
> Signed-off-by: Mike Waychison <mikew@google.com>
> ---
> v3
>     - Removed special handling of dropping CAP_SETPCAP now that we are
>       only dropping the capability from the inherited mask as suggested
>       by Andrew Morgan.
> v2
>     - Only drop from the inherited capabilities mask.  Only this mask
>       was required as per Andrew Morgan.  This also allows us to
>       continue having capabilities to call run-init later on, allowing
>       the following:
>     - Moved dropping of capabilities out of run-init and into kinit.
>       This was required to ensure access to the proc filesystem, which
>       is required for manipulating the masks the kernel uses when
>       spawning new tasks on the kernel's behalf via the
>       call_usermodehelper() routine.
>     - Fixed paths to the usermodehelper settings files.
>     - Fixed sscanf to allow for a newline character when reading the
>       usermodehelper capability mask settings.
>     - Fixed the return check of the write to the usermodehelper files.
>       These proc files return 0 on successful write(2).
>     - Added a format atttribute to the fail() wrapper for better
>       compiler warnings.
>     - Removed kernel version check.  The boot will now always fail if we
>       could not manipulate the usermodehelper settings.
>     - Sent as a single patch as capset/capget are now in klibc master.
> ---

Should appear shortly on:
http://git.kernel.org/?p=libs/klibc/klibc.git;a=summary
Applied and pushed. Thank you!

-- 
maks
