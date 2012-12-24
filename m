Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753462Ab2LXX4w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2012 18:56:52 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34823 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753377Ab2LXX4v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2012 18:56:51 -0500
Message-ID: <50D8EBB3.5040408@zytor.com>
Date: Mon, 24 Dec 2012 15:56:35 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 00/27] x86, boot, 64bit: Add support for loading ramdisk
 and bzImage above 4G
References: <1355814959-10573-1-git-send-email-yinghai@kernel.org> <20121222024225.GG3468@phenom.dumpdata.com> <eee81bb9-f11b-4ff8-8a84-72f122766fd8@email.android.com> <20121222132419.GB2936@phenom.dumpdata.com> <CAE9FiQV5QqONiTdnHzsjVRTbnEfyHEE3s=-=+a49F2a5se7K+A@mail.gmail.com> <6214ad82-5b7e-47f2-a9c1-98972bdee517@email.android.com> <CAE9FiQV-7_wz1jCZh3qDGt6Wq_JN6b1oAyjj3+goCPFnYZ+q9Q@mail.gmail.com>
In-Reply-To: <CAE9FiQV-7_wz1jCZh3qDGt6Wq_JN6b1oAyjj3+goCPFnYZ+q9Q@mail.gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/23/2012 10:00 AM, Yinghai Lu wrote:
> On Sun, Dec 23, 2012 at 6:33 AM, H. Peter Anvin <hpa@zytor.com> wrote:
>> Explanation please?
>>
> 
> you have following change in the patch
> 
>         /* Finally jump to run C code and to be on real kernel address
>          * Since we are running on identity-mapped space we have to jump
>          * to the full 64bit address, this is only possible as indirect
>          * jump.  In addition we need to ensure %cs is set so we make this
> -        * a far return.
> +        * a far jump.
>          */
> -       movq    initial_code(%rip),%rax
>         pushq   $0              # fake return address to stop unwinder
> -       pushq   $__KERNEL_CS    # set correct cs
> -       pushq   %rax            # target address in negative space
> -       lretq
> +       /* gas 2.22 is buggy and mis-assembles ljmpq */
> +       rex64 ljmp *initial_code(%rip)
> 
>  #ifdef CONFIG_HOTPLUG_CPU
>  /*
> 
> remove that change, AMD systems works again.
> 

That is not an explanation.

	-hpa


