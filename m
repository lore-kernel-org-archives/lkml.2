Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752588Ab2KRCtt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2012 21:49:49 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52481 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752515Ab2KRCts (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2012 21:49:48 -0500
Date: Sat, 17 Nov 2012 18:46:32 -0800
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: dragos.tatulea@intel.com
Cc: ccross@android.com, keescook@chromium.org, tony.luck@intel.com,
        linux-kernel@vger.kernel.org, adrian.hunter@intel.com,
        octavian.purdila@intel.com
Subject: Re: [PATCH v3 5/9] pstore: add task list dumper
Message-ID: <20121118024632.GB10763@lizard.sbx05977.paloaca.wayport.net>
References: <1350558367-31801-1-git-send-email-dragos.tatulea@intel.com>
 <1350558367-31801-6-git-send-email-dragos.tatulea@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1350558367-31801-6-git-send-email-dragos.tatulea@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18, 2012 at 02:06:03PM +0300, dragos.tatulea@intel.com wrote:
> From: Dragos Tatulea <dragos.tatulea@intel.com>
> 
> The task dumper can dump task information during a panic.
> This is equivalent to a magic sysrq 't' command but
> the result is captured from the console and written
> to persistent storage.  Note that this happens after
> pstore dumps kernel messages because the task dump will
> overwrite other kernel messages.
> 
> There is a single module parameter "enabled" which must
> be used to enable task dumping.

This is a very very strange approach to accomplish this.

Plus, we have the console dumper already, so I think it should be done the
other way around: if you want a tasklist dumped during panic, introduce a
generic feature for the panic logging, i.e. just print tasks after/before
panic trace.

Or am I missing the point of the patch?

> 
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> Signed-off-by: Dragos Tatulea <dragos.tatulea@intel.com>
> ---
>  fs/pstore/Kconfig      |   12 ++++++
>  fs/pstore/Makefile     |    1 +
>  fs/pstore/dump_tasks.c |  107 ++++++++++++++++++++++++++++++++++++++++++++++++
>  fs/pstore/inode.c      |    3 ++
>  include/linux/pstore.h |    1 +
>  5 files changed, 124 insertions(+)
>  create mode 100644 fs/pstore/dump_tasks.c
> 
> diff --git a/fs/pstore/Kconfig b/fs/pstore/Kconfig
> index ca71db6..ee967c5 100644
> --- a/fs/pstore/Kconfig
> +++ b/fs/pstore/Kconfig
> @@ -48,3 +48,15 @@ config PSTORE_RAM
>  	  "ramoops.ko".
>  
>  	  For more information, see Documentation/ramoops.txt.
> +
> +config PSTORE_DUMP_TASKS
> +	bool "Dump task information"
> +	default n

'default n' is there by default. :) So no need for this line.

Thanks,
Anton.
