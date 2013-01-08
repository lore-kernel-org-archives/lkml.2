Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753387Ab3AHDBF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 22:01:05 -0500
Received: from mail-bk0-f42.google.com ([209.85.214.42]:46529 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753111Ab3AHDBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 22:01:04 -0500
MIME-Version: 1.0
In-Reply-To: <8762382z2c.fsf@xmission.com>
References: <1357260531-11115-1-git-send-email-yinghai@kernel.org>
	<1357260531-11115-27-git-send-email-yinghai@kernel.org>
	<CAKocOOP=jh2XOFJtoz-uHO2cvb9NRfOGdc05LKg1JH-ToiUwwA@mail.gmail.com>
	<CAE9FiQVKFz6K8xw2Eu5J8G6=QDdo2A7Y2-81GYP5yvP+T1YG5A@mail.gmail.com>
	<CAKocOOPqNPYU1dcDdHpKqMZtJnSOhT6tBGY7k4qGEy6uKSAr7Q@mail.gmail.com>
	<CAE9FiQVM-Rd82n-qhasDCA0+-n6TWH6m9Vm6N1nER__5p34z-Q@mail.gmail.com>
	<20130107152622.GD3219@phenom.dumpdata.com>
	<CAKocOOM9MYD8Z0-ha7NQP6B=J-eGS6uao5oAVfiO+i-a0TVy1A@mail.gmail.com>
	<8762382z2c.fsf@xmission.com>
Date: Mon, 7 Jan 2013 19:01:02 -0800
X-Google-Sender-Auth: dNiMO49iWkm4OLtNZPqYHKOEFI0
Message-ID: <CAE9FiQWeGKw0VEt5a74Sq3RQo6xBOreQ8Rf_O+B9HqSTHYJxBA@mail.gmail.com>
Subject: Re: [PATCH v7u1 26/31] x86: Don't enable swiotlb if there is not
 enough ram for it
From: Yinghai Lu <yinghai@kernel.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Shuah Khan <shuahkhan@gmail.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Jan Kiszka <jan.kiszka@web.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        linux-kernel@vger.kernel.org, Joerg Roedel <joro@8bytes.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 7, 2013 at 6:22 PM, Eric W. Biederman <ebiederm@xmission.com> wrote:
> Yinghai I sat down and read your patch and the approach you are taking
> is totally wrong.

Thanks for check the patch, did you check v3?

>
> The problem is that swiotlb_init() in lib/swiotlb.c does not know how to
> fail without panic'ing the system.

I did not put panic in swiotlb, now I put panic in amd_iommu ops init
when it need extra
swiotlb for unhandled devices by AMD IOMMU.

>
> Which leaves two valid approaches.
> - Create a variant of swiotlb_init that can fail for use on x86 and
>   handle the failure.
> - Delay initializing the swiotlb until someone actually needs a mapping
>   from it.
>
> Delaying the initialization of the swiotlb is out because the code
> needs an early memory allocation to get a large chunk of contiguous
> memory for the bounce buffers.

ok.

>
> Which means the panics that occurr in swiotlb_init() need to be delayed
> until someone something actually needs bounce buffers from the swiotlb.
>
> Although arguably what should actually happen instead of panic() is that
> swiotlb_map_single should simply fail early when it was not possible to
> preallocate bounce buffers.

do you mean: actually needed dma buffer is much less than swiotlb
buffer aka 64M?

Yinghai
