Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754738Ab0FNQAQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 12:00:16 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:34954 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751401Ab0FNQAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 12:00:14 -0400
Subject: Re: [PATCH 4/5] parisc: Remove *(.text.*) pattern from the linker
 script
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: linux-arch@vger.kernel.org, Kyle McMartin <kyle@mcmartin.ca>,
       linux-kernel@vger.kernel.org,
       Parisc List <linux-parisc@vger.kernel.org>
In-Reply-To: <1276519112-11649-4-git-send-email-matt@console-pimps.org>
References: <1276519112-11649-1-git-send-email-matt@console-pimps.org>
	 <1276519112-11649-4-git-send-email-matt@console-pimps.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 Jun 2010 10:20:59 -0500
Message-ID: <1276528859.5374.29.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-06-14 at 13:38 +0100, Matt Fleming wrote:
> From: Matt Fleming <matthew.fleming@imgtec.com>
> 
> Drop the pattern from the linker script because the pattern is now
> provided by TEXT_TEXT.
> 
> Signed-off-by: Matt Fleming <matthew.fleming@imgtec.com>
> ---
>  arch/parisc/kernel/vmlinux.lds.S |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/parisc/kernel/vmlinux.lds.S b/arch/parisc/kernel/vmlinux.lds.S
> index d64a6bb..6784e39 100644
> --- a/arch/parisc/kernel/vmlinux.lds.S
> +++ b/arch/parisc/kernel/vmlinux.lds.S
> @@ -61,7 +61,6 @@ SECTIONS
>  		*(.text.sys_exit)
>  		*(.text.do_sigaltstack)
>  		*(.text.do_fork)
> -		*(.text.*)
>  		*(.fixup)
>  		*(.lock.text)		/* out-of-line lock text */
>  		*(.gnu.warning)


This would destroy all of the named parisc text ordering we do above the
removed line because now you'd have swept up all the function sections
before we get to them, won't it?

The ordering is an execution speed up on 32 bit systems because our
relative jump is so short.

James


