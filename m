Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754891Ab1HFQMt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Aug 2011 12:12:49 -0400
Received: from isilmar-3.linta.de ([188.40.101.200]:38550 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754316Ab1HFQMr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Aug 2011 12:12:47 -0400
Date: Sat, 6 Aug 2011 15:49:27 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: Amerigo Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Thomas Renninger <trenn@suse.de>
Subject: Re: [Patch] cpupower: avoid using symlinks
Message-ID: <20110806134927.GA14408@comet.dominikbrodowski.net>
Mail-Followup-To: Dominik Brodowski <linux@dominikbrodowski.net>,
	Amerigo Wang <amwang@redhat.com>, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org, Thomas Renninger <trenn@suse.de>
References: <1312348621-20172-1-git-send-email-amwang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1312348621-20172-1-git-send-email-amwang@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Applied, thanks.

On Wed, Aug 03, 2011 at 01:17:01PM +0800, Amerigo Wang wrote:
> Reference the source directly, don't create symlinks.
> 
> Signed-off-by: WANG Cong <amwang@redhat.com>
> 
> ---
> diff --git a/tools/power/cpupower/debug/x86_64/Makefile b/tools/power/cpupower/debug/x86_64/Makefile
> index dbf1399..3326217 100644
> --- a/tools/power/cpupower/debug/x86_64/Makefile
> +++ b/tools/power/cpupower/debug/x86_64/Makefile
> @@ -1,10 +1,10 @@
>  default: all
>  
> -centrino-decode: centrino-decode.c
> -	$(CC) $(CFLAGS) -o centrino-decode centrino-decode.c
> +centrino-decode: ../i386/centrino-decode.c
> +	$(CC) $(CFLAGS) -o $@ $<
>  
> -powernow-k8-decode: powernow-k8-decode.c
> -	$(CC) $(CFLAGS) -o powernow-k8-decode powernow-k8-decode.c
> +powernow-k8-decode: ../i386/powernow-k8-decode.c
> +	$(CC) $(CFLAGS) -o $@ $<
>  
>  all: centrino-decode powernow-k8-decode
>  
> diff --git a/tools/power/cpupower/debug/x86_64/centrino-decode.c b/tools/power/cpupower/debug/x86_64/centrino-decode.c
> deleted file mode 120000
> index 26fb3f1..0000000
> --- a/tools/power/cpupower/debug/x86_64/centrino-decode.c
> +++ /dev/null
> @@ -1 +0,0 @@
> -../i386/centrino-decode.c
> \ No newline at end of file
> diff --git a/tools/power/cpupower/debug/x86_64/powernow-k8-decode.c b/tools/power/cpupower/debug/x86_64/powernow-k8-decode.c
> deleted file mode 120000
> index eb30c79..0000000
> --- a/tools/power/cpupower/debug/x86_64/powernow-k8-decode.c
> +++ /dev/null
> @@ -1 +0,0 @@
> -../i386/powernow-k8-decode.c
> \ No newline at end of file
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
