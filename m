Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116Ab0HBR4y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 13:56:54 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:34811 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753109Ab0HBR4w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 13:56:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=nRzDpnWHQ5l+gB/ciIzafqgoD/gJNC+S83F65uw8r0mF9PL7SzPbHNfqUe17mkB/0C
         RreBappTj8drYmyZL09FYfaB4xwG1GexcRbGBnv5Gw+wixUB28T9Kn+26hYmi9OKte96
         Cdn9Hl2PLjCGfaYcWd7/iCSbqJRs3HMOVIO6M=
MIME-Version: 1.0
In-Reply-To: <4C56701B.1030000@kernel.org>
References: <4C56701B.1030000@kernel.org>
Date: Mon, 2 Aug 2010 14:56:51 -0300
Message-ID: <AANLkTi=r-vt=Pr+xchiR+s12RDU9xQbXnmCB4pTJcc2_@mail.gmail.com>
Subject: Re: [PATCH 1/2] x86, setup: reorgize the early_console_setup
From: Thiago Farina <tfransosi@gmail.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 2, 2010 at 4:13 AM, Yinghai Lu <yinghai@kernel.org> wrote:
> Index: linux-2.6/arch/x86/boot/string.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/boot/string.c
> +++ linux-2.6/arch/x86/boot/string.c
> @@ -12,7 +12,21 @@
>  * Very basic string functions
>  */
>
> -#include "boot.h"
> +static inline int isdigit(int ch)
> +{
> +       return (ch >= '0') && (ch <= '9');
> +}
> +
> +static inline int isxdigit(int ch)
> +{
> +       if (isdigit(ch))
> +               return true;
> +
> +       if ((ch >= 'a') && (ch <= 'f'))
> +               return true;
> +
> +       return (ch >= 'A') && (ch <= 'F');
> +}
>

These to functions above can be fairly simplified by writting as:

static bool inline is_hex_digit(int c) {
  return (c >= '0' && c <= '9') ||
            (c >= 'A' && c <= 'F') ||
            (c >= 'a' && c <= 'f');
}

Thanks.
