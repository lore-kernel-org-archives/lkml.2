Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754148Ab0DIQXz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 12:23:55 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:55150 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750883Ab0DIQXv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 12:23:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=KOkHWgG1wAxABDJ78tht4162mareMBuoRz0LUz7sps7DQqqEU60Qx/FvPbDoMxTIx6
         3ZEYdSwO7oFuFgnSYbanCy1anwgDpaKmKtNbhhj51mBDgI+mi8i4Wdb4nzcWcE7SYI64
         pOpj6KT5s18TJbt6NZXxLseiMjg+l+eqtx8sM=
MIME-Version: 1.0
In-Reply-To: <1270821655-4368-5-git-send-email-jblunck@suse.de>
References: <1270821655-4368-1-git-send-email-jblunck@suse.de>
	 <1270821655-4368-5-git-send-email-jblunck@suse.de>
Date: Fri, 9 Apr 2010 19:23:50 +0300
Message-ID: <u2xb6fcc0a1004090923h261c099fpc40b3c289e981b28@mail.gmail.com>
Subject: Re: [PATCH 04/12] frv: remove "struct file *" argument from sysctl 
	->proc_handler
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Jan Blunck <jblunck@suse.de>
Cc: Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
       Alan Cox <alan@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 9, 2010 at 5:00 PM, Jan Blunck <jblunck@suse.de> wrote:
> Seems that Alexey Dobriyan missed this usage of the file argument when
> removing it from ->proc_handler in commit 8d65af789f3e2cf4cfbdbf71a0f7a61ebcd41d38.

It wasn't missed, it was deliberately left out because I didn't understand
what's going on there.

I mean, sysctl handler touching ->f_pos, come on!

What's going on?

> --- a/arch/frv/kernel/sysctl.c
> +++ b/arch/frv/kernel/sysctl.c
> @@ -85,7 +86,7 @@ static int procctl_frv_cachemode(ctl_table *table, int write, struct file *filp,
>        }
>
>        /* read the state */
> -       if (filp->f_pos > 0) {
> +       if (*ppos > 0) {
>                *lenp = 0;
>                return 0;
>        }
