Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753737Ab0EQOmq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 10:42:46 -0400
Received: from mail-ew0-f216.google.com ([209.85.219.216]:34645 "EHLO
	mail-ew0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751900Ab0EQOmo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 10:42:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=v1QsqgbpdGtKCA5hKVkeTvMhzPd8zZiZvhyupGWiu8GGU/PDOL3vCL5jrCG+kMaOSr
         LtjEMuJ7thxWjPr0f59hH8KLWF9GIU/9QQixd6zKNrwdnl/sgCnJKU37m00FAkzROz6n
         qDWQoqPGcW8AqqdV4mtGrTnLcD0E7F4fcdF7Y=
MIME-Version: 1.0
In-Reply-To: <1272844700-32496-1-git-send-email-nico@openwrt.org>
References: <1272844700-32496-1-git-send-email-nico@openwrt.org>
From: Paolo Giarrusso <p.giarrusso@gmail.com>
Date: Mon, 17 May 2010 16:42:23 +0200
Message-ID: <AANLkTiks4xC4ecImFzaFBpLdBp7l7iUO941fYyCetxTA@mail.gmail.com>
Subject: Re: [uml-devel] [PATCH] UML: x86_64: fix memcpy export
To: Nicolas Thill <nicolas.thill@gmail.com>
Cc: Jeff Dike <jdike@addtoit.com>, Nicolas Thill <nico@openwrt.org>,
       linux-kernel@vger.kernel.org,
       user-mode-linux-devel@lists.sourceforge.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Shouldn't this thing be in arch/um/sys-i386/ksyms.c, instead of having #ifndef?

On Mon, May 3, 2010 at 01:58, Nicolas Thill <nicolas.thill@gmail.com> wrote:
> ./arch/um/sys-x86_64/ksyms.c exports memcpy or __memcpy depending on the gcc
> version, use the same logic in ./arch/um/os-Linux/user_syms.c
>
> Signed-off-by: Nicolas Thill <nico@openwrt.org>
> ---
>  arch/um/os-Linux/user_syms.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
>
> diff --git a/arch/um/os-Linux/user_syms.c b/arch/um/os-Linux/user_syms.c
> index 89b48a1..e3a12dd 100644
> --- a/arch/um/os-Linux/user_syms.c
> +++ b/arch/um/os-Linux/user_syms.c
> @@ -23,7 +23,8 @@ extern int printf(const char *, ...);
>  EXPORT_SYMBOL(strstr);
>  #endif
>
> -#ifndef __x86_64__
> +#if !defined(__x86_64) || \
> +       (__GNUC__ == 4 && __GNUC_MINOR__ < 3) || (__GNUC__ < 4)
>  extern void *memcpy(void *, const void *, size_t);
>  EXPORT_SYMBOL(memcpy);
>  #endif
> --
> 1.6.0.4
>
>
> ------------------------------------------------------------------------------
> _______________________________________________
> User-mode-linux-devel mailing list
> User-mode-linux-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/user-mode-linux-devel
>



-- 
Paolo Giarrusso
