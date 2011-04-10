Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753998Ab1DJPFp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Apr 2011 11:05:45 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60542 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753550Ab1DJPFo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Apr 2011 11:05:44 -0400
Date: Sun, 10 Apr 2011 08:05:42 -0700 (PDT)
From: Jiri Kosina <jkosina@suse.cz>
To: Nikanth Karthikesan <knikanth@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Anton Altaparmakov <aia21@cam.ac.uk>,
        linux-ntfs-dev@lists.sourceforge.net,
        "Richard Russon (FlatCap)" <ldm@flatcap.org>,
        Klaus Hartmann <Klaus.Hartmann@ts.fujitsu.com>,
        Andries Brouwer <aeb@cwi.nl>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Silence "ldm_validate_partition_table(): Disk read
 failed" when booting with "quiet"
In-Reply-To: <201103171104.15086.knikanth@suse.de>
Message-ID: <alpine.LNX.2.00.1104081928160.6392@deuxcents.site>
References: <201101121633.48567.knikanth@suse.de> <201103151125.05809.knikanth@suse.de> <68B01298-2FC4-4BA3-B76D-50BABA32AC4E@cam.ac.uk> <201103171104.15086.knikanth@suse.de>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Mar 2011, Nikanth Karthikesan wrote:

> From: Nikanth Karthikesan <knikanth@suse.de>
> Subject: Silence "ldm_validate_partition_table(): Disk read failed" when booting with "quiet"
> 
> When the kernel does partition detection, on certain configurations with
> external fibre channel raid systems (e.g. clariion from EMC) the read
> would fail. And "ldm_validate_partition_table(): Disk read failed"
> messages are printed to the console.
> 
> But the failure to read is not a critical error. Now since the message
> is flagged as KERN_CRIT, it gets printed even when booting with the
> "quiet" kernel parameter. Fix it by using KERN_INFO, as the failure to
> read here is not really an error.
> 
> Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>
> Reported-by : Klaus Hartmann <Klaus.Hartmann@ts.fujitsu.com>
> Signed-off-by: Anton Altaparmakov <aia21@cantab.net>
> 
> ---
> 
> diff --git a/fs/partitions/ldm.c b/fs/partitions/ldm.c
> index b10e354..ea648b9 100644
> --- a/fs/partitions/ldm.c
> +++ b/fs/partitions/ldm.c
> @@ -565,7 +565,7 @@ static bool ldm_validate_partition_table(struct parsed_partitions *state)
>  
>  	data = read_part_sector(state, 0, &sect);
>  	if (!data) {
> -		ldm_crit ("Disk read failed.");
> +		ldm_info ("Disk read failed.");
>  		return false;
>  	}

Applied, thanks.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.

