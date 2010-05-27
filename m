Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758796Ab0E0QtO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 12:49:14 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:47879 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755276Ab0E0QtM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 12:49:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=JjKIypHzX1jLZHtj1VycX+5rNJ7L+l5YwDbSvLbwkka+APsEOJ3D18ng3K3eXInb7l
         WPbKEt0XBIGyl2m2TLnEQHjwaDOaAMrU/fc/iUbtqQjP/B6cfXwbb/YBONBoqe0b4KVX
         O+fNpaW7Z4vyPoZeZXOuyS5ocTQ+ElmbVFg1Q=
MIME-Version: 1.0
In-Reply-To: <AANLkTilo5onZPVM2KQFHPaQxDOSfpYA6w2ugYpTc8MOM@mail.gmail.com>
References: <AANLkTilo5onZPVM2KQFHPaQxDOSfpYA6w2ugYpTc8MOM@mail.gmail.com>
Date: Thu, 27 May 2010 12:49:10 -0400
Message-ID: <AANLkTimd5JReMf86z9YwcbSNObqW6n6sY6_AnBq40A6V@mail.gmail.com>
Subject: Re: [PATCH 1/4] [x86/mm] Correcting improper large page preservation
From: Siarhei Liakh <sliakh.lkml@gmail.com>
To: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-next@vger.kernel.org
Cc: Arjan van de Ven <arjan@infradead.org>, James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@muc.de>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
       Stephen Rothwell <sfr@canb.auug.org.au>, Dave Jones <davej@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 27, 2010 at 12:45 PM, Siarhei Liakh <sliakh.lkml@gmail.com> wrote:
> This patch fixes a bug in try_preserve_large_page() which may result
> in improper large page preservation and improper application of page
> attributes to the memory area outside of the original change request.
> More specifically, the problem manifests itself when set_memory_*() is
> called for several pages at the beginning of the large page and
[...]
> V1:  try_preserve_large_page() patch for Linux 2.6.34-rc2
>
> Signed-off-by: Siarhei Liakh <sliakh.lkml@gmail.com>
> Signed-off-by: Xuxian Jiang <jiang@cs.ncsu.edu>
> ---
>
> diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
> index cf07c26..6844675 100644
> --- a/arch/x86/mm/pageattr.c
> +++ b/arch/x86/mm/pageattr.c
> @@ -255,6 +255,7 @@ static inline pgprot_t static_protections(pgprot_t
[..]
> +               cpa->numpages == (psize >> PAGE_SHIFT)) {
>               /*
>                * The address is aligned and the number of pages
>                * covers the full page.
>

Please disregard this patch. Version 2 will be re-posted shortly.
Sorry for mistake.
