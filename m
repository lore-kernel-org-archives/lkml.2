Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754609Ab1C2Wrc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 18:47:32 -0400
Received: from adelphi.physics.adelaide.edu.au ([129.127.102.1]:34580 "EHLO
	adelphi.physics.adelaide.edu.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751698Ab1C2Wra (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 18:47:30 -0400
X-Greylist: delayed 306 seconds by postgrey-1.27 at vger.kernel.org; Tue, 29 Mar 2011 18:47:30 EDT
From: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
Message-Id: <201103292242.p2TMgAET020124@turbo.physics.adelaide.edu.au>
Subject: Re: [PATCH 08/23] fujitsu-laptop: Convert printks to pr_<level>
To: joe@perches.com (Joe Perches)
Date: Wed, 30 Mar 2011 08:12:10 +0930 (CST)
Cc: mjg@redhat.com (Matthew Garrett),
        jwoithe@physics.adelaide.edu.au (Jonathan Woithe),
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20baaa2f09235d33f2cf751eaf6ad6f1bbb24d64.1301436234.git.joe@perches.com> from "Joe Perches" at Mar 29, 2011 03:21:39 PM
X-Mailer: ELM [version 2.5 PL6]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Added pr_fmt, converted printks and removed hard coded prefixes.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Acked-by: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>

But see comment below.

OOI, what does pr_*() give us over printk()?  I presume it makes it easier
to selectively remove certain printk levels from the kernel image in the
name of size reduction.

> diff --git a/drivers/platform/x86/fujitsu-laptop.c b/drivers/platform/x86/fujitsu-laptop.c
> index 493054c..6b26666 100644
> --- a/drivers/platform/x86/fujitsu-laptop.c
> +++ b/drivers/platform/x86/fujitsu-laptop.c
> :
> @@ -907,8 +907,8 @@ static int acpi_fujitsu_hotkey_add(struct acpi_device *device)
>  		if (result == 0) {
>  			fujitsu_hotkey->logolamp_registered = 1;
>  		} else {
> -			printk(KERN_ERR "fujitsu-laptop: Could not register "
> -			"LED handler for logo lamp, error %i\n", result);
> +			pr_err("Could not register LED handler for logo lamp, error %i\n",
> +			       result);
>  		}
>  	}
>  
> @@ -919,8 +919,8 @@ static int acpi_fujitsu_hotkey_add(struct acpi_device *device)
>  		if (result == 0) {
>  			fujitsu_hotkey->kblamps_registered = 1;
>  		} else {
> -			printk(KERN_ERR "fujitsu-laptop: Could not register "
> -			"LED handler for keyboard lamps, error %i\n", result);
> +			pr_err("Could not register LED handler for keyboard lamps, error %i\n",
> +			       result);
>  		}
>  	}
>  #endif

Some people *may* insist that these long (>80 character) pr_err() lines be
split so they remain <80 in length.  This was the reason why the original
printk() call was split like it was.

Regards
  jonathan
