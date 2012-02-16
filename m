Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754581Ab2BPWHE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 17:07:04 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35078 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753981Ab2BPWHA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 17:07:00 -0500
Message-ID: <4F3D7DD4.6070103@zytor.com>
Date: Thu, 16 Feb 2012 14:06:12 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120131 Thunderbird/10.0
MIME-Version: 1.0
To: Will Drewry <wad@chromium.org>
CC: Markus Gutschke <markus@chromium.org>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, linux-doc@vger.kernel.org,
        kernel-hardening@lists.openwall.com, netdev@vger.kernel.org,
        x86@kernel.org, arnd@arndb.de, davem@davemloft.net, mingo@redhat.com,
        oleg@redhat.com, peterz@infradead.org, rdunlap@xenotime.net,
        mcgrathr@chromium.org, tglx@linutronix.de, luto@mit.edu,
        eparis@redhat.com, serge.hallyn@canonical.com, djm@mindrot.org,
        scarybeasts@gmail.com, indan@nul.nu, pmoore@redhat.com,
        akpm@linux-foundation.org, corbet@lwn.net, eric.dumazet@gmail.com,
        keescook@chromium.org
Subject: Re: [PATCH v8 3/8] seccomp: add system call filtering using BPF
References: <1329422549-16407-1-git-send-email-wad@chromium.org> <1329422549-16407-3-git-send-email-wad@chromium.org> <4F3D61CB.2000301@zytor.com> <CABqD9hb3WxKxLZ2GuUrbDM--koW+a3ser5TU8y6+e0sAhOT9dw@mail.gmail.com> <4F3D7250.6040504@zytor.com> <CAE6n16kweRehdozft0tKOB1P5LtGFJDCLQP=2EXfm8P0enyH=A@mail.gmail.com> <4F3D766E.7040205@zytor.com> <CABqD9haWxRLac1w3m9rSmyDvcg8jxYcxdmAAsgB7pEEBMHr=2g@mail.gmail.com>
In-Reply-To: <CABqD9haWxRLac1w3m9rSmyDvcg8jxYcxdmAAsgB7pEEBMHr=2g@mail.gmail.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/16/2012 01:51 PM, Will Drewry wrote:
>>
>> Put the bloody bit in there and let the pattern program make that decision.
> 
> Easy enough to add a bit for the mode: 32-bit or 64-bit.  It seemed
> like a waste of cycles for every 32-bit program or every 64-bit
> program to check to see that its calling convention hadn't changed,
> but it does take away a valid decision the pattern program should be
> making.
> 
> I'll add a flag for 32bit/64bit while cleaning up seccomp_data. I
> think that will properly encapsulate the is_compat_task() behavior in
> a way that is stable for compat and non-compat tasks to use.  If
> there's a more obvious way, I'm all ears.
> 

is_compat_task() is not going to be the right thing for x86 going
forward, as we're introducing the x32 ABI (which uses the normal x86-64
entry point, but with different eax numbers, and bit 30 set.)

The actual state is the TS_COMPAT flag in the thread_info structure,
which currently matches is_compat_task(), but perhaps we should add a
new helper function syscall_namespace() or something like that...

Either that or we can just use another bit in the syscall number field...

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

