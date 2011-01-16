Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754355Ab1APCc0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jan 2011 21:32:26 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:46047 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752975Ab1APCcZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jan 2011 21:32:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=QPQpLcGPNm6jM6V3SFOdxSkrxegIkX+BX7N0aWRPU0grnhujGxTOvUFdEZOf6p3mvK
         eoxVLQrLttd80urcsIZrxj9zlT9tE7yLXikGthkfZ1kz+5LjVyERGZsU9PFwcVrSRi/h
         30aZn9Qvipy1pt1optMNqmyh1mXwWHo16fsn4=
MIME-Version: 1.0
In-Reply-To: <20110115130913.GA27123@htj.dyndns.org>
References: <20110113224450.GA14918@kroah.com>
	<alpine.LFD.2.00.1101132349590.2678@localhost6.localdomain6>
	<4D2F84FC.7000804@kernel.org>
	<20110113234852.GB17904@kroah.com>
	<4D2F9948.8000804@kernel.org>
	<20110114004428.GA26847@kroah.com>
	<4D2FA305.2030808@kernel.org>
	<alpine.DEB.2.00.1101140846560.2423@router.home>
	<4D30BE98.7060809@kernel.org>
	<alpine.DEB.2.00.1101141527400.10415@router.home>
	<20110115130913.GA27123@htj.dyndns.org>
Date: Sat, 15 Jan 2011 18:32:23 -0800
X-Google-Sender-Auth: aMRr2-T0-lKYzrocJ3gm6Zkphv4
Message-ID: <AANLkTinSLfEU2D3U1Vkyk8REym=v2X6vWRwvUZ9mgzch@mail.gmail.com>
Subject: Re: [PATCH] x86: set percpu cpu0 lpj to default
From: Yinghai Lu <yinghai@kernel.org>
To: Tejun Heo <tj@kernel.org>
Cc: Christoph Lameter <cl@linux.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Greg KH <greg@kroah.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 15, 2011 at 5:09 AM, Tejun Heo <tj@kernel.org> wrote:
> Hello,
>
> It doesn't seem like Christoph's recent patches had anything to do
> with it.  The problem is the default loops_per_jiffy has initial value
> of 1 << 12 but the per cpu one used on x86 starts as zero triggering
> warning if delay is used before calibration.
>
> So, all that's necessary is just to initialize it with the same
> constant when defining the per cpu variable like the following.  It
> probably would be better to define a named constant for it tho.
>
> Thanks.
>
> diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
> index 763df77..1898c70 100644
> --- a/arch/x86/kernel/smpboot.c
> +++ b/arch/x86/kernel/smpboot.c
> @@ -131,7 +131,10 @@ DEFINE_PER_CPU(cpumask_var_t, cpu_core_map);
>  EXPORT_PER_CPU_SYMBOL(cpu_core_map);
>
>  /* Per CPU bogomips and other parameters */
> -DEFINE_PER_CPU_SHARED_ALIGNED(struct cpuinfo_x86, cpu_info);
> +DEFINE_PER_CPU_SHARED_ALIGNED(struct cpuinfo_x86, cpu_info) =
> +{
> +       .loops_per_jiffy        = 1 << 12,
> +};
>  EXPORT_PER_CPU_SYMBOL(cpu_info);
>
>  atomic_t init_deasserted;
>

yes, it should work.

Thanks

Yinghai
