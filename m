Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755241Ab1DEQRy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 12:17:54 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:56665 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755099Ab1DEQRu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 12:17:50 -0400
Date: Tue, 5 Apr 2011 18:16:16 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Alexandre Felipe Muller de Souza <alexandrefm@mandriva.com.br>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Power Manager suspend-hybrid warn on systemlog
Message-ID: <20110405161616.GC1615@ucw.cz>
References: <1298384175.8390.25.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1298384175.8390.25.camel@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2011-02-22 11:16:15, Alexandre Felipe Muller de Souza wrote:
> I'm not shure if it's a correct solution, or if it breaks something on a
> specific situation. So I decided to send it to the list, to someone more
> experienced if that code send their opinion. I realized that
> pm-suspend-hybrid generates a warning on system log (at least in intel
> arch):

cc: maintainers gets you faster response...

> WARNING: at mm/page_alloc.c:122 pm_restrict_gfp_mask+0x4e/0x50()
> Call Trace:
> [<c0150f12>] warn_slowpath_common+0x72/0xa0
> [<c01da71e>] ? pm_restrict_gfp_mask+0x4e/0x50
> [<c01da71e>] ? pm_restrict_gfp_mask+0x4e/0x50
> [<c0150f62>] warn_slowpath_null+0x22/0x30
> [<c01da71e>] pm_restrict_gfp_mask+0x4e/0x50
> [<c018a822>] suspend_devices_and_enter+0x52/0x1d0
> [<c015be25>] ? capable+0x15/0x50
> [<c018fe30>] snapshot_ioctl+0x2b0/0x5c0
> [<c017e3c2>] ? tick_dev_program_event+0x42/0x150
> [<c018fb80>] ? snapshot_ioctl+0x0/0x5c0
> [<c02269bd>] do_vfs_ioctl+0x8d/0x5b0
> [<c029e216>] ? tomoyo_init_request_info+0x46/0x50
> [<c029bceb>] ? tomoyo_path_number_perm+0x2b/0xe0
> [<c017911d>] ? ktime_get_ts+0xed/0x120
> [<c029dad7>] ? tomoyo_file_ioctl+0x17/0x20
> [<c0226f47>] sys_ioctl+0x67/0x80
> [<c010ae5f>] sysenter_do_call+0x12/0x28
> 
> So I put some debugs, and saw 2 sequential calls for
> pm_restrict_gfp_mask (in hibernate) that the second call warns it. So I
> removed it, and made some tests and seens to work without warn (suspend,
> hybrid, hibernate). So my question is: is it safe to do that?
> The "problem" was tested and occurs on 2.6.37 and 2.6.38-rc5.
> ---
> 
> diff --git a/kernel/power/suspend.c b/kernel/power/suspend.c
> --- a/kernel/power/suspend.c 2011-01-04 22:50:19.000000000 -0200
> +++ b/kernel/power/suspend.c 2011-02-21 15:39:16.000000000 -0300
> @@ -207,7 +207,6 @@
> goto Close;
> }
> suspend_console();
> - pm_restrict_gfp_mask();
> suspend_test_start();
> error = dpm_suspend_start(PMSG_SUSPEND);
> if (error) { 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
