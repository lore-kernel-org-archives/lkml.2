Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753013Ab2BVGeL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 01:34:11 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48569 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751731Ab2BVGeJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 01:34:09 -0500
Message-ID: <4F448C13.1040407@zytor.com>
Date: Tue, 21 Feb 2012 22:32:51 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120131 Thunderbird/10.0
MIME-Version: 1.0
To: Will Drewry <wad@chromium.org>
CC: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-doc@vger.kernel.org, kernel-hardening@lists.openwall.com,
        netdev@vger.kernel.org, x86@kernel.org, arnd@arndb.de,
        davem@davemloft.net, mingo@redhat.com, oleg@redhat.com,
        peterz@infradead.org, rdunlap@xenotime.net, mcgrathr@chromium.org,
        tglx@linutronix.de, luto@mit.edu, eparis@redhat.com,
        serge.hallyn@canonical.com, djm@mindrot.org, scarybeasts@gmail.com,
        indan@nul.nu, pmoore@redhat.com, akpm@linux-foundation.org,
        corbet@lwn.net, eric.dumazet@gmail.com, markus@chromium.org,
        keescook@chromium.org
Subject: Re: [PATCH v10 05/11] seccomp: add system call filtering using BPF
References: <1329845435-2313-1-git-send-email-wad@chromium.org> <1329845435-2313-5-git-send-email-wad@chromium.org>
In-Reply-To: <1329845435-2313-5-git-send-email-wad@chromium.org>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/21/2012 09:30 AM, Will Drewry wrote:
> +
> +/**
> + * struct seccomp_data - the format the BPF program executes over.
> + * @args: up to 6 system call arguments.  When the calling convention is
> + *        32-bit, the arguments will still be at each args[X] offset.
> + * @instruction_pointer: at the time of the system call.
> + * @arch: indicates system call convention as an AUDIT_ARCH_* value
> + *        as defined in <linux/audit.h>.
> + * @nr: the system call number
> + */
> +struct seccomp_data {
> +	__u64 args[6];
> +	__u64 instruction_pointer;
> +	__u32 arch;
> +	int nr;
> +};
>  

This got flipped around for some reason... that is a problem if we ever
need to extend this to more than 6 arguments (I thought we had at least
one architecture which supported 7 arguments already, but I could just
be delusional.)

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

