Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755425Ab0KUAuK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Nov 2010 19:50:10 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:56385 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754035Ab0KUAuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Nov 2010 19:50:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=J3oLyIN+Y2qatAb1K5br2WZKKEQ86weXSEuTznxYv/nrY+V26uYldZZ6i55suYWGZD
         dHiBQ14mUWzDay8N9WQBlAkdn5c0qNyuPEiG60ttBvEqEtILzCwd5TnT7rGUwO/m3O+7
         Q8Bs0l/NYl4iTrYlFK4pwp6RVT6Fq6T3ZJ3Vk=
MIME-Version: 1.0
In-Reply-To: <AANLkTin_SyFFP_2=pKoS+8+4V1qXVWyrus7BKz8ENVsJ@mail.gmail.com>
References: <1290154233-28695-1-git-send-email-ying.huang@intel.com>
	<AANLkTin_SyFFP_2=pKoS+8+4V1qXVWyrus7BKz8ENVsJ@mail.gmail.com>
Date: Sat, 20 Nov 2010 21:50:06 -0300
Message-ID: <AANLkTimy3d4KATWEhBJKFaKWD2FB7b9o8oavcwBsOnrs@mail.gmail.com>
Subject: Re: [PATCH 0/2] Generic hardware error reporting support
From: Elias Gabriel Amaral da Silva <tolkiendili@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Huang Ying <ying.huang@intel.com>, Len Brown <lenb@kernel.org>,
        linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        linux-acpi@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/11/19 Linus Torvalds <torvalds@linux-foundation.org>:
> On Fri, Nov 19, 2010 at 12:10 AM, Huang Ying <ying.huang@intel.com> wrote:
>>
>> This is used by APEI ERST and GEHS. But it is a generic hardware
>> error reporting mechanism and can be used by other hardware error
>> reporting mechanisms such as EDAC, PCIe AER, Machine Check, etc.
>
> Yeah, no.
>
> Really.
>
> We don't want some specific hardware error reporting mechanism.
> Hardware errors are way less common than other errors, so making
> something that is special to them just isn't very interesting.

Reading the following google paper on memory errors:

http://www.google.com/research/pubs/pub35162.html

I suppose they weren't really reporting memory errors with printk.
Because of this:

"The scale of the system and the data being collected make the
analysis non-trivial. Each one of many ten-thousands of machines in
the fleet logs every ten minutes hundreds of parameters, adding up to
many TBytes."

This would add up to gigabytes of generated data, for each machine, in
some minutes. It seems to me that printk isn't really suited to report
large amounts of raw data.
