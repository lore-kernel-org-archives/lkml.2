Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932538Ab2HFTlm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 15:41:42 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:44646 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756768Ab2HFTlk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 15:41:40 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Christopher Sacchi <chris.sacchi@gmail.com>
Subject: Re: [PATCH]: Updated autosleep.patch
Date: Mon, 6 Aug 2012 21:47:34 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0+; KDE/4.6.0; x86_64; ; )
Cc: linux-pm@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <CAGh4K3Juk1SRYK363M8YMVD9HnFWO+41r+Uf94rWdM36FQ7LZw@mail.gmail.com>
In-Reply-To: <CAGh4K3Juk1SRYK363M8YMVD9HnFWO+41r+Uf94rWdM36FQ7LZw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201208062147.34806.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, August 06, 2012, Christopher Sacchi wrote:
> This is the patch that fixes a function that could be changed. The
> following (above the 2nd to last line, but uder the first line:
> --
> Signed-off-by: Christopher P. Sacchi <chris.sacchi@gmail.com>
> --- linux-3.5/kernel/power/autosleep.c	2012-07-21 20:58:29.000000000 +0000
> +++ linux-3.5/kernel/power/autosleep.c	2012-08-06 10:52:26.000000000 +0000
> @@ -30,7 +30,7 @@ static void try_to_suspend(struct work_s
>  	if (!pm_get_wakeup_count(&initial_count, true))
>  		goto out;
> 
> -	mutex_lock(&autosleep_lock);
> +	mutex_lock_interruptable();

I guess you mean mutex_lock_interruptable(&autosleep_lock), right?

> 
>  	if (!pm_save_wakeup_count(initial_count)) {
>  		mutex_unlock(&autosleep_lock);
> --

Please tell me what problem is fixed by this change.

Thanks,
Rafael
