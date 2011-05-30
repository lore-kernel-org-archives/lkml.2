Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757537Ab1E3Q2k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 12:28:40 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:64018 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753383Ab1E3Q2i convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 12:28:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=g5PBWzPBwkaYn6WmVSCrt0//oo7TsuhBEnArsEtdNttUf21LCdSvpdCy/nD8QOqFUs
         6bASDPCr6FAOjoUTLvsQQEiTsDsNCl9ZrnhDd63upJCR46kZHndKN50ZDtjqesP0SMGz
         /BvfnDyFhDj7qjJ9ITosrYMcdmpuiiOv9Ze9k=
MIME-Version: 1.0
In-Reply-To: <4DE3688A.4040600@mvista.com>
References: <20110527151135.cd6f758a.sfr@canb.auug.org.au> <1306591465-9622-1-git-send-email-vapier@gentoo.org>
 <4DE3688A.4040600@mvista.com>
From: Mike Frysinger <vapier@gentoo.org>
Date: Mon, 30 May 2011 12:28:17 -0400
X-Google-Sender-Auth: Y8gjFjqQ-FvZmLsSHTju1eLRCco
Message-ID: <BANLkTind_F4-5sLUO1GVxK_yY_eXz_J0Vg@mail.gmail.com>
Subject: Re: [Kgdb-bugreport] [PATCH] kgdbts: only use new asm-generic/ptrace.h
 api when needed
To: Sergei Shtylyov <sshtylyov@mvista.com>
Cc: kgdb-bugreport@lists.sourceforge.net,
        Jason Wessel <jason.wessel@windriver.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 30, 2011 at 05:51, Sergei Shtylyov wrote:
> On 28-05-2011 18:04, Mike Frysinger wrote:
>> The new instruction_pointer_set helper is defined for people who have
>> converted to asm-generic/ptrace.h, so don't use it generally unless
>> the arch needs it (in which case it has been converted).  This should
>> fix building of kgdb tests for arches not yet converted.
>
>> --- a/drivers/misc/kgdbts.c
>> +++ b/drivers/misc/kgdbts.c
>> @@ -304,7 +304,10 @@ static int check_and_rewind_pc(char *put_str, char
>> *arg)
>>                return 1;
>>        }
>>        /* Readjust the instruction pointer if needed */
>> -       instruction_pointer_set(&kgdbts_regs, ip + offset);
>> +       ip += offset;
>
>   Since 'íp' is local, incrementing it is pointless here unless you have
> GDB_ADJUSTS_BREAK_OFFSET defined. Why not keep instruction_pointer_set()
> call as is?

i prefer to have as much outside of ifdefs as possible.  gcc optimizes
the result away, so it isnt a code size problem.
-mike
