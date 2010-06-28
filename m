Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754741Ab0F1US0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 16:18:26 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:33325 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478Ab0F1USY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 16:18:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=RcoYAu9Ygvj0ck/PaHdpv+UphqP12cqRalDpQU2Xs0Qt/Iv5Bcwg/GUgzcsxgDk35x
         AlhI1zAB2vaPMypJK1SorNyg7S7BFW7Iyml9BnCgAgNiBx0WeSrmac83Y8PnszFMjcnP
         48jN2dvFPaUinhy0zRbsF+cmliqxFTqp/O/Hk=
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: problem: Re: [PATCH] input: fixup X86_MRST selects
Date: Mon, 28 Jun 2010 13:18:14 -0700
User-Agent: KMail/1.13.3 (Linux/2.6.35-rc3+; KDE/4.4.4; x86_64; ; )
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Jacob Pan <jacob.jun.pan@intel.com>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, linux-input@vger.kernel.org,
       akpm <akpm@linux-foundation.org>, chuck.lever@oracle.com
References: <20100609133443.38f1f957.sfr@canb.auug.org.au> <201006101204.45709.dmitry.torokhov@gmail.com> <4C28F210.7030909@oracle.com>
In-Reply-To: <4C28F210.7030909@oracle.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006281318.16377.dmitry.torokhov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, June 28, 2010 12:03:44 pm Randy Dunlap wrote:
> On 06/10/10 12:04, Dmitry Torokhov wrote:
> > On Wednesday, June 09, 2010 03:42:08 pm Randy Dunlap wrote:
> >> On 06/09/10 15:40, Dmitry Torokhov wrote:
> >>> On Wednesday, June 09, 2010 03:29:21 pm Randy Dunlap wrote:
> >>>> +++ linux-next-20100609/drivers/input/keyboard/Kconfig
> >>>> @@ -70,9 +70,10 @@ config KEYBOARD_ATARI
> >>>> 
> >>>>  config KEYBOARD_ATKBD
> >>>>  
> >>>>         tristate "AT keyboard" if EMBEDDED || !X86
> >>>> 
> >>>> +       depends on !X86 || (X86 && !X86_MRST)
> >>> 
> >>> Should it be simply 'depends on !X86_MRST' and then we could kill
> >>> '!X86_MRST' conditionals in selects?
> >> 
> >> Duh, that sounds good, yes.
> > 
> > Actually, I do not think this is a correct approach. While Moorestown
> > does not have i8042 theoretically it is possible to add AT-style
> > keyboard by other means (however unlikely it is) so we should not be
> > disabling it.
> > 
> > We should, however, disallow i8042 from being selected. Could you please
> > tell me if the patch below works for you?
> 
> Dmitry,
> 
> This patch (in current mainline git) causes a problem when X86_MRST is
> enabled. CONFIG_SERIO_I8042 is no longer enabled when X86_MRST is enabled,
> and X86_MRST could be enabled when someone is trying to build a generic
> kernel.

Randy,

Looking at arch/x86/kernel/mrst.c I am not sure if generic kernel will
work well witbh X86_MRST set. However if we supposed to support Moorestown
on generic images then, instead of playing with Kconfig, we need to adjust
i8042_platform_init() to abort on Moorestown.

Thanks.

-- 
Dmitry
