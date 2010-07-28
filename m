Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755797Ab0G1UYl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 16:24:41 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60954 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752645Ab0G1UYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 16:24:40 -0400
Date: Wed, 28 Jul 2010 13:24:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Patrick Pannuto <ppannuto@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, apw@canonical.com, corbet@lwn.net,
        Joe Perches <joe@perches.com>
Subject: Re: [PATCH 3/4] Checkpatch: prefer usleep over udelay
Message-Id: <20100728132404.a686d127.akpm@linux-foundation.org>
In-Reply-To: <1280345587-19725-4-git-send-email-ppannuto@codeaurora.org>
References: <1280345587-19725-1-git-send-email-ppannuto@codeaurora.org>
	<1280345587-19725-4-git-send-email-ppannuto@codeaurora.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Jul 2010 12:33:06 -0700
Patrick Pannuto <ppannuto@codeaurora.org> wrote:

> When possible, sleeping is (usually) better than delaying;
> however, don't bother callers of udelay < 10us, as those
> cases are generally not worth the switch to usleep
> 
> Signed-off-by: Patrick Pannuto <ppannuto@codeaurora.org>
> ---
>  scripts/checkpatch.pl |    8 ++++++++
>  1 files changed, 8 insertions(+), 0 deletions(-)
> 
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index bd88f11..892ae62 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -2570,6 +2570,14 @@ sub process {
>  			}
>  		}
>  
> +# prefer usleep over udelay
> +		if (($line =~ /\budelay\s*\(\s*(\w+)\s*\)/ {
> +			# ignore udelay's < 10, however
> +			if (! (($1 =~ /(\d+)/) && ($1 < 10)) ) {
> +				CHK("usleep is preferred over udelay; see Documentation/timers/delays.txt\n" . $line);
> +			}
> +		}

It'd be better to recommend usleep_range(), IMO.  To make people aware
of what they're doing, and to think about it.
