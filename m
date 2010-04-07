Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932838Ab0DGP4A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 11:56:00 -0400
Received: from mail-ew0-f220.google.com ([209.85.219.220]:33960 "EHLO
	mail-ew0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932762Ab0DGPz7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 11:55:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=L8+T6VtMiAbIsMDDnRyztNMEbIwH5N8rHDR+GhW2D+sGs9U4ISoGSbRYWP+UUyXlxE
         LSDG9TFERwQsIv+hgRE/bAsy92afpX0KLoaxyExl+QsWAh2l6DU4pGvgEefzkQyhvQat
         jHXMbITGZV2M8QHQkvq0PYjOTSZV5MNB8AGhg=
MIME-Version: 1.0
In-Reply-To: <20100407142245.GA8714@elte.hu>
References: <k2h9c2470ce1004070257z7c45897o10fb7f4d7d1de8f@mail.gmail.com>
	 <20100407142245.GA8714@elte.hu>
Date: Wed, 7 Apr 2010 17:55:56 +0200
Message-ID: <z2g9c2470ce1004070855g7965443cl6d807051bb386dbb@mail.gmail.com>
Subject: Re: [PATCH] eepc-wmi.c: Fix build error
From: Jan III Sobieski <jan3sobi3ski@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Matthew Garrett <mjg@redhat.com>, Dmitry Torokhov <dtor@mail.ru>,
       Yong Wang <yong.y.wang@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/4/7 Ingo Molnar <mingo@elte.hu>:
>
> * Jan III Sobieski <jan3sobi3ski@gmail.com> wrote:
>
>> Hi,
>>
>>   GEN     .version
>>   CHK     include/generated/compile.h
>>   UPD     include/generated/compile.h
>>   CC      init/version.o
>>   LD      init/built-in.o
>>   LD      .tmp_vmlinux1
>> drivers/built-in.o: In function `eeepc_wmi_notify':
>> /home/test/linux-2.6/drivers/platform/x86/eeepc-wmi.c:86: undefined
>> reference to `sparse_keymap_report_event'
>
> -tip testing has triggered this bug too, see the fix below.

Works here. Thanks!

Tested-by: Jan III Sobieski <jan3sobi3ski@gmail.com>

>
>        Ingo
>
> --------------------------->
> From 763400ebb305711ebbd468c030db76d631400fe1 Mon Sep 17 00:00:00 2001
> From: Ingo Molnar <mingo@elte.hu>
> Date: Wed, 7 Apr 2010 16:15:51 +0200
> Subject: [PATCH] eepc-wmi.c: Fix build error
>
> -tip testing found:
>
> eeepc-wmi.c:(.text+0x36673c): undefined reference to `sparse_keymap_report_event'
> drivers/built-in.o: In function `eeepc_wmi_init':
> eeepc-wmi.c:(.init.text+0x19cd0): undefined reference to `sparse_keymap_setup'
> eeepc-wmi.c:(.init.text+0x19cf0): undefined reference to `sparse_keymap_free'
> eeepc-wmi.c:(.init.text+0x19d0b): undefined reference to `sparse_keymap_free'
> drivers/built-in.o: In function `eeepc_wmi_exit':
> eeepc-wmi.c:(.exit.text+0x2e87): undefined reference to `sparse_keymap_free'
>
> To fix this select INPUT_SPARSEKMAP, like the ASUS driver does.
>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  drivers/platform/x86/Kconfig |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
> index 3046776..301e379 100644
> --- a/drivers/platform/x86/Kconfig
> +++ b/drivers/platform/x86/Kconfig
> @@ -392,6 +392,7 @@ config EEEPC_WMI
>        depends on ACPI_WMI
>        depends on INPUT
>        depends on EXPERIMENTAL
> +       select INPUT_SPARSEKMAP
>        ---help---
>          Say Y here if you want to support WMI-based hotkeys on Eee PC laptops.
>
>



-- 
Jan III Sobieski
