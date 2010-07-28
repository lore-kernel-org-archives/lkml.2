Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756137Ab0G1Sn6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 14:43:58 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:50734 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751847Ab0G1Sn4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 14:43:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=HxRWVGPejEX46cL2Ct4F3a1OjI9xvXU3B6Oi4M0eu+fwQPw0GLCffbxgpppvHPwt10
         lsTN3lqdPr4SsCdmf2/GnQYFPwhqhf6DNpcDanfc4ahjXMoJsrB6GOjURCmdILY1cX4d
         ijx0kqhhDBi7vsUEx99Da2hso/L8zguDe7oy8=
MIME-Version: 1.0
In-Reply-To: <1280328052-31292-6-git-send-email-ernesto@ti.com>
References: <1280328052-31292-1-git-send-email-ernesto@ti.com>
	<1280328052-31292-2-git-send-email-ernesto@ti.com>
	<1280328052-31292-3-git-send-email-ernesto@ti.com>
	<1280328052-31292-4-git-send-email-ernesto@ti.com>
	<1280328052-31292-5-git-send-email-ernesto@ti.com>
	<1280328052-31292-6-git-send-email-ernesto@ti.com>
Date: Wed, 28 Jul 2010 21:43:54 +0300
Message-ID: <AANLkTin-2_JC0-18QWAdo9r36Jx0QdnDwnB2+2AdePyc@mail.gmail.com>
Subject: Re: [PATCH 5/5] staging:ti dspbridge: replace simple_strtoul by 
	strict_strtoul
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Ernesto Ramos <ernesto@ti.com>
Cc: gregkh@suse.de, omar.ramirez@ti.com, ohad@wizery.com,
        ameya.palande@nokia.com, felipe.contreras@nokia.com,
        fernando.lugo@ti.com, linux-kernel@vger.kernel.org, nm@ti.com,
        linux-omap@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 28, 2010 at 5:40 PM, Ernesto Ramos <ernesto@ti.com> wrote:
> Replace simple_strtoul by strict_strtoul in atoi function.
In general the question what is the purpose here to do the change?

> @@ -1023,7 +1025,9 @@ static s32 atoi(char *psz_buf)
>                base = 16;
>        }
>
> -       return simple_strtoul(pch, NULL, base);
> +       ret_val = strict_strtoul(pch, base, &res);
> +
> +       return ret_val ? : res;
May be better to use explicit values in condition?

-- 
With Best Regards,
Andy Shevchenko
