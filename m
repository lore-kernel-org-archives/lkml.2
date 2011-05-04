Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755897Ab1EDWGM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 18:06:12 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44198 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752791Ab1EDWGL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 18:06:11 -0400
Date: Wed, 4 May 2011 15:05:57 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeff Mahoney <jeffm@suse.com>
Cc: Ingo Molnar <mingo@elte.hu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mandeep Singh Baines <msb@google.com>
Subject: Re: [PATCH] hung_task_timeout: configurable default
Message-Id: <20110504150557.a7f4bf73.akpm@linux-foundation.org>
In-Reply-To: <4DB8600C.8080000@suse.com>
References: <4DB8600C.8080000@suse.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Apr 2011 14:27:24 -0400
Jeff Mahoney <jeffm@suse.com> wrote:

>  This patch allows the default value for sysctl_hung_task_timeout_secs
>  to be set at build time. The feature carries virtually no overhead,
>  so it makes sense to keep it enabled. On heavily loaded systems, though,
>  it can end up triggering stack traces when there is no bug other than
>  the system being underprovisioned. We use this patch to keep the hung task
>  facility available but disabled at boot-time.
> 
>  The default of 120 seconds is preserved. As a note, commit e162b39a may
>  have accidentally reverted commit fb822db4, which raised the default from
>  120 seconds to 480 seconds.

The changelog forgot to tell us why the patch's author considers the
patch to be needed.  This happens quite a lot.

> @@ -33,7 +33,8 @@ unsigned long __read_mostly sysctl_hung_
>  /*
>   * Zero means infinite timeout - no checking done:
>   */
> -unsigned long __read_mostly sysctl_hung_task_timeout_secs = 120;
> +unsigned long __read_mostly sysctl_hung_task_timeout_secs =
> +					CONFIG_DEFAULT_HUNG_TASK_TIMEOUT;
>  

For the life of me I can't understand why you distro guys need to keep
patching the kernel when you could just add a line to your initscripts.

I'm suspecting that lameness is involved.
