Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756964Ab2GFViw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 17:38:52 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:55775 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755486Ab2GFViv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 17:38:51 -0400
MIME-Version: 1.0
In-Reply-To: <4FF70EFC020000780008E195@nat28.tlf.novell.com>
References: <4FF70EFC020000780008E195@nat28.tlf.novell.com>
Date: Fri, 6 Jul 2012 14:38:50 -0700
X-Google-Sender-Auth: flUXnwc7BjVPvx-7rIHz9RmKx6s
Message-ID: <CAE9FiQUNC2e03k=ECkQQU4732mGL-xidDyauAy0CdWjDg=EG8Q@mail.gmail.com>
Subject: Re: [PATCH] x86: adjust generic_get_mtrr() for 64-bit
From: Yinghai Lu <yinghai@kernel.org>
To: Jan Beulich <JBeulich@suse.com>
Cc: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 6, 2012 at 7:14 AM, Jan Beulich <JBeulich@suse.com> wrote:
> Needing to deal with potentially large memory configurations, the
> variables here should be "unsigned long" instead of "unsigned int".
>
> Signed-off-by: Jan Beulich <jbeulich@suse.com>
>
> ---
>  arch/x86/kernel/cpu/mtrr/generic.c |    8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> --- 3.5-rc5/arch/x86/kernel/cpu/mtrr/generic.c
> +++ 3.5-rc5-x86-mtrr-generic-types/arch/x86/kernel/cpu/mtrr/generic.c
> @@ -514,8 +514,8 @@ generic_get_free_region(unsigned long ba
>  static void generic_get_mtrr(unsigned int reg, unsigned long *base,
>                              unsigned long *size, mtrr_type *type)
>  {
> -       unsigned int mask_lo, mask_hi, base_lo, base_hi;
> -       unsigned int tmp, hi;
> +       unsigned long mask_lo, mask_hi, base_lo, base_hi, tmp;
> +       unsigned int hi;

_lo, _hi means we want it as 32bit.

or we just change them to u32 to make it more clear ?

Thanks

Yinghai
