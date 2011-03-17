Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754275Ab1CQMSF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 08:18:05 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45146 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754118Ab1CQMSC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 08:18:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=YVlcHl0zsEq6v5ePS9Wx98m/HeyGYoZpQYTovYUQa1PAicFLpXPJJlD9hmABqt49DO
         d0r5CWUNmxq6qEUetvFfNMwsp/DYz+HBcNOPPZ7reqvGB8kMqfw6cpxlSLED3EAt5pRH
         w6IPfST2TJbHMyrxKr7K1dCbyxWWd9W9L3h14=
MIME-Version: 1.0
In-Reply-To: <20110315212226.7e940b51.sfr@canb.auug.org.au>
References: <20110315192428.ce74a177.sfr@canb.auug.org.au>
	<4D7F2609.3080508@redhat.com>
	<20110315103228.30233acc@endymion.delvare>
	<20110315212226.7e940b51.sfr@canb.auug.org.au>
Date: Thu, 17 Mar 2011 13:18:00 +0100
X-Google-Sender-Auth: ip2sOxI8Qp25Qn-3A1ORjnWOYbc
Message-ID: <AANLkTin46NLhP+0mmYELkD8zeC5o32H=-jXkySZ4R_dj@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the final tree
 (jdelvare-hwmon tree related)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Jean Delvare <khali@linux-fr.org>, Hans de Goede <hdegoede@redhat.com>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 15, 2011 at 11:22, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> On Tue, 15 Mar 2011 10:32:28 +0100 Jean Delvare <khali@linux-fr.org> wrote:
>> Stephen, sorry for the inconvenience, both Hans and myself build-tested
>> the new code on an architecture where <linux/delay.h> gets included
>> implicitly, so we didn't notice it was missing.
>
> It happens.  It seems that delay.h is almost always the one that is
> forgotten.  X86 builds include it implicitly but powerpc doesn't.
>
> I wonder if we could concoct a nice checkpatch test for it.

Or remove the implicit includes on x86...

$ git grep delay\\.h arch/x86/include/
arch/x86/include/asm/apic.h:#include <linux/delay.h>
arch/x86/include/asm/dma.h:#include <linux/delay.h>
arch/x86/include/asm/i8259.h:#include <linux/delay.h>
$

At first sight, apic.h and dmah.h don't seem to need it.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
