Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754005Ab0HQQgC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 12:36:02 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:61603 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750837Ab0HQQf7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 12:35:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=ujOXKDNzsLGQ8LY4SBXQ3FRnMZ0Op0hbyrIZSDYLQm2/34chU5Mp1h7vN6PrSta8mr
         /x5mYyoYTNs4jwaOOPcdp2M4jDCEP9oPq8nIh25KzifGFiZeQMi+jxJ6jccSvH320zrt
         O4BQQ8XMunBtKD6WNWPGW4IcvpbShmG0FdXss=
MIME-Version: 1.0
In-Reply-To: <20100817152833.GA15475@frolo.macqel>
References: <20100817152833.GA15475@frolo.macqel>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Tue, 17 Aug 2010 12:35:34 -0400
Message-ID: <AANLkTinZYWKJdryBraQTBGhowZbMMy6Z6K9yoevUagN4@mail.gmail.com>
Subject: Re: [PATCH] m68k{nommu}/blackfin : remove old assembler-only flags
 bit definitions.
To: Philippe De Muyter <phdm@macqel.be>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 17, 2010 at 11:28, Philippe De Muyter wrote:
> Long ago, PT_TRACESYS_OFF and friends were introduced as hard defines
> to avoid straight constants in assembler parts of linux m68k.
> They are not used anymore, and were not updated to follow changes
> in linux kernel.  Remove them.  When similar constants are needed,
> they are now generated using asm-offsets.c.
>
> --- a/arch/blackfin/include/asm/entry.h
> +++ b/arch/blackfin/include/asm/entry.h
> @@ -15,14 +15,6 @@
>  #define        LFLUSH_I_AND_D  0x00000808
>  #define        LSIGTRAP        5
>
> -/* process bits for task_struct.flags */
> -#define        PF_TRACESYS_OFF 3
> -#define        PF_TRACESYS_BIT 5
> -#define        PF_PTRACED_OFF  3
> -#define        PF_PTRACED_BIT  4
> -#define        PF_DTRACE_OFF   1
> -#define        PF_DTRACE_BIT   5
> -

looks like it has always been dead code on the Blackfin side having
originated from the m68k port.
Signed-off-by: Mike Frysinger <vapier@gentoo.org>

we can split the changeset to m68k & blackfin, or just let the m68k
guys run the thing through their tree.  i'm ok with it either way ...
i promise not to introduce conflicts into the blackfin file in the
mean time ;).
-mike
