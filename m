Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756421Ab0ERBgN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 21:36:13 -0400
Received: from smtp-out.google.com ([216.239.44.51]:11278 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754422Ab0ERBgJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 21:36:09 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=l38NAti0FP7hy90xIXa+y/WGktedc5F0fxMlhuXYwaea9ikaF0TZcJ3Xx3gFUYrCg
	fxstbSy81VrbQ+yxvWkkg==
MIME-Version: 1.0
In-Reply-To: <1273937267-11794-1-git-send-email-leonardoaltt@gmail.com>
References: <1273937267-11794-1-git-send-email-leonardoaltt@gmail.com>
Date: Mon, 17 May 2010 18:36:04 -0700
Message-ID: <AANLkTinM4wfyQA0x_MvwS6CLTtu6ydV3EciFI5wgTPWB@mail.gmail.com>
Subject: Re: [PATCH] x86, hpet.c: Changed delayed_work to work when delay is 0
From: Venkatesh Pallipadi <venki@google.com>
To: =?ISO-8859-1?Q?Leonardo_de_S=E1_Alt?= <leonardoaltt@gmail.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for sending the patch.
A comment below.

On Sat, May 15, 2010 at 8:27 AM, Leonardo de Sá Alt
<leonardoaltt@gmail.com> wrote:
> Here a delayed_work was used with delay 0, so it was changed to work.
> It avoids a timer set up and the work is directly queued, providing
> less use of memory and more performance.
>
> Signed-off-by: Leonardo de Sá Alt <leonardoaltt@gmail.com>
>
> ---
>  arch/x86/kernel/hpet.c |    6 ++----
>  1 files changed, 2 insertions(+), 4 deletions(-)
>
> diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
> index a198b7c..4516ba1 100644
> --- a/arch/x86/kernel/hpet.c
> +++ b/arch/x86/kernel/hpet.c
> @@ -724,12 +724,10 @@ static int hpet_cpuhp_notify(struct notifier_block *n,
>
>        switch (action & 0xf) {
>        case CPU_ONLINE:
> -               INIT_DELAYED_WORK_ON_STACK(&work.work, hpet_work);
> +               INIT_WORK_ON_STACK(&work.work.work, hpet_work);

Can you also change work in hpet_work_struct to work_struct. That
should make things a bit more cleaner.

Thanks,
Venki
