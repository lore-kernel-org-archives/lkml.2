Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755449Ab0G1UZe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 16:25:34 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58046 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754748Ab0G1UZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 16:25:32 -0400
Date: Wed, 28 Jul 2010 13:24:57 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Patrick Pannuto <ppannuto@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, apw@canonical.com, corbet@lwn.net,
        Joe Perches <joe@perches.com>
Subject: Re: [PATCH 4/4] Checkpatch: warn about unexpectedly long msleep's
Message-Id: <20100728132457.06b0c279.akpm@linux-foundation.org>
In-Reply-To: <1280345587-19725-5-git-send-email-ppannuto@codeaurora.org>
References: <1280345587-19725-1-git-send-email-ppannuto@codeaurora.org>
	<1280345587-19725-5-git-send-email-ppannuto@codeaurora.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Jul 2010 12:33:07 -0700
Patrick Pannuto <ppannuto@codeaurora.org> wrote:

> As explained in Documentation/timers/delays.txt, msleep's
> of < 20ms may sleep for as long as 20ms. Caller's of
> msleep(1) or msleep(2), etc are likely not to expect this
> quirky behavior - warn them.
> 
> Signed-off-by: Patrick Pannuto <ppannuto@codeaurora.org>
> ---
>  scripts/checkpatch.pl |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)
> 
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index 892ae62..0ca2ea5 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -2578,6 +2578,13 @@ sub process {
>  			}
>  		}
>  
> +# warn about unexpectedly long msleep's
> +		if ($line =~ /\bmsleep\s*\((\d+)\);/) {
> +			if ($1 < 20) {
> +				WARN("msleep < 20ms can sleep for up to 20ms; see Documentation/timers/delays.txt\n" . $line);

Should be timers-howto.txt?


