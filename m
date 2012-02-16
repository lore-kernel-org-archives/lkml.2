Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755983Ab2BPVfb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 16:35:31 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34808 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753665Ab2BPVf3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 16:35:29 -0500
Message-ID: <4F3D766E.7040205@zytor.com>
Date: Thu, 16 Feb 2012 13:34:38 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120131 Thunderbird/10.0
MIME-Version: 1.0
To: Markus Gutschke <markus@chromium.org>
CC: Will Drewry <wad@chromium.org>, linux-kernel@vger.kernel.org,
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
References: <1329422549-16407-1-git-send-email-wad@chromium.org> <1329422549-16407-3-git-send-email-wad@chromium.org> <4F3D61CB.2000301@zytor.com> <CABqD9hb3WxKxLZ2GuUrbDM--koW+a3ser5TU8y6+e0sAhOT9dw@mail.gmail.com> <4F3D7250.6040504@zytor.com> <CAE6n16kweRehdozft0tKOB1P5LtGFJDCLQP=2EXfm8P0enyH=A@mail.gmail.com>
In-Reply-To: <CAE6n16kweRehdozft0tKOB1P5LtGFJDCLQP=2EXfm8P0enyH=A@mail.gmail.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/16/2012 01:28 PM, Markus Gutschke wrote:
> 
> I think, the documentation said that as soon as prctl() is used to set
> a bpf filter for system calls, it automatically disallows system calls
> using an entry point other than the one used by this particular
> prctl().
> 
> I was trying to come up with scenarios where this particular approach
> causes problem, but I can't think of any off the top of my head. So,
> it might actually turn out to be a very elegant way to reduce the
> attack surface of the kernel. If we are really worried about userspace
> compatibility, we could make the kernel send a signal instead of
> terminating the program, if the wrong entry point was used; not sure
> if that is needed, though.
> 

Let's see... we're building an entire pattern-matching engine and then
randomly disallowing its use because we didn't build in the right bits?

Sorry, that's asinine.

Put the bloody bit in there and let the pattern program make that decision.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

