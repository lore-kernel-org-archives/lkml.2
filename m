Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753793Ab1LBX2j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 18:28:39 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39790 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753273Ab1LBX2e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 18:28:34 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: Re: [PATCH] PM, kernel/power/user.c: Replace unintuitive 'if' condition with 'else'
Date: Sat, 3 Dec 2011 00:31:27 +0100
User-Agent: KMail/1.13.6 (Linux/3.2.0-rc3+; KDE/4.6.0; x86_64; ; )
Cc: pavel@ucw.cz, len.brown@intel.com, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
References: <20111202180645.15985.26730.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20111202180645.15985.26730.stgit@srivatsabhat.in.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201112030031.27965.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, December 02, 2011, Srivatsa S. Bhat wrote:
> In the snapshot_ioctl() function, under SNAPSHOT_FREEZE, the code below
> freeze_processes() is a bit unintuitive. Improve it by replacing the
> second 'if' condition with an 'else' clause.
> 
> Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>

Applied to linux-pm/linux-next.

Thanks,
Rafael


> ---
> 
>  kernel/power/user.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/power/user.c b/kernel/power/user.c
> index 7cc3f5b..8c64d1c 100644
> --- a/kernel/power/user.c
> +++ b/kernel/power/user.c
> @@ -259,7 +259,7 @@ static long snapshot_ioctl(struct file *filp, unsigned int cmd,
>  		error = freeze_processes();
>  		if (error)
>  			usermodehelper_enable();
> -		if (!error)
> +		else
>  			data->frozen = 1;
>  		break;
>  
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

