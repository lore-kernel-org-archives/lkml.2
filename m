Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752363Ab0DMHm5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 03:42:57 -0400
Received: from mail-qy0-f201.google.com ([209.85.221.201]:36791 "EHLO
	mail-qy0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752320Ab0DMHm4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 03:42:56 -0400
X-Greylist: delayed 1223 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 Apr 2010 03:42:56 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=n155gJ9o3wd57too1Bi4+xr2jT+H3YcPMAwIyGQE+DWdwMchh/TZ/D8V06vqeFA3w/
         ypNH6Wg5eWOaJyxOA41t0oBBadycRt0qI2GE8waXeBiHOs30A+jojrKAAsq/TJMLsYwc
         dOG59sKhDCce4PQuD/l2LHX2v0atOIhETFkzU=
MIME-Version: 1.0
In-Reply-To: <1270115336-19488-1-git-send-email-nicolas.ferre@atmel.com>
References: <1270115336-19488-1-git-send-email-nicolas.ferre@atmel.com>
Date: Tue, 13 Apr 2010 09:42:55 +0200
Message-ID: <l2ocd73a99e1004130042qfe9aba83l512a0fad50112d19@mail.gmail.com>
Subject: Re: [PATCH] AT91: at91sam9g10 chip identification changed
From: Andrew Victor <avictor.za@gmail.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi Nicolas,

> A bit in the at91sam9g10 identification number changed between Engineering
> Sample and final product. This patch will identify both as being at91sam9g10.

> -#define ARCH_ID_AT91SAM9G10    0x819903a0
> +#define ARCH_ID_AT91SAM9G10    0x019903a0

> -#define cpu_is_at91sam9g10()   (at91_cpu_identify() == ARCH_ID_AT91SAM9G10)
> +#define cpu_is_at91sam9g10()   ((at91_cpu_identify() & ~AT91_CIDR_EXT) == ARCH_ID_AT91SAM9G10)


Wouldn't it be better to just mask out the AT91_CIDR_EXT bit in
at91_cpu_identify()?
That bit isn't really useful for "version" information.

We'd then just need to modify:
  #define ARCH_ID_AT91SAM9G10          0x019903a0
  #define ARCH_ID_AT91SAM9G45          0x019b05a0
  #define ARCH_ID_AT91SAM9G45MRL  0x019b05a2      /* aka 9G45-ES2 &
non ES lots */
  #define ARCH_ID_AT91SAM9G45ES     0x019b05a1      /* 9G45-ES
(Engineering Sample) */
(ie, drop bit AT91_CIDR_EXT)


Regards,
  Andrew Victor
