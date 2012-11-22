Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758357Ab2KVWWW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 17:22:22 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36842 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754411Ab2KVSiP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:38:15 -0500
Message-ID: <50AE70E7.6060204@zytor.com>
Date: Thu, 22 Nov 2012 10:37:27 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121029 Thunderbird/16.0.2
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org, Rob Landley <rob@landley.net>,
        Matt Fleming <matt.fleming@intel.com>
Subject: Re: [PATCH v3 11/12] x86, boot: add fields to support load bzImage
 and ramdisk high
References: <1353482170-10160-1-git-send-email-yinghai@kernel.org> <1353482170-10160-12-git-send-email-yinghai@kernel.org> <50AD0CA1.8000904@zytor.com> <CAE9FiQUSjRT-r5ZE3WHVaKkUOhwFWkm9CTCv1Aa63DOsfMQMiQ@mail.gmail.com> <50AD291A.10600@zytor.com> <CAE9FiQVed0tXhbtmc_Gug0gFZ=s=j=N4B5Vr2_ZTmSj6L-65dw@mail.gmail.com> <a1ca794a-09d4-4d36-8c8c-67100cb3696e@email.android.com> <CAE9FiQXJO8uxT9Gzjv9e8XeiLzwBX7fwTFzDVy=oPfboG4L=3Q@mail.gmail.com> <CAE9FiQWeGz2TkLBrBZcoPrNABx51XK3xk58P+Zam_LRGoJdSiw@mail.gmail.com> <a8b15bf0-4e3b-4fde-9190-26890f9abf77@email.android.com> <CAE9FiQUoj9k0Tbqp8LC8Wb21_s_x8naiWX4zkX9pJG-oFnAQ9g@mail.gmail.com>
In-Reply-To: <CAE9FiQUoj9k0Tbqp8LC8Wb21_s_x8naiWX4zkX9pJG-oFnAQ9g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/22/2012 10:28 AM, Yinghai Lu wrote:
>
> has problem with old kexec, it only copy header from bzImage include
> setup_header as boot_param.
>

How old are we talking here? This is a clear and blatant bug, and it 
would affect a whole bunch of things, not just this.  In fact, one 
really has to wonder how it can work at all.

One option I guess would be to have a sentinel field which, if it is not 
zero, causes the kernel to zero all of struct setup_info outside of 
setup_header... however, I have a nasty suspicion that this kexec botch 
might be initializing some fields and leaving others unmodified, which 
basically means "there is no hope for sanity and it is just working by 
pure accident."

Eric, do you have any insight here?

> looks we only can use [0x30,0x3c), [0x1e8, 0x1f0), but in boot_params, they
> are apm_bios_info, and alt_mem_k...

... which I suspect get set by said kexec botch.

> so looks we still have to use setup_header instead.

We need to dig into this and either say "this is unsupportable" or put 
in some kind of hack.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

