Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755111Ab0LELLS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 06:11:18 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:64018 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754969Ab0LELLQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 06:11:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=V3l5Q2rrGImR/wi1LFae3xqFulelh/8K9gMHBoFyTWpPYVK2KvY7gXAb706bAGwVwT
         BeiRlT/xq1eKDMZrucu/NcxGQTCLwRf/mdkyKSzylusFxDHpRE06u25+JtDEk79n9g7T
         LuvGEv2lO7zUVpKeBodlNPLWRGwuNtpzwOPXk=
MIME-Version: 1.0
In-Reply-To: <m2wroynj4t.fsf@igel.home>
References: <alpine.DEB.2.00.1010312135110.22279@ayla.of.borg>
	<m2wroynj4t.fsf@igel.home>
Date: Sun, 5 Dec 2010 12:11:14 +0100
X-Google-Sender-Auth: GeWyxXSt1ZG_SWVaQursQqVGVUU
Message-ID: <AANLkTimfSh8QYLr1bvxcKUwtRLRLLM1J3CCn8uYmKY7v@mail.gmail.com>
Subject: Re: [PATCH/RFC] m68k/sun3: Kill pte_unmap() warnings
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Andreas Schwab <schwab@linux-m68k.org>
Cc: Sam Creasey <sammy@sammy.net>, Andrew Morton <akpm@linux-foundation.org>,
        "Linux/m68k" <linux-m68k@vger.kernel.org>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>,
        linux-mm@kvack.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 31, 2010 at 22:32, Andreas Schwab <schwab@linux-m68k.org> wrote:
> Geert Uytterhoeven <geert@linux-m68k.org> writes:
>
>> Which one is preferable?
>>
>> -------------------------------------------------------------------------------
>> Since commit 31c911329e048b715a1dfeaaf617be9430fd7f4e ("mm: check the argument
>> of kunmap on architectures without highmem"), we get lots of warnings like
>>
>> arch/m68k/kernel/sys_m68k.c:508: warning: passing argument 1 of ‘kunmap’ from incompatible pointer type
>>
>> As m68k doesn't support highmem anyway, open code the calls to kmap() and
>> kunmap() (the latter is a no-op) to kill the warnings.
>
> I prefer this one, it matches all architectures without CONFIG_HIGHPTE.

Thx, applied for 2.6.38, with updated commit message.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
