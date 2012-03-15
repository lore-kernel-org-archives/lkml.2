Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761397Ab2COSeJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 14:34:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43680 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758833Ab2COSeE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 14:34:04 -0400
Subject: Re: [PATCH] Fix c6x's entry.S
From: Mark Salter <msalter@redhat.com>
To: David Howells <dhowells@redhat.com>
Cc: a-jacquiot@ti.com, linux-c6x-dev@linux-c6x.org,
        linux-kernel@vger.kernel.org
Date: Thu, 15 Mar 2012 14:34:00 -0400
In-Reply-To: <20120315175222.32354.43890.stgit@warthog.procyon.org.uk>
References: <20120315175222.32354.43890.stgit@warthog.procyon.org.uk>
Organization: Red Hat, Inc
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-ID: <1331836441.2985.20.camel@deneb.redhat.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-03-15 at 17:52 +0000, David Howells wrote:
> The ENDPROC() on sys_fadvise64_c6x() in arch/c6x/kernel/entry.S needs to be
> transposed with the preceding #endif so that it's in the same conditional
> block as the matching ENTRY() macro.
> 
> Without this, I see:
> 
> /tmp/ccGZBaPT.s: Assembler messages:
> /tmp/ccGZBaPT.s: Error: .size expression for sys_fadvise64_c6x does not evaluate to a constant
> 
> Signed-off-by: David Howells <dhowells@redhat.com>
> ---
> 
>  arch/c6x/kernel/entry.S |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/c6x/kernel/entry.S b/arch/c6x/kernel/entry.S
> index 3e977cc..91b2e79 100644
> --- a/arch/c6x/kernel/entry.S
> +++ b/arch/c6x/kernel/entry.S
> @@ -741,8 +741,8 @@ ENTRY(sys_fadvise64_c6x)
>  #endif
>  	MV	.D1X	B6,A6
>  	MV	.D2X	A8,B6
> -#endif
>  ENDPROC(sys_fadvise64_c6x)
> +#endif

Thanks! Actually, I'll delete sys_fadvise64_c6x altogether. It is 
leftover cruft since we no longer support __ARCH_WANT_SYSCALL_OFF_T.

As an aside, the build tools I'm using didn't catch that. I definitely
need to upgrade...

--Mark


