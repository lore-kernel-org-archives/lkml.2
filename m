Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753256Ab3ACKJt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 05:09:49 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:59624 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753026Ab3ACKJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 05:09:46 -0500
Date: Thu, 3 Jan 2013 10:09:43 +0000
From: Andy Whitcroft <apw@canonical.com>
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] checkpatch: Warn on unnecessary __dev<foo> section
 markings
Message-ID: <20130103100943.GH2649@dm>
References: <20130102232730.5706.82243.stgit@grignak.americas.hpqcorp.net>
 <20130102232743.5706.63153.stgit@grignak.americas.hpqcorp.net>
 <1357171594.25181.19.camel@joe-AO722>
 <20130102160935.ec405bc4.akpm@linux-foundation.org>
 <1357173201.25181.22.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1357173201.25181.22.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 02, 2013 at 04:33:21PM -0800, Joe Perches wrote:
> Get people to stop adding __devinit and __devexit section markings.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  scripts/checkpatch.pl | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index 4d2c7df..325caa7 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -1931,6 +1931,12 @@ sub process {
>  			      "use the SSYNC() macro in asm/blackfin.h\n" . $herevet);
>  		}
>  
> +# check for old HOTPLUG __dev<foo> section markings
> +		if ($line =~ /\b(__dev(init|exit)(data|const|))\b/) {
> +			WARN("HOTPLUG_SECTION",
> +			     "Using $1 is unnecessary\n" . $herecurr);
> +		}
> +
>  # Check for potential 'bare' types
>  		my ($stat, $cond, $line_nr_next, $remain_next, $off_next,
>  		    $realline_next);

That looks simple enough.

Acked-by: Andy Whitcroft <apw@canonical.com>

-apw
