Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753718Ab1HYUAk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 16:00:40 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:41421 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753216Ab1HYUAi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 16:00:38 -0400
MIME-Version: 1.0
In-Reply-To: <4E56A15D.8070406@freescale.com>
References: <1314288433-26322-1-git-send-email-lacombar@gmail.com>
	<4E56A15D.8070406@freescale.com>
Date: Thu, 25 Aug 2011 16:00:38 -0400
Message-ID: <CACqU3MUWdadkJqii8j8htSbYXN+SaYC5uMSvm3t=2E=n4P1xcg@mail.gmail.com>
Subject: Re: [PATCH] xics/icp_natives: add __init to marker icp_native_init()
From: Arnaud Lacombe <lacombar@gmail.com>
To: Timur Tabi <timur@freescale.com>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Aug 25, 2011 at 3:24 PM, Timur Tabi <timur@freescale.com> wrote:
> Arnaud Lacombe wrote:
>> This should fix the following warning:
>>
>>  LD      arch/powerpc/sysdev/xics/built-in.o
>> WARNING: arch/powerpc/sysdev/xics/built-in.o(.text+0x1310): Section mismatch in
>> reference from the function .icp_native_init() to the function
>> .init.text:.icp_native_init_one_node()
>> The function .icp_native_init() references
>> the function __init .icp_native_init_one_node().
>> This is often because .icp_native_init lacks a __init
>> annotation or the annotation of .icp_native_init_one_node is wrong.
>>
>> icp_native_init() is only referenced in `arch/powerpc/sysdev/xics/xics-common.c'
>> by xics_init() which is itself marked with __init.
>>
>> = not built-tested =
>>
>> Reported-by: Timur Tabi <timur@freescale.com>
>> Signed-off-by: Arnaud Lacombe <lacombar@gmail.com>
>
> Acked-by: Timur Tabi <timur@freescale.com>
>
> This warning still appears, though:
>
> WARNING: arch/powerpc/sysdev/built-in.o(.text+0xf6b8): Section mismatch in
> reference from the function .ics_rtas_init() to the function
> .init.text:.xics_register_ics()
> The function .ics_rtas_init() references
> the function __init .xics_register_ics().
> This is often because .ics_rtas_init lacks a __init
> annotation or the annotation of .xics_register_ics is wrong.
>
he, chain-reaction :)

> To fix this warning, you'll also need:
>
> diff --git a/arch/powerpc/sysdev/xics/ics-rtas.c b/arch/powerpc/sysdev/xics/ics-
> index c782f85..a125721 100644
> --- a/arch/powerpc/sysdev/xics/ics-rtas.c
> +++ b/arch/powerpc/sysdev/xics/ics-rtas.c
> @@ -213,7 +213,7 @@ static int ics_rtas_host_match(struct ics *ics, struct devic
>        return !of_device_is_compatible(node, "chrp,iic");
>  }
>
> -int ics_rtas_init(void)
> +int __init ics_rtas_init(void)
>  {
>        ibm_get_xive = rtas_token("ibm,get-xive");
>        ibm_set_xive = rtas_token("ibm,set-xive");
>
>
> However, now we get another similar warning:
>
> WARNING: drivers/built-in.o(.text+0x259c484): Section mismatch in reference from
> the function .tc3589x_keypad_open() to the function
> .devinit.text:.tc3589x_keypad_init_key_hardware()
> The function .tc3589x_keypad_open() references
> the function __devinit .tc3589x_keypad_init_key_hardware().
> This is often because .tc3589x_keypad_open lacks a __devinit
> annotation or the annotation of .tc3589x_keypad_init_key_hardware is wrong.
>
> I'm not sure what to do at this point, because I have a suspicion that adding
> __devinit to tc3589x_keypad_open() is wrong.
>
tc3589x_keypad_init_key_hardware() annotation looks plain wrong.

 - Arnaud

> --
> Timur Tabi
> Linux kernel developer at Freescale
>
>
