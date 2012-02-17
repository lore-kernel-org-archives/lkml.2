Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756505Ab2BQCX2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 21:23:28 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36479 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754770Ab2BQCX0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 21:23:26 -0500
Message-ID: <4F3DB9E8.7040406@zytor.com>
Date: Thu, 16 Feb 2012 18:22:32 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120131 Thunderbird/10.0
MIME-Version: 1.0
To: Andrew Lutomirski <luto@mit.edu>
CC: Indan Zupancic <indan@nul.nu>, Will Drewry <wad@chromium.org>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-doc@vger.kernel.org, kernel-hardening@lists.openwall.com,
        netdev@vger.kernel.org, x86@kernel.org, arnd@arndb.de,
        davem@davemloft.net, mingo@redhat.com, oleg@redhat.com,
        peterz@infradead.org, rdunlap@xenotime.net, mcgrathr@chromium.org,
        tglx@linutronix.de, eparis@redhat.com, serge.hallyn@canonical.com,
        djm@mindrot.org, scarybeasts@gmail.com, pmoore@redhat.com,
        akpm@linux-foundation.org, corbet@lwn.net, eric.dumazet@gmail.com,
        markus@chromium.org, keescook@chromium.org
Subject: Re: [PATCH v8 3/8] seccomp: add system call filtering using BPF
References: <1329422549-16407-1-git-send-email-wad@chromium.org> <1329422549-16407-3-git-send-email-wad@chromium.org> <4F3D61CB.2000301@zytor.com> <CABqD9hb3WxKxLZ2GuUrbDM--koW+a3ser5TU8y6+e0sAhOT9dw@mail.gmail.com> <4F3D7250.6040504@zytor.com> <501858544d264abc6526f2b25a224f2b.squirrel@webmail.greenhost.nl> <4F3DAE5D.3080000@zytor.com> <f2d1a14c965cea740d688c574c6006bb.squirrel@webmail.greenhost.nl> <CAObL_7GUTbc=Ew9mQw7CoWfdAfRWSWUrY3w+UnrYrqWEiHxtcQ@mail.gmail.com>
In-Reply-To: <CAObL_7GUTbc=Ew9mQw7CoWfdAfRWSWUrY3w+UnrYrqWEiHxtcQ@mail.gmail.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/16/2012 06:16 PM, Andrew Lutomirski wrote:
> 
> Is there really no syscall that cares about endianness?
> 
> Even if it ends up working, forcing syscall arguments to have a
> particular endianness seems like a bad decision, especially if anyone
> ever wants to make a 64-bit BPF implementation.  (Or if any
> architecture adds 128-bit syscall arguments to a future syscall
> namespace or whatever it's called.  x86-64 has 128-bit xmm
> registers...)
> 

Not to mention that the reshuffling code will add totally unnecessary
cost to the normal operation.  Either way, Indan has it backwards ... it
*is* one field, the fact that two operations is needed to access it is a
function of the underlying byte code, and even if the byte code can't
support it, a JIT could merge adjacent operations if 64-bit operations
are possible -- or we could (and arguably should) add 64-bit opcodes in
the future for efficiency.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

