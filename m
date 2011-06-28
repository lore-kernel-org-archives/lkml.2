Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756193Ab1F1Cfa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 22:35:30 -0400
Received: from smtp-out.google.com ([216.239.44.51]:32253 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755559Ab1F1CdT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 22:33:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=SCU9ii//qj2jHGiNlL8xgT0QvunHZdmyYqGC8X7rbqDcj45AD1SM1R64e5eAFEVAZf
         QQ9iRmBxiSVNz/YjzAWQ==
MIME-Version: 1.0
In-Reply-To: <532cc290-4b9c-4eb2-91d4-aa66c01bb3a0@glegroupsg2000goo.googlegroups.com>
References: <fa.fHPNPTsllvyE/7DxrKwiwgVbVww@ifi.uio.no>
	<532cc290-4b9c-4eb2-91d4-aa66c01bb3a0@glegroupsg2000goo.googlegroups.com>
Date: Mon, 27 Jun 2011 19:33:12 -0700
Message-ID: <BANLkTik3mEJGXLrf_XtssfdRypm3NxBKvkhcnUpK=YXV6ux=Ag@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] support for broken memory modules (BadRAM)
From: Craig Bergstrom <craigb@google.com>
To: fa.linux.kernel@googlegroups.com
Cc: "H. Peter Anvin" <hpa@zytor.com>, Stefan Assmann <sassmann@kpanic.de>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "Luck, Tony" <tony.luck@intel.com>, Andi Kleen <andi@firstfloor.org>,
        "mingo@elte.hu" <mingo@elte.hu>, "rick@vanrein.org" <rick@vanrein.org>,
        "rdunlap@xenotime.net" <rdunlap@xenotime.net>,
        Nancy Yuen <yuenn@google.com>, Michael Ditto <mditto@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

Just a quick update regarding the outstanding request for the
submission of Google's BadRAM patch.

I'm still making some final changes to Google's e820-based BadRAM
patch and plan to send it as an RFC patch to LKML soon (most likely
tomorrow).

Some folks had mentioned that they're interested in details about what
we've learned about bad ram from our fleet of machines.  I suspect
that you need ACM portal access to read this, but for those folks an
interesting read can be found at the link shown below.  My sincere
apologies that I cannot post a world-readable copy.

http://portal.acm.org/citation.cfm?id=1555372

Cheers,
CraigB

On Fri, Jun 24, 2011 at 2:10 PM, Shane Nay <snay@google.com> wrote:
>
>> > For those with a lot of ranges,
>> > like Google, the command line is insufficient.
>>
>> Not if you recognise that there is a pattern :-)
>>
>> Google does not seem to have realised that, and is simply listing
>> the pages that are defected.  IMHO, but being the BadRAM author I
>> can hardly be called objective, this is the added value of BadRAM,
>> that it understands the nature of the problem and solves it with
>> an elegant concept at the right level of abstraction.
>
> No, we have realized patterns when there is one.  It depends on the specific defect that is at play.  There are several different defect types, and incidence rate with respect to the defect being observed.  We do observe "classic" failures of the type you are describing, where with the physical addressing information (bank, row, column), we can reproducibly cause errors to occur along that path.
>
> One problem is that badram syntax doesn't cleanly mesh with all modern systems.  For instance, not all chipsets have power-of-two bank interleave.  Holes in addressing also create trouble on some systems.
>
> Other defects look like white noise, these are typically indicative of manufacturing process defects.
>
> When we find a crisp-pattern in the data, it's not always the entirety of that bit-maskable pattern which is effected.  There can be interleaved subtractions from the underlying pattern orthogonal to interleave.
>
> IMHO, badram is a good tool for it's intended purpose.  They aren't really mutually exclusive anyway.  We're cleaning up our existing patches to send out early next week.  However, we had at one time had a way of inserting badram syntax generated e820's from command line along with passed in e820's, and extended versions.  That bit isn't in our tree right now, but it's possible, and we're looking to see if we can make it work with the existing code.
>
>
>> s (and
>> living by them) for failing memory pages.  One property of BadRAM,
>> namely that it does not slow down your system (you have less
>> pages on hand, but that's all) may or may not apply to an e820-based
>> approach.  I don't know if e820 is ever consulted after boot?
>>
>> > How common are nontrivial patterns on real hardware?  This would be
>> > interesting to hear from Google or another large user.
>>
>> Yes.  And "non-trivial" would mean that the patterns waste more space
>> than fair, *because of* the generalisation to patterns.
>>
>> If you plug 10 DIMMs into your machine, and each has a faulty row
>> somewhere, then you will get into trouble if you stick to 5 patterns.
>> But if you happen to run into a faulty DIMM from time to time, the
>> patterns should be your way out.
>>
>> > I have to say I think Google's point that truncating the list is
>> > unacceptable...
>>
>> Of course, that is true.  This is why memmap=... does not work.
>> It has nothing to do with BadRAM however, there will never be more
>> than 5 patterns.
>>
>> > that would mean running in a known-bad configuration,
>> > and even a hard crash would be better.
>>
>> ..which is so sensible that it was of course taken into account in
>> the BadRAM design!
>>
>>
>> Cheers,
>>  -Rick
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majo...@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
