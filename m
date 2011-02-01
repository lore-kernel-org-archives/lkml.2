Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753381Ab1BAWD2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 17:03:28 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36926 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752895Ab1BAWDZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 17:03:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Q5fgosuJyG7SQSSQt2RBcCexzuBtEpSRdabKKZECYyK8QALYLwe9fu92TR4IDChMTL
         4XIjCvHjbJQy9al/nT0gvjb6SUgNAIU5TSzkw8EzeLD5VbGBuk6AqYmvN7U87Ypni2Ru
         PidIh9LePWlTc90CaYfATPcUYA5pTWSUNKA74=
MIME-Version: 1.0
In-Reply-To: <20110201210944.GA12348@dtor-ws.eng.vmware.com>
References: <AANLkTin4gOnEMruLDM=TkNYsNf5S370WqbcDVJzT7_Z4@mail.gmail.com>
	<20110201210944.GA12348@dtor-ws.eng.vmware.com>
Date: Tue, 1 Feb 2011 23:03:23 +0100
X-Google-Sender-Auth: i4dUUtSUg8MP4x1uFiR1z6UmFv8
Message-ID: <AANLkTimv=KqtuR36dMNa+=OMi0mgd8JK4qsb_SpmKmhs@mail.gmail.com>
Subject: Re: Early crash (was: Re: module: show version information for
 built-in modules in sysfs)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Dmitry Torokhov <dtor@vmware.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Linux/m68k" <linux-m68k@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 1, 2011 at 22:09, Dmitry Torokhov <dtor@vmware.com> wrote:
> On Tue, Feb 01, 2011 at 12:33:29PM -0800, Geert Uytterhoeven wrote:
>> On Mon, Jan 24, 2011 at 11:59, Linux Kernel Mailing List
>> <linux-kernel@vger.kernel.org> wrote:
>> > Gitweb:     http://git.kernel.org/linus/e94965ed5beb23c6fabf7ed31f625e66d7ff28de
>>
>> >    module: show version information for built-in modules in sysfs
>> >
>> >    Currently only drivers that are built as modules have their versions
>> >    shown in /sys/module/<module_name>/version, but this information might
>> >    also be useful for built-in drivers as well. This especially important
>> >    for drivers that do not define any parameters - such drivers, if
>> >    built-in, are completely invisible from userspace.
>> >
>> >    This patch changes MODULE_VERSION() macro so that in case when we are
>> >    compiling built-in module, version information is stored in a separate
>> >    section. Kernel then uses this data to create 'version' sysfs attribute
>> >    in the same fashion it creates attributes for module parameters.
>>
>> This commit causes the crash below on m68k (ARAnyM).
>> Reverting this commit and its dependency
>> 3b90a5b292321b2acac3921f77046ae195aef53f
>> ("module: fix linker error for MODULE_VERSION when !MODULE and CONFIG_SYSFS=n")
>> makes it boot again.
>>
>
> Hi Geert,
>
> Does the follwing help by any chance?
>
> From d6fd4a6e0fc2d3f0a74962d4a6f663a46d230ecd Mon Sep 17 00:00:00 2001
> diff --git a/arch/m68knommu/kernel/vmlinux.lds.S b/arch/m68knommu/kernel/vmlinux.lds.S
> index ef33213..47e15eb 100644
> --- a/arch/m68knommu/kernel/vmlinux.lds.S
> +++ b/arch/m68knommu/kernel/vmlinux.lds.S

The crash happened on m68k with MMU, not m68knommu.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
