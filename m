Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757543Ab1EZMm1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 08:42:27 -0400
Received: from adelie.canonical.com ([91.189.90.139]:43044 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757075Ab1EZMm0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 08:42:26 -0400
Date: Thu, 26 May 2011 13:42:23 +0100
From: Andy Whitcroft <apw@canonical.com>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 34/34] checkpatch: Warn about usage of __DATE__, __TIME__
 and __TIMESTAMP__
Message-ID: <20110526124223.GG2615@shadowen.org>
References: <1302015561-21047-1-git-send-email-mmarek@suse.cz>
 <1302015561-21047-35-git-send-email-mmarek@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1302015561-21047-35-git-send-email-mmarek@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 05, 2011 at 04:59:21PM +0200, Michal Marek wrote:
> The __TIME__ and __DATE__ macros are evil. Every C textbook mentions
> them, but forgets to add the tiny detail that they make sure that your
> code will never result in the same binary. __TIMESTAMP__ is a bit more
> sane, but again produces noise as soon as you switch branches back and
> forth, or apply a patch and revert it.
> 
> Cc: Andy Whitcroft <apw@canonical.com>
> Signed-off-by: Michal Marek <mmarek@suse.cz>
> ---
>  scripts/checkpatch.pl |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index 4c0383d..dbcdf04 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -2804,6 +2804,11 @@ sub process {
>  			WARN("__func__ should be used instead of gcc specific __FUNCTION__\n"  . $herecurr);
>  		}
>  
> +# check for pointless usage of __TIME__ and friends
> +		if ($line =~ /\b__(TIME|DATE|TIMESTAMP)__\b/) {
> +			WARN("Usage of __$1__ should be avoided to keep the build deterministic\n" . $herecurr);
> +		}
> +
>  # check for semaphores initialized locked
>  		if ($line =~ /^.\s*sema_init.+,\W?0\W?\)/) {
>  			WARN("consider using a completion\n" . $herecurr);
> -- 
> 1.7.4.1

Looks reasonable to me.

-apw
