Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755297Ab2BQAvF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 19:51:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54479 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751601Ab2BQAvB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 19:51:01 -0500
Message-ID: <1329439809.2337.32.camel@localhost>
Subject: Re: [PATCH v8 3/8] seccomp: add system call filtering using BPF
From: Eric Paris <eparis@redhat.com>
To: Will Drewry <wad@chromium.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Markus Gutschke <markus@chromium.org>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-doc@vger.kernel.org, kernel-hardening@lists.openwall.com,
        netdev@vger.kernel.org, x86@kernel.org, arnd@arndb.de,
        davem@davemloft.net, mingo@redhat.com, oleg@redhat.com,
        peterz@infradead.org, rdunlap@xenotime.net, mcgrathr@chromium.org,
        tglx@linutronix.de, luto@mit.edu, serge.hallyn@canonical.com,
        djm@mindrot.org, scarybeasts@gmail.com, indan@nul.nu,
        pmoore@redhat.com, akpm@linux-foundation.org, corbet@lwn.net,
        eric.dumazet@gmail.com, keescook@chromium.org
Date: Thu, 16 Feb 2012 19:50:09 -0500
In-Reply-To: <CABqD9hZd41AWZub+wxGWwxJtGWfk+pVWQhn7DM_0q0tS9r_wDA@mail.gmail.com>
References: <1329422549-16407-1-git-send-email-wad@chromium.org>
	 <1329422549-16407-3-git-send-email-wad@chromium.org>
	 <4F3D61CB.2000301@zytor.com>
	 <CABqD9hb3WxKxLZ2GuUrbDM--koW+a3ser5TU8y6+e0sAhOT9dw@mail.gmail.com>
	 <4F3D7250.6040504@zytor.com>
	 <CAE6n16kweRehdozft0tKOB1P5LtGFJDCLQP=2EXfm8P0enyH=A@mail.gmail.com>
	 <4F3D766E.7040205@zytor.com>
	 <CABqD9haWxRLac1w3m9rSmyDvcg8jxYcxdmAAsgB7pEEBMHr=2g@mail.gmail.com>
	 <4F3D7DD4.6070103@zytor.com>
	 <CABqD9hZd41AWZub+wxGWwxJtGWfk+pVWQhn7DM_0q0tS9r_wDA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-02-16 at 17:00 -0600, Will Drewry wrote:
> On Thu, Feb 16, 2012 at 4:06 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> > On 02/16/2012 01:51 PM, Will Drewry wrote:

> Then syscall_namespace(current, regs) returns
> * 0 - SYSCALL_NS_32 (for existing 32 and config_compat)
> * 1 - SYSCALL_NS_64 (for existing 64 bit)
> * 2 - SYSCALL_NS_X32 (everything after 2 is arch specific)
> * ..
> 
> This patch series is pegged to x86 right now, so it's not a big deal
> to add a simple syscall_namespace to asm/syscall.h.  Of course, the
> code is always the easy part.  Even easier would be to only assign 0
> and 1 in the seccomp_data for 32-bit or 64-bit, then leave the rest of
> the u32 untouched until x32 stabilizes and the TS_COMPAT interactions
> are sorted.

I don't know if anyone cares, but include/linux/audit.h tries to expose
this type of information so audit userspace can later piece things back
together.  (we get this info from the syscall entry exit code so we know
which arch it is).

Not sure how x32 is hoping to expose its syscall info, but others are
going to have the same/similar problem.

-Eric

