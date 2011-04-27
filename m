Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754392Ab1D0H4K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 03:56:10 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:41201 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752938Ab1D0H4I convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 03:56:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=nXsoGobUvA+f29nKsHhGDnLA7mobz29Z+2+kabpo/13OiU7KdxUMnNjmqMJCfxjIQi
         kuvJq2QLkNG/BauI2OyCwQZM7sP3hjdwV9CNlmzqCOKS3wPx2/oozriTA9p7uFBdm06C
         HmR6P+QFlZ08ea/wccH/ULSbXefYEDyYB6rnE=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1104261608210.7639@chino.kir.corp.google.com>
References: <20110426130036.997a05fc.rdunlap@xenotime.net>
	<alpine.DEB.2.00.1104261608210.7639@chino.kir.corp.google.com>
Date: Wed, 27 Apr 2011 09:56:06 +0200
X-Google-Sender-Auth: TiJQcl-3c-7HtBkFjieuAe1_nDw
Message-ID: <BANLkTimsFd-LfT6wF-iYPY7TNqR0q388XA@mail.gmail.com>
Subject: Re: [PATCH 2/2] init/Kconfig: use if/endif to surround the EXPERT
 menu kconfig symbols
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: David Rientjes <rientjes@google.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Foley <pefoley2@verizon.net>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 27, 2011 at 01:09, David Rientjes <rientjes@google.com> wrote:
> On Tue, 26 Apr 2011, Randy Dunlap wrote:
>
>> From: Randy Dunlap <randy.dunlap@oracle.com>
>>
>> Surround the EXPERT menu with "if EXPERT" and "endif" so that it
>> is forced to stay as one unit.  Hopefully this will help to prevent
>> it being broken in the future.
>>
>> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
>> Cc: David Rientjes <rientjes@google.com>
>> Cc: Peter Foley <pefoley2@verizon.net>
>> ---
>>  init/Kconfig |   36 ++++++++++++++++++++----------------
>>  1 file changed, 20 insertions(+), 16 deletions(-)
>>
>> --- lnx-2639-rc4.orig/init/Kconfig
>> +++ lnx-2639-rc4/init/Kconfig
>> @@ -924,15 +924,17 @@ menuconfig EXPERT
>>            environments which can tolerate a "non-standard" kernel.
>>            Only use this if you really know what you are doing.
>>
>> +if EXPERT
>> +
>>  config UID16
>> -     bool "Enable 16-bit UID system calls" if EXPERT
>> +     bool "Enable 16-bit UID system calls"
>>       depends on ARM || BLACKFIN || CRIS || FRV || H8300 || X86_32 || M68K || (S390 && !64BIT) || SUPERH || SPARC32 || (SPARC64 && COMPAT) || UML || (X86_64 && IA32_EMULATION)
>>       default y
>>       help
>>         This enables the legacy 16-bit UID syscall wrappers.
>>
>
> I don't like this, people who look up a Kconfig option typically only
> look at the single entry and look for dependencies within it, not the
> context in which it is declared in the Kconfig file.

What about extracting the part that depends on EXPERT into its own file
init/Kconfig.expert?

Using separate Kconfig.xxx files could become a Kconfig pattern...

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
