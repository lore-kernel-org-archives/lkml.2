Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757995Ab1ANSua (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 13:50:30 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52872 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752540Ab1ANSu2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 13:50:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=TDAzWn4TloHegj+jOdD9V5CqKVCtcuViexD/lh2VyDFIDE84EWGpjYkF5xh7YfZ0kx
         LlD7fBZ7eT8emKcawpq4vD9qvi9oYYETYl6nBpWmhYEe1MdVdp7TV2QSTi9K+4Meko5Q
         cHM+wq16Sz/Q4CiFsMG/+BfffycT4Q7ozJuN8=
MIME-Version: 1.0
In-Reply-To: <20110114183058.GN9506@random.random>
References: <4d308cf5394566ccc@agluck-desktop.sc.intel.com>
	<20110114183058.GN9506@random.random>
Date: Fri, 14 Jan 2011 10:50:26 -0800
X-Google-Sender-Auth: a0VyQ4cOGWPWnFAeEIyCc06brEQ
Message-ID: <AANLkTinpg9pWWas8+UngC=sRruxM6KASDPZtE6MmV=xp@mail.gmail.com>
Subject: Re: ia64 broken by transparent huge pages - other arches too?
From: Tony Luck <tony.luck@intel.com>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        linux-arch@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 14, 2011 at 10:30 AM, Andrea Arcangeli <aarcange@redhat.com> wrote:
> Would you be willing to implement __pmd for ia64 to fix this? Can you
> check if this works?
>
> Thanks a lot,
> Andrea
>
> ========
> Subject: fix ia64 build failure in pmdp_get_and_clear
>
> From: Andrea Arcangeli <aarcange@redhat.com>
>
> Implement __pmd macro for ia64 too.
>
> Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
> ---
>
> diff --git a/arch/ia64/include/asm/page.h b/arch/ia64/include/asm/page.h
> index 41b6d31..961a16f 100644
> --- a/arch/ia64/include/asm/page.h
> +++ b/arch/ia64/include/asm/page.h
> @@ -189,6 +189,7 @@ get_order (unsigned long size)
>  # define pgprot_val(x) ((x).pgprot)
>
>  # define __pte(x)      ((pte_t) { (x) } )
> +# define __pmd(x)      ((pmd_t) { (x) } )
>  # define __pgprot(x)   ((pgprot_t) { (x) } )
>
>  #else /* !STRICT_MM_TYPECHECKS */

Yes that works. Thanks.  I'll apply to my ia64 tree and ask Linus to pull it.

-Tony
