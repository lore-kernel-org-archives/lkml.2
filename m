Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757802Ab1KRNkz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 08:40:55 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:43198 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753717Ab1KRNky convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 08:40:54 -0500
MIME-Version: 1.0
In-Reply-To: <20111118101628.5013a1ea@pyx>
References: <1321569820.1624.244.camel@localhost.localdomain>
	<20111118101628.5013a1ea@pyx>
Date: Fri, 18 Nov 2011 15:40:54 +0200
X-Google-Sender-Auth: xtDA0dpMRhD8RJM8Vq-sK598cx0
Message-ID: <CAOJsxLEZF_pLUT-OOfh8GhWkS9RPVLwEfZutzZBDh4ysjvV0Qw@mail.gmail.com>
Subject: Re: [PATCH] x86, mrst: Casting (void *) value returned by kmalloc is useless
From: Pekka Enberg <penberg@kernel.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Thomas Meyer <thomas@m3y3r.de>, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, x86@kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, 17 Nov 2011 23:43:40 +0100
> Thomas Meyer <thomas@m3y3r.de> wrote:
>
>> The semantic patch that makes this change is available
>> in scripts/coccinelle/api/alloc/drop_kmalloc_cast.cocci.
>>
>> Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
>> ---
>>
>> diff -u -p a/arch/x86/platform/mrst/mrst.c b/arch/x86/platform/mrst/mrst.c
>> --- a/arch/x86/platform/mrst/mrst.c 2011-11-07 19:37:40.283168752 +0100
>> +++ b/arch/x86/platform/mrst/mrst.c 2011-11-08 09:19:24.686513740 +0100
>> @@ -331,7 +331,7 @@ static int __init sfi_parse_gpio(struct
>>       num = SFI_GET_NUM_ENTRIES(sb, struct sfi_gpio_table_entry);
>>       pentry = (struct sfi_gpio_table_entry *)sb->pentry;
>>
>> -     gpio_table = (struct sfi_gpio_table_entry *)
>> +     gpio_table =
>>                               kmalloc(num * sizeof(*pentry), GFP_KERNEL);

On Fri, Nov 18, 2011 at 12:16 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> True but the formatting also wants fixing with that change.

A conversion to kcalloc() would make sense as well.
