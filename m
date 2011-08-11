Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753245Ab1HKTKW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 15:10:22 -0400
Received: from merlin.infradead.org ([205.233.59.134]:51050 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984Ab1HKTKV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 15:10:21 -0400
Subject: Re: [PATCH v6 1/2] Track hard and soft "short lockups" or "stalls."
From: Peter Zijlstra <peterz@infradead.org>
To: Alex Neronskiy <zakmagnus@chromium.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Don Zickus <dzickus@redhat.com>,
        Mandeep Singh Baines <msb@chromium.org>,
        Alex Neronskiy <zakmagnus@chromium.com>
Date: Thu, 11 Aug 2011 21:09:56 +0200
In-Reply-To: <1312999364-21104-1-git-send-email-zakmagnus@chromium.org>
References: <1312999364-21104-1-git-send-email-zakmagnus@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1313089796.8491.14.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-08-10 at 11:02 -0700, Alex Neronskiy wrote:
> @@ -767,7 +767,23 @@ static struct ctl_table kern_table[] = {
>                 .extra1         = &zero,
>                 .extra2         = &one,
>         },
> -#endif
> +       {
> +               .procname       = "softstall_worst",
> +               .data           = &worst_softstall,
> +               .maxlen         = sizeof(unsigned long),
> +               .mode           = 0644,
> +               .proc_handler   = proc_doulongvec_minmax,
> +       },
> +#ifdef CONFIG_HARDLOCKUP_DETECTOR
> +       {
> +               .procname       = "hardstall_worst",
> +               .data           = &worst_hardstall,
> +               .maxlen         = sizeof(unsigned long),
> +               .mode           = 0644,
> +               .proc_handler   = proc_doulongvec_minmax,
> +       },
> +#endif /* CONFIG_HARDLOCKUP_DETECTOR */
> +#endif /* CONFIG_LOCKUP_DETECTOR */ 

And patch 2 does:


> +++ b/kernel/sysctl.c
> @@ -767,22 +767,6 @@ static struct ctl_table kern_table[] = {
>                 .extra1         = &zero,
>                 .extra2         = &one,
>         },
> -       {
> -               .procname       = "softstall_worst",
> -               .data           = &worst_softstall,
> -               .maxlen         = sizeof(unsigned long),
> -               .mode           = 0644,
> -               .proc_handler   = proc_doulongvec_minmax,
> -       },
> -#ifdef CONFIG_HARDLOCKUP_DETECTOR
> -       {
> -               .procname       = "hardstall_worst",
> -               .data           = &worst_hardstall,
> -               .maxlen         = sizeof(unsigned long),
> -               .mode           = 0644,
> -               .proc_handler   = proc_doulongvec_minmax,
> -       },
> -#endif /* CONFIG_HARDLOCKUP_DETECTOR */
>  #endif /* CONFIG_LOCKUP_DETECTOR */
> 

Makes one wonder wtf patch 1 exists for..
