Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759365Ab1D1KnN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 06:43:13 -0400
Received: from mtagate6.uk.ibm.com ([194.196.100.166]:60850 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758246Ab1D1KnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 06:43:09 -0400
Date: Thu, 28 Apr 2011 12:43:06 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Jan Beulich <JBeulich@novell.com>
Cc: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
        linux-arch@vger.kernel.org, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] allow placing exception table in .rodata (and do so on
	 x86)
Message-ID: <20110428104306.GC2431@osiris.boeblingen.de.ibm.com>
References: <4DB85404020000780003E6D7@vpn.id2.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DB85404020000780003E6D7@vpn.id2.novell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 27, 2011 at 04:36:04PM +0100, Jan Beulich wrote:
> This is since the table is really a set of pointers, i.e. misplaced in
> .text.
> 
> Quite likely other architectures would want to follow.
> 
> Signed-off-by: Jan Beulich <jbeulich@novell.com>
> 

[...]

> --- 2.6.39-rc5/include/asm-generic/vmlinux.lds.h
> +++ 2.6.39-rc5-extable-in-rodata/include/asm-generic/vmlinux.lds.h
> @@ -226,6 +226,7 @@
>  		*(.rodata1)						\
>  	}								\
>  									\
> +	EXCEPTION_TABLE_RO						\

That's odd. The kernel actually writes to it (sort_main_extable()), so
it shouldn't be in the ro data section, but the data section.

>  	JUMP_TABLE							\

same here.
