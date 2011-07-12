Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758068Ab1GLHiS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 03:38:18 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:54213 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751525Ab1GLHiR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 03:38:17 -0400
MIME-Version: 1.0
In-Reply-To: <20110711143859.0e6c95d8@schlenkerla.am.freescale.net>
References: <CABkP77e6vLmLxk3wCP39GJ7+yKnJZFc7BPUZ1OkdA8d7KkBCiw@mail.gmail.com>
	<20110711143859.0e6c95d8@schlenkerla.am.freescale.net>
Date: Tue, 12 Jul 2011 09:38:16 +0200
X-Google-Sender-Auth: a9d-ko52wIrrygDSBe4U_CeOqYE
Message-ID: <CABkP77d8K1Of7jw8hpyi_XG+xorZ8OKkgoGfSy9_zh7iSq5kFA@mail.gmail.com>
Subject: Re: [PATCH] powerpc/85xx: fix mpic configuration in CAMP mode
From: Fabio Baltieri <fabio.baltieri@gmail.com>
To: Scott Wood <scottwood@freescale.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Poonam Aggrwal <poonam.aggrwal@freescale.com>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 11, 2011 at 9:38 PM, Scott Wood <scottwood@freescale.com> wrote:
> On Sun, 10 Jul 2011 20:55:32 +0200
> Fabio Baltieri <fabio.baltieri@gmail.com> wrote:
>
>> Change the string to check for CAMP mode boot on MPC85xx (eg. P2020) to match
>> the one in the corresponding dts files (p2020rdb_camp_core{0,1}.dts).
>>
>> Without this fix the mpic is configured as in the SMP boot mode, which causes
>> the first core to report a protected source interrupt error for devices
>> of the other core and lock up.
>>
>> Signed-off-by: Fabio Baltieri <fabio.baltieri@gmail.com>
>> ---
>>  arch/powerpc/platforms/85xx/mpc85xx_rdb.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/arch/powerpc/platforms/85xx/mpc85xx_rdb.c
>> b/arch/powerpc/platforms/85xx/mpc85xx_rdb.c
>> index 088f30b..a1e5e70 100644
>> --- a/arch/powerpc/platforms/85xx/mpc85xx_rdb.c
>> +++ b/arch/powerpc/platforms/85xx/mpc85xx_rdb.c
>> @@ -58,7 +58,7 @@ void __init mpc85xx_rdb_pic_init(void)
>>               return;
>>       }
>>
>> -     if (of_flat_dt_is_compatible(root, "fsl,85XXRDB-CAMP")) {
>> +     if (of_flat_dt_is_compatible(root, "fsl,MPC85XXRDB-CAMP")) {
>>               mpic = mpic_alloc(np, r.start,
>>                       MPIC_PRIMARY |
>>                       MPIC_BIG_ENDIAN | MPIC_BROKEN_FRR_NIRQS,
>
> Shouldn't we be setting MPIC_SINGLE_DEST_CPU in this case (as we do for
> the other case)?
>
> Or just drop this and specify pic-no-reset in the mpic node.

Yeah, seems like a good idea. I still prefer to leave the
MPIC_WANTS_RESET for the default case (SMP mode), which I think is
what most people are using.

I'm sending a v2 of the patch, thanks!

-- 
Fabio Baltieri
