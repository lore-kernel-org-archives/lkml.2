Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754731Ab1DEQDA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 12:03:00 -0400
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:45966 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752887Ab1DEQC6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 12:02:58 -0400
MIME-Version: 1.0
In-Reply-To: <BANLkTinvbd9hmcsxhWQtM70uBzgv7sESTQ@mail.gmail.com>
References: <1301602523-9906-1-git-send-email-omar.ramirez@ti.com>
	<BANLkTimtAcPLmcFKoHkCtWcJipy+rSSP+A@mail.gmail.com>
	<4D959058.7010606@codeaurora.org>
	<BANLkTim8GhUAZ7L-MiJiqi6xM=P_Q8kqfg@mail.gmail.com>
	<4D981EAB.8070209@codeaurora.org>
	<BANLkTimhk_G0fapzHAf0Gc-XhqT0qu+VbQ@mail.gmail.com>
	<BANLkTinvbd9hmcsxhWQtM70uBzgv7sESTQ@mail.gmail.com>
Date: Tue, 5 Apr 2011 11:02:56 -0500
Message-ID: <BANLkTik3Rf_NUNnqQLPxRdokJzFLcZPK9w@mail.gmail.com>
Subject: Re: [PATCH] ARM: BUG() dies silently
From: "Ramirez Luna, Omar" <omar.ramirez@ti.com>
To: Simon Glass <sjg@chromium.org>
Cc: Stephen Boyd <sboyd@codeaurora.org>, Russell King <linux@arm.linux.org.uk>,
        lk <linux-kernel@vger.kernel.org>,
        lak <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Apr 5, 2011 at 12:46 AM, Simon Glass <sjg@chromium.org> wrote:
> On Mon, Apr 4, 2011 at 7:29 PM, Ramirez Luna, Omar <omar.ramirez@ti.com> wrote:
> ...
>> I am using CONFIG_BUG=y, however I don't have CONFIG_DEBUG_BUGVERBOSE
>> and hence I fall into the part which doesn't print the file and the
>> line where the BUG was found.
>>
>> With Simon's patch if my .config had:
>>
>> CONFIG_BUG=y
>> CONFIG_GENERIC_BUG is not set
>
> In this case the patch is like a nop.
>
>> CONFIG_DEBUG_BUGVERBOSE is not set
>>
>> I would fall into the same BUG definition that is causing issues:
>>
>> #define BUG()           do { *(int *)0 = 0; } while (1)
>>
>> OTOH, is not like "Use generic BUG() handler" gives the choice of
>> removing GENERIC_BUG given that it is not prompted in menuconfig and
>> auto selected, if this is the intention is there any reason to keep
>> the #else part of /* not CONFIG_GENERIC_BUG */? there is no way we can
>> use it with this patch, right?
>
> Well, er, the intention is that you use the patch. I kept the old code
> around since people can then simply change the Kconfig option and be
> back where they were, as indeed you have. I would be happy to remove
> the old behavior, but I was concerned about a possible roasting in
> this forum. Changing long-established behavior is sometimes tricky.

Yes, but you can't change the Kconfig because it is not prompted with
your patch, if that was the intention then an option to de/select
GENERIC_BUG or not is needed:

arch/arm/Kconfig
@@ -204,6 +204,10 @@ config MMU
          Select if you want MMU-based virtualised addressing space
          support by paged memory management. If unsure, say 'Y'.

+config GENERIC_BUG
+       bool "Generic BUG"
+       default y
+       depends on BUG

Regards,

Omar
