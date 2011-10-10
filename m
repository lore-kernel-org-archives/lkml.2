Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751803Ab1JJG1B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 02:27:01 -0400
Received: from mail.skyhub.de ([78.46.96.112]:50987 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751027Ab1JJG1A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 02:27:00 -0400
Date: Mon, 10 Oct 2011 08:26:53 +0200
From: Borislav Petkov <bp@alien8.de>
To: Barry Song <Barry.Song@csr.com>
Cc: pavel@ucw.cz, rjw@sisk.pl, linux-pm@lists.linux-foundation.org,
        linux-mmc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, workgroup.linux@csr.com,
        Barry Song <baohua.song@csr.com>
Subject: Re: [PATCH] PM: HIBERNATION: add resume_delay kernel param as well
 as resume_delay
Message-ID: <20111010062653.GB4139@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Barry Song <Barry.Song@csr.com>, pavel@ucw.cz, rjw@sisk.pl,
	linux-pm@lists.linux-foundation.org, linux-mmc@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	workgroup.linux@csr.com, Barry Song <baohua.song@csr.com>
References: <1318225452-10397-1-git-send-email-Barry.Song@csr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1318225452-10397-1-git-send-email-Barry.Song@csr.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 09, 2011 at 10:44:12PM -0700, Barry Song wrote:
> From: Barry Song <baohua.song@csr.com>
> 
> patch "PM: HIBERNATION: add resume_wait param to support MMC-like devices
> as resume file" add resume_wait param. this patch adds resume_delay so that
> resume_wait/delay has the same model with root_wait/delay.
> 
> Signed-off-by: Barry Song <baohua.song@csr.com>
> ---
>  Documentation/kernel-parameters.txt |    3 +++
>  kernel/power/hibernate.c            |   14 ++++++++++++++
>  2 files changed, 17 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index 88a7b19..831bde2 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -2240,6 +2240,9 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
>  			in <PAGE_SIZE> units (needed only for swap files).
>  			See  Documentation/power/swsusp-and-swap-files.txt
>  
> +	resumedelay=	[HIBERNATION] Delay (in seconds) to pause before attempting to
> +			read the resume files
> +
>  	resumewait	[HIBERNATION] Wait (indefinitely) for resume device to show up.
>  			Useful for devices that are detected asynchronously
>  			(e.g. USB and MMC devices).
> diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
> index b3da53c..f73a00e 100644
> --- a/kernel/power/hibernate.c
> +++ b/kernel/power/hibernate.c
> @@ -33,6 +33,7 @@
>  static int nocompress = 0;
>  static int noresume = 0;
>  static int resume_wait = 0;
> +static int resume_delay = 0;

These static variables get zeroed needlessly and checkpatch actually
warns about that. Maybe fix that up while you're there?

Thanks.

-- 
Regards/Gruss,
    Boris.
