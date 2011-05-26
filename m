Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757445Ab1EZLjS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 07:39:18 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33153 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757220Ab1EZLjJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 07:39:09 -0400
Message-ID: <4DDE3BE1.5030302@suse.cz>
Date: Thu, 26 May 2011 13:39:13 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: Andy Whitcroft <apw@canonical.com>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 34/34] checkpatch: Warn about usage of __DATE__, __TIME__
 and __TIMESTAMP__
References: <1302015561-21047-1-git-send-email-mmarek@suse.cz> <1302015561-21047-35-git-send-email-mmarek@suse.cz>
In-Reply-To: <1302015561-21047-35-git-send-email-mmarek@suse.cz>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5.4.2011 16:59, Michal Marek wrote:
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

Hi Andy,

any comments about this patch?

Thanks,
Michal


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

