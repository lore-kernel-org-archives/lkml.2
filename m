Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932362Ab1FVSMB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 14:12:01 -0400
Received: from smtp-out.google.com ([216.239.44.51]:62753 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932243Ab1FVSL7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 14:11:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=dAb12EQAtlqCxhTgYwOqxi2kYunrnzq4IhoufeDiQ9aboSMRpyBVMUrPaUoRal4XgV
         rw5tCnALnztN4R+8xVwQ==
MIME-Version: 1.0
In-Reply-To: <20110622110910.c8e11eb7.rdunlap@xenotime.net>
References: <1308741534-6846-1-git-send-email-sassmann@kpanic.de>
	<20110622110034.89ee399c.akpm@linux-foundation.org>
	<20110622110910.c8e11eb7.rdunlap@xenotime.net>
Date: Wed, 22 Jun 2011 11:11:51 -0700
Message-ID: <BANLkTim=N=8G+Q9HJ6BaMO8L3oZouanxvtsf99fVxYGquTewDg@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] support for broken memory modules (BadRAM)
From: Nancy Yuen <yuenn@google.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Stefan Assmann <sassmann@kpanic.de>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, tony.luck@intel.com, andi@firstfloor.org,
        mingo@elte.hu, hpa@zytor.com, rick@vanrein.org,
        Michael Ditto <mditto@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I haven't had time to submit the patches, though it's on my todo list.

----------
Nancy



On Wed, Jun 22, 2011 at 11:09, Randy Dunlap <rdunlap@xenotime.net> wrote:
> On Wed, 22 Jun 2011 11:00:34 -0700 Andrew Morton wrote:
>
>> On Wed, 22 Jun 2011 13:18:51 +0200 Stefan Assmann <sassmann@kpanic.de> wrote:
>>
>> > Following the RFC for the BadRAM feature here's the updated version with
>> > spelling fixes, thanks go to Randy Dunlap. Also the code is now less verbose,
>> > as requested by Andi Kleen.
>> > v2 with even more spelling fixes suggested by Randy.
>> > Patches are against vanilla 2.6.39.
>> >
>> > The idea is to allow the user to specify RAM addresses that shouldn't be
>> > touched by the OS, because they are broken in some way. Not all machines have
>> > hardware support for hwpoison, ECC RAM, etc, so here's a solution that allows to
>> > use bitmasks to mask address patterns with the new "badram" kernel command line
>> > parameter.
>> > Memtest86 has an option to generate these patterns since v2.3 so the only thing
>> > for the user to do should be:
>> > - run Memtest86
>> > - note down the pattern
>> > - add badram=<pattern> to the kernel command line
>> >
>> > The concerning pages are then marked with the hwpoison flag and thus won't be
>> > used by the memory managment system.
>>
>> The google kernel has a similar capability.  I asked Nancy to comment
>> on these patches and she said:
>>
>> : One, the bad addresses are passed via the kernel command line, which
>> : has a limited length.  It's okay if the addresses can be fit into a
>> : pattern, but that's not necessarily the case in the google kernel.  And
>> : even with patterns, the limit on the command line length limits the
>> : number of patterns that user can specify.  Instead we use lilo to pass
>> : a file containing the bad pages in e820 format to the kernel.
>> :
>> : Second, the BadRAM patch expands the address patterns from the command
>> : line into individual entries in the kernel's e820 table.  The e820
>> : table is a fixed buffer that supports a very small, hard coded number
>> : of entries (128).  We require a much larger number of entries (on
>> : the order of a few thousand), so much of the google kernel patch deals
>> : with expanding the e820 table. Also, with the BadRAM patch, entries
>> : that don't fit in the table are silently dropped and this isn't
>> : appropriate for us.
>> :
>> : Another caveat of mapping out too much bad memory in general.  If too
>> : much memory is removed from low memory, a system may not boot.  We
>> : solve this by generating good maps.  Our userspace tools do not map out
>> : memory below a certain limit, and it verifies against a system's iomap
>> : that only addresses from memory is mapped out.
>>
>> I have a couple of thoughts here:
>>
>> - If this patchset is merged and a major user such as google is
>>   unable to use it and has to continue to carry a separate patch then
>>   that's a regrettable situation for the upstream kernel.
>>
>> - Google's is, afaik, the largest use case we know of: zillions of
>>   machines for a number of years.  And this real-world experience tells
>>   us that the badram patchset has shortcomings.  Shortcomings which we
>>   can expect other users to experience.
>>
>> So.  What are your thoughts on these issues?
>
>
> Good comments, so where is google's patch submittal?
>
> ---
> ~Randy
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
>
