Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752557Ab2KRCrn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2012 21:47:43 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:37289 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752273Ab2KRCrm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2012 21:47:42 -0500
Date: Sat, 17 Nov 2012 18:44:12 -0800
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: dragos.tatulea@intel.com
Cc: ccross@android.com, keescook@chromium.org, tony.luck@intel.com,
        linux-kernel@vger.kernel.org, adrian.hunter@intel.com,
        octavian.purdila@intel.com
Subject: Re: [PATCH v3 8/9] pstore: max out console log level during sysfs
 dump switch
Message-ID: <20121118024412.GB12833@lizard.sbx05977.paloaca.wayport.net>
References: <1350558367-31801-1-git-send-email-dragos.tatulea@intel.com>
 <1350558367-31801-9-git-send-email-dragos.tatulea@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1350558367-31801-9-git-send-email-dragos.tatulea@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18, 2012 at 02:06:06PM +0300, dragos.tatulea@intel.com wrote:
> From: Dragos Tatulea <dragos.tatulea@intel.com>
> 
> Otherwise we might miss out on some pstore dumpers that use
> printks below current log level.

If anything, this should be folded into 'pstore: add debugfs support for
causing dumps and panics'. But I'm not sure about the debugfs stuff
anyway.

> Signed-off-by: Dragos Tatulea <dragos.tatulea@intel.com>
> ---
>  fs/pstore/platform.c |    4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/fs/pstore/platform.c b/fs/pstore/platform.c
> index 25f59ed..e3ad13e 100644
> --- a/fs/pstore/platform.c
> +++ b/fs/pstore/platform.c
> @@ -267,6 +267,7 @@ static DEFINE_SPINLOCK(dbg_lock);
>  static int dbg_dump(void *data, u64 val)
>  {
>  	unsigned long flags;
> +	int saved_loglevel;
>  
>  	switch (val) {
>  	case KMSG_DUMP_PANIC:
> @@ -276,7 +277,10 @@ static int dbg_dump(void *data, u64 val)
>  	case KMSG_DUMP_HALT:
>  	case KMSG_DUMP_POWEROFF:
>  		spin_lock_irqsave(&dbg_lock, flags);
> +		saved_loglevel = console_loglevel;
> +		console_loglevel =  15;
>  		kmsg_dump(val);
> +		console_loglevel = saved_loglevel;
>  		spin_unlock_irqrestore(&dbg_lock, flags);
>  		return 0;
>  	}
> -- 
> 1.7.9.5
