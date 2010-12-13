Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932186Ab0LMPMW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 10:12:22 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:60427 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754708Ab0LMPMS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 10:12:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=BhulXWU41tCOSaLCBK0nCp3ypeg7kCPbv2dxH05rhpxVRJsT2Rng+e4bSwlvAX/nfd
         VUcSIQVL6NM7ShO3QtQr1QTVzGkEZbcdMl83OOZnNHo/yq6BbUlDNG8+vbHefWTWP1sI
         T+IpX20/0HxylnvMkVmp1nTVVO4/h3LaE17RE=
MIME-Version: 1.0
In-Reply-To: <-1357135968697415881@unknownmsgid>
References: <1292203221-2609-1-git-send-email-y>
	<-1357135968697415881@unknownmsgid>
Date: Mon, 13 Dec 2010 15:12:15 +0000
X-Google-Sender-Auth: Bj88RHdtape2ji-k_dTqqz1NgQw
Message-ID: <AANLkTimkUpgPD5BdjL-3aV=miJwbT0OOWAJJ+V7LUhbP@mail.gmail.com>
Subject: Re: [PATCH v3 4/5] msm: hotplug: support cpu hotplug on msm
From: Catalin Marinas <catalin.marinas@arm.com>
To: ykaoua@qualcomm.com
Cc: David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Jeff Ohlstein <johlstei@codeaurora.org>,
        Brian Swetland <swetland@google.com>, Dima Zavin <dima@android.com>,
        =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id oBDFCS72000898

On 13 December 2010 01:20,  <ykaoua@qualcomm.com> wrote:
> --- /dev/null
> +++ b/arch/arm/mach-msm/hotplug.c
[...]
> +static inline void platform_do_lowpower(unsigned int cpu)
> +{
> + Â  Â  Â  /* Just enter wfe for now. */
> + Â  Â  Â  for (;;) {
> + Â  Â  Â  Â  Â  Â  Â  asm("wfe");
> + Â  Â  Â  Â  Â  Â  Â  if (pen_release == cpu) {
> + Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  /*
> + Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â * OK, proper wakeup, we're done
> + Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â */
> + Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  break;
> + Â  Â  Â  Â  Â  Â  Â  }
> + Â  Â  Â  Â  Â  Â  Â  smp_rmb();

Do you need some barrier after wfe?

-- 
Catalin
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
