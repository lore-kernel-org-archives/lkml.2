Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753324Ab0LMPTc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 10:19:32 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38335 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810Ab0LMPTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 10:19:30 -0500
X-Greylist: delayed 1405 seconds by postgrey-1.27 at vger.kernel.org; Mon, 13 Dec 2010 10:19:30 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=XPWGahP1KrcuEmjI2PB3CYvVG76PQgLXWsZphpg49TSa29pe9Bm0V44QO3oMH3iBoA
         Njoa9eevYWANQCMBzOdIhVs24647FmXF0/0lvmNltmRi0c88yPxxq7BKE0L3sop4uWGk
         FJmDAtDgoyzBWP11IiUXza8YbuHXF7GW3w13o=
MIME-Version: 1.0
In-Reply-To: <-5043037405149418685@unknownmsgid>
References: <-5043037405149418685@unknownmsgid>
Date: Mon, 13 Dec 2010 14:56:04 +0000
X-Google-Sender-Auth: k5uppge3vCEjm9ZYzlztQQjO2YA
Message-ID: <AANLkTi=LZJiEP2rfQ_gL096A1GbCW+FBBmfG2eSdFY5W@mail.gmail.com>
Subject: Re: [PATCH v3 5/5] msm: add SMP support for msm
From: Catalin Marinas <catalin.marinas@arm.com>
To: ykaoua@qualcomm.com
Cc: David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Dima Zavin <dima@android.com>,
        =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>,
        Steve Muckle <smuckle@codeaurora.org>,
        Jeff Ohlstein <johlstei@codeaurora.org>,
        Brian Swetland <swetland@google.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id oBDFJfrP001019

On 13 December 2010 01:20,  <ykaoua@qualcomm.com> wrote:
> --- /dev/null
> +++ b/arch/arm/mach-msm/headsmp.S
[...]
> +ENTRY(msm_secondary_startup)
> + Â  Â  Â  mrc Â  Â  p15, 0, r0, c0, c0, 5 Â  @ MPIDR
> + Â  Â  Â  and Â  Â  r0, r0, #15 Â  Â  Â  Â  Â  Â  @ What CPU am I
> + Â  Â  Â  adr Â  Â  r4, 1f Â  Â  Â  Â  Â  Â  Â  Â  Â @ address of
> + Â  Â  Â  ldmia Â  r4, {r5, r6} Â  Â  Â  Â  Â  Â @ load curr addr and pen_rel addr
> + Â  Â  Â  sub Â  Â  r4, r4, r5 Â  Â  Â  Â  Â  Â  Â @ determine virtual/phys offsets
> + Â  Â  Â  add Â  Â  r6, r6, r4 Â  Â  Â  Â  Â  Â  Â @ apply
> +pen:
> + Â  Â  Â  wfe
> + Â  Â  Â  dsb Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  @ ensure subsequent access is
> + Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  @ after event
> +
> + Â  Â  Â  ldr Â  Â  r7, [r6] Â  Â  Â  Â  Â  Â  Â  Â @ pen_rel has cpu to remove from reset
> + Â  Â  Â  cmp Â  Â  r7, r0 Â  Â  Â  Â  Â  Â  Â  Â  Â @ are we lucky?
> + Â  Â  Â  bne Â  Â  pen

Is the primary CPU using SEV to wake the secondary from the WFE? I may
have missed it.

-- 
Catalin
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
