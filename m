Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933845Ab1IILzz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 07:55:55 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52427 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933622Ab1IILzy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 07:55:54 -0400
Message-ID: <4E69FEC9.2080204@suse.cz>
Date: Fri, 09 Sep 2011 13:55:53 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Kbuild: append missing-syscalls to the default target
 list
References: <1314234210-11090-1-git-send-email-lacombar@gmail.com>
In-Reply-To: <1314234210-11090-1-git-send-email-lacombar@gmail.com>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25.8.2011 03:03, Arnaud Lacombe wrote:
> This avoid an extra make invocation on `prepare0'.
> 
> Signed-off-by: Arnaud Lacombe <lacombar@gmail.com>
> ---
>  Kbuild   |    4 +++-
>  Makefile |    1 -
>  2 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/Kbuild b/Kbuild
> index 2114113..1a2eb32 100644
> --- a/Kbuild
> +++ b/Kbuild
> @@ -88,10 +88,12 @@ $(obj)/$(offsets-file): arch/$(SRCARCH)/kernel/asm-offsets.s Kbuild
>  # 3) Check for missing system calls
>  #
>  
> +always += missing-syscalls
> +targets += missing-syscalls
> +
>  quiet_cmd_syscalls = CALL    $<
>        cmd_syscalls = $(CONFIG_SHELL) $< $(CC) $(c_flags)

checksyscalls.sh needs to depend on generated/asm-offsets.h, otherwise a
parallel build will fail.

Michal

