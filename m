Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758364Ab2AEVoF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 16:44:05 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:44644 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101Ab2AEVoC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 16:44:02 -0500
MIME-Version: 1.0
In-Reply-To: <20120105181753.GH5650@redhat.com>
References: <1318533267-18880-2-git-send-email-dzickus@redhat.com>
	<tip-3603a2512f9e69dc87914ba922eb4a0812b21cd6@git.kernel.org>
	<CAE9FiQWX_2bV1phLCUrEpiPSfo24xWEv3Y+DZnwmi9JJgJHbmQ@mail.gmail.com>
	<20111221145928.GP5650@redhat.com>
	<CAE9FiQUW5tf5-Fbn0a_8s58P+7rXbG6iWPaDeHOuhxw4TZE+hQ@mail.gmail.com>
	<20120105181753.GH5650@redhat.com>
Date: Thu, 5 Jan 2012 13:44:01 -0800
X-Google-Sender-Auth: WCnWTo-w7DwkFWyXadzY5N7D9EU
Message-ID: <CAE9FiQWyYAv3TjEv92WXoe6zNGm-CbXAvfzwupmFEWDJBLXeBQ@mail.gmail.com>
Subject: Re: [tip:x86/debug] x86, reboot: Use NMI instead of REBOOT_VECTOR to
 stop cpus
From: Yinghai Lu <yinghai@kernel.org>
To: Don Zickus <dzickus@redhat.com>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        andi@firstfloor.org, torvalds@linux-foundation.org,
        peterz@infradead.org, robert.richter@amd.com, tglx@linutronix.de,
        mingo@elte.hu, linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Don Zickus <dzickus@redhat.com>
> Date: Thu, 5 Jan 2012 13:06:58 -0500
> Subject: [PATCH] x86, reboot: typo in nmi reboot path
>
> It was brought to my attention that my x86 change to use NMI in the
> reboot path broke Intel Nehalem and Westmere boxes when using kexec.
>
> I realized I had mistyped the if statement in commit
> 3603a2512f9e69dc87914ba922eb4a0812b21cd6 and stuck the ')' in
> the wrong spot.  Putting it in the right spot fixes kexec again.
>
> Doh.
>
> Reported-by: Yinghai Lu <yinghai@kernel.org>
> Signed-off-by: Don Zickus <dzickus@redhat.com>

Tested-by: Yinghai Lu <yinghai@kernel.org>

> ---
>  arch/x86/kernel/smp.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
> index e72b175..3f3d3f0 100644
> --- a/arch/x86/kernel/smp.c
> +++ b/arch/x86/kernel/smp.c
> @@ -176,7 +176,7 @@ static void native_nmi_stop_other_cpus(int wait)
>         */
>        if (num_online_cpus() > 1) {
>                /* did someone beat us here? */
> -               if (atomic_cmpxchg(&stopping_cpu, -1, safe_smp_processor_id() != -1))
> +               if (atomic_cmpxchg(&stopping_cpu, -1, safe_smp_processor_id()) != -1)
>                        return;
>
>                if (register_nmi_handler(NMI_LOCAL, smp_stop_nmi_callback,
> --
> 1.7.7.4
>
