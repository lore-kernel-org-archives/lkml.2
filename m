Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754018Ab2B0RTR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 12:19:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4042 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753534Ab2B0RTP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 12:19:15 -0500
Date: Mon, 27 Feb 2012 18:11:32 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Will Drewry <wad@chromium.org>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-doc@vger.kernel.org, kernel-hardening@lists.openwall.com,
        netdev@vger.kernel.org, x86@kernel.org, arnd@arndb.de,
        davem@davemloft.net, hpa@zytor.com, mingo@redhat.com,
        peterz@infradead.org, rdunlap@xenotime.net, mcgrathr@chromium.org,
        tglx@linutronix.de, luto@mit.edu, eparis@redhat.com,
        serge.hallyn@canonical.com, djm@mindrot.org, scarybeasts@gmail.com,
        indan@nul.nu, pmoore@redhat.com, akpm@linux-foundation.org,
        corbet@lwn.net, eric.dumazet@gmail.com, markus@chromium.org,
        coreyb@linux.vnet.ibm.com, keescook@chromium.org
Subject: Re: [PATCH v11 07/12] seccomp: add SECCOMP_RET_ERRNO
Message-ID: <20120227171132.GB10608@redhat.com>
References: <1330140111-17201-1-git-send-email-wad@chromium.org> <1330140111-17201-7-git-send-email-wad@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1330140111-17201-7-git-send-email-wad@chromium.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/24, Will Drewry wrote:
>
>  static u32 seccomp_run_filters(int syscall)
>  {
>  	struct seccomp_filter *f;
> -	u32 ret = SECCOMP_RET_KILL;
>  	static const struct bpf_load_fn fns = {
>  		bpf_load,
>  		sizeof(struct seccomp_data),
>  	};
> +	u32 ret = SECCOMP_RET_ALLOW;
>  	const void *sc_ptr = (const void *)(uintptr_t)syscall;
>  
> +	/* Ensure unexpected behavior doesn't result in failing open. */
> +	if (unlikely(current->seccomp.filter == NULL))
> +		ret = SECCOMP_RET_KILL;

Is "seccomp.filter == NULL" really possible?

Oleg.

