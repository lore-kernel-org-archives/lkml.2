Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754076Ab2AJGk3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 01:40:29 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:50569 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751184Ab2AJGk2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 01:40:28 -0500
MIME-Version: 1.0
In-Reply-To: <1325856086.17441.27.camel@osiris>
References: <1325856086.17441.27.camel@osiris>
Date: Tue, 10 Jan 2012 14:40:27 +0800
Message-ID: <CAGyNYUO0WGXgN50AXW08Hec97TM-PRm4iNQR5gZ+=wdRz1KUgQ@mail.gmail.com>
Subject: Re: [PATCH] score: fix off-by-one index into syscall table
From: Eugene Teo <eugeneteo@kernel.sg>
To: Dan Rosenberg <drosenberg@vsecurity.com>
Cc: liqin.chen@sunplusct.com, lennox.wu@gmail.com,
        linux-kernel@vger.kernel.org, security@kernel.org, arnd@arndb.de
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc'ed arnd@arndb.de

ping

On Fri, Jan 6, 2012 at 9:21 PM, Dan Rosenberg <drosenberg@vsecurity.com> wrote:
> If the provided system call number is equal to __NR_syscalls, the
> current check will pass and a function pointer just after the system
> call table may be called, since sys_call_table is an array with total
> size __NR_syscalls.  Whether or not this is a security bug depends on
> what the compiler puts immediately after the system call table.  It's
> likely that this won't do anything bad because there is an additional
> NULL check on the syscall entry, but if there happens to be a non-NULL
> value immediately after the system call table, this may result in local
> privilege escalation.
>
> Signed-off-by: Dan Rosenberg <drosenberg@vsecurity.com>
> Cc: stable@kernel.org
> Cc: security@kernel.org
> ---
>  arch/score/kernel/entry.S |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/arch/score/kernel/entry.S b/arch/score/kernel/entry.S
> index 577abba..83bb960 100644
> --- a/arch/score/kernel/entry.S
> +++ b/arch/score/kernel/entry.S
> @@ -408,7 +408,7 @@ ENTRY(handle_sys)
>        sw      r9, [r0, PT_EPC]
>
>        cmpi.c  r27, __NR_syscalls      # check syscall number
> -       bgtu    illegal_syscall
> +       bgeu    illegal_syscall
>
>        slli    r8, r27, 2              # get syscall routine
>        la      r11, sys_call_table
>
>
