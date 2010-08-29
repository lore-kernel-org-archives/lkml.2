Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753955Ab0H2TCY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Aug 2010 15:02:24 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:48029 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753606Ab0H2TCX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Aug 2010 15:02:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=oMoXMDcqGa6LrKzTFRnI+2hpnRD3siy+H0I5aO0zoHTuwaVjhhcNszhzzshlBqQBly
         PTQ6KN/IzXK20LcADj9asqSffLFLlTgMc8f3UFIHXC3PVt/fOm5nSxY9FT3YoywMj79W
         s3Vq4wA1OVXb8iZ9qvI/rvwMOr5lTMcOUWuck=
MIME-Version: 1.0
In-Reply-To: <1283011478-27237-11-git-send-email-brgerst@gmail.com>
References: <1283011478-27237-1-git-send-email-brgerst@gmail.com>
	<1283011478-27237-11-git-send-email-brgerst@gmail.com>
Date: Sun, 29 Aug 2010 22:00:52 +0300
X-Google-Sender-Auth: S_Qb3Cs04YkF4uxEQj6rBE7eN6o
Message-ID: <AANLkTinnhht86aKkmHKypmgmThJP8a1rGEXFkwyW7dc3@mail.gmail.com>
Subject: Re: [PATCH 10/11] x86: Remove unnecessary ifdefs from i387 code.
From: Pekka Enberg <penberg@kernel.org>
To: Brian Gerst <brgerst@gmail.com>
Cc: hpa@zytor.com, x86@kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 28, 2010 at 7:04 PM, Brian Gerst <brgerst@gmail.com> wrote:
> Remove ifdefs for code that the compiler can optimize away on 64-bit.
>
> Signed-off-by: Brian Gerst <brgerst@gmail.com>

> @@ -74,10 +74,8 @@ static void __cpuinit init_thread_xstate(void)
>
>        if (cpu_has_fxsr)
>                xstate_size = sizeof(struct i387_fxsave_struct);
> -#ifdef CONFIG_X86_32
>        else
>                xstate_size = sizeof(struct i387_fsave_struct);
> -#endif
>  }

I guess this is OK but keep in mind that cpu_has_fsxr is _not_
optimized by the compiler on 64-bit so the change probably increases
kernel text by few bytes.

Acked-by: Pekka Enberg <penberg@kernel.org>
