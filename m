Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755173Ab2K2WJ7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 17:09:59 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:56719 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753304Ab2K2WJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 17:09:58 -0500
Date: Thu, 29 Nov 2012 22:09:57 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Revert "__d_unalias() should refuse to move mountpoints"
Message-ID: <20121129220957.GV4939@ZenIV.linux.org.uk>
References: <87txumrct6.fsf@xmission.com>
 <50615268.1040805@canonical.com>
 <8db34325-e8e4-4e24-85dd-c8951769e2b6@email.android.com>
 <506173A6.2050705@canonical.com>
 <87ipb2pemt.fsf@xmission.com>
 <50618F96.1020204@canonical.com>
 <87sja6nxvt.fsf@xmission.com>
 <20121129200612.GP4939@ZenIV.linux.org.uk>
 <20121129205334.GR4939@ZenIV.linux.org.uk>
 <20121129213034.GT4939@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121129213034.GT4939@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2012 at 09:30:34PM +0000, Al Viro wrote:

> +			if (d_invalidate(dentry) != 0) {
> +				WARN_ON(1);
> +				goto out;
> +			}
>  			dput(dentry);
>  		}
>  	}
> h/openrisc/kernel/signal.c   |    6 ++----
>  arch/score/kernel/signal.c      |    7 ++-----
>  arch/sh/kernel/signal_64.c      |    6 ++----
>  arch/um/kernel/exec.c           |    3 ++-
>  5 files changed, 9 insertions(+), 15 deletions(-)

*boggle*

Looks like scp has _not_ truncated the target until the end of transmission
(and I've done :r <file> from vi before it had done that).  Weird...  The
file looks normal now, on both boxen.  Oh, well...
