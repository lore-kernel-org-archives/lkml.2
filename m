Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754883Ab1FCPcj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 11:32:39 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:63359 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751804Ab1FCPci convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 11:32:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=E9VqdgxCfq2Ny9CStE4nSw2AgGBEGC20ytNkl2RyH9oa3ag4uc5Uot1IRGJCOIZtyQ
         XL6L3Cj1Wu0La9+r4x5DFFp97CyMYM/jrOfYw00rw5oKei0akw5DDMwx4sPLT/W7W0//
         pXvitqCUrdmoAbDNO73aj0YEZKEH3b08zx+Tw=
MIME-Version: 1.0
In-Reply-To: <20110602102142.b8d76f33.akpm@linux-foundation.org>
References: <BANLkTimdog_wi+7_Vx7Qzpc0ZYor_RHg2g@mail.gmail.com>
	<20110601151618.15759bfb.akpm@linux-foundation.org>
	<20110602143141.GD4416@cr0.redhat.com>
	<20110602102142.b8d76f33.akpm@linux-foundation.org>
Date: Fri, 3 Jun 2011 23:32:37 +0800
Message-ID: <BANLkTim7_jAb2exD7fbjV7VXKenEpPwnWQ@mail.gmail.com>
Subject: Re: [Patch] cris: add missing declaration of kgdb_init() and breakpoint()
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-cris-kernel@axis.com, LKML <linux-kernel@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Mikael Starvik <starvik@axis.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 3, 2011 at 1:21 AM, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Thu, 2 Jun 2011 22:31:41 +0800 Am__rico Wang <xiyou.wangcong@gmail.com> wrote:
>
>> On Wed, Jun 01, 2011 at 03:16:18PM -0700, Andrew Morton wrote:
>> >On Sun, 22 May 2011 22:42:56 +0800
>> >Am__rico Wang <xiyou.wangcong@gmail.com> wrote:
>> >
>> >> --- a/arch/cris/arch-v10/kernel/irq.c
>> >> +++ b/arch/cris/arch-v10/kernel/irq.c
>> >> @@ -20,6 +20,9 @@
>> >>  #define crisv10_mask_irq(irq_nr) (*R_VECT_MASK_CLR = 1 << (irq_nr));
>> >>  #define crisv10_unmask_irq(irq_nr) (*R_VECT_MASK_SET = 1 << (irq_nr));
>> >>
>> >> +extern void kgdb_init(void);
>> >> +extern void breakpoint(void);
>> >
>> >They should be declared in a header file, please.
>> >arch/cris/arch-v32/kernel/irq.c has a private declaration of
>> >kgdb_init(), too.
>> >
>>
>> Yeah, but I don't find a proper header to declare them.
>
> Don't be afraid to create a new file!  If that's the appropriate thing
> to do, it's probably the correct thing to do.
>

You are right...

>
> I'd follow the herd and create arch/cris/include/asm/kgdb.h.
>

Or maybe arch/cris/include/arch-v10/arch/kgdb.h is better?

Anyway, since you already took the patch, I will send a delta patch.

Thanks!
