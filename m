Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752771Ab2ECL0V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 07:26:21 -0400
Received: from orion.tchmachines.com ([208.76.84.200]:57152 "EHLO
	orion.tchmachines.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433Ab2ECL0U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 07:26:20 -0400
From: Vlad Zolotarov <vlad@scalemp.com>
Organization: ScaleMP Ltd.
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH] fs: Move bh_cachep to the __read_mostly section
Date: Thu, 3 May 2012 14:26:26 +0300
User-Agent: KMail/1.13.5 (Linux/2.6.32-41-generic; KDE/4.4.5; i686; ; )
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>, alan@lxorguk.ukuu.org.uk,
        "Shai Fultheim (Shai@ScaleMP.com)" <Shai@scalemp.com>,
        Thomas Gleixner <tglx@linutronix.de>
References: <201204241422.23065.vlad@scalemp.com>
In-Reply-To: <201204241422.23065.vlad@scalemp.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201205031426.27432.vlad@scalemp.com>
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - orion.tchmachines.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - scalemp.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, April 24, 2012 02:22:22 pm Vlad Zolotarov wrote:
> From: Shai Fultheim <shai@scalemp.com>
> 
> bh_cachep is only written to once on initialization, so move it to the
> __read_mostly section.
> 
> Signed-off-by: Shai Fultheim <shai@scalemp.com>
> Signed-off-by: Vlad Zolotarov <vlad@scalemp.com>
> ---
>  fs/buffer.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/buffer.c b/fs/buffer.c
> index 36d6665..a1d82fb 100644
> --- a/fs/buffer.c
> +++ b/fs/buffer.c
> @@ -3151,7 +3151,7 @@ SYSCALL_DEFINE2(bdflush, int, func, long, data)
>  /*
>   * Buffer-head allocation
>   */
> -static struct kmem_cache *bh_cachep;
> +static struct kmem_cache *bh_cachep __read_mostly;
> 
>  /*
>   * Once the number of bh's in the machine exceeds this level, we start

Thomas, Ingo, Peter, Alan, do u want me to respin this patch? 
(Alan, this one is not x86 ;))

Could u, pls., advice what should be done for it to be applied?

thanks,
vlad
