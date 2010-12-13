Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758537Ab0LMRnB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 12:43:01 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:46672 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757910Ab0LMRm7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 12:42:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=H69bEZFYhHs1DIWUgK0Uyh9/6ACiwnjrj/IfzQEamj0wxlTEzqQoqAp6FGaoNuQCnS
         tuUa39L1OzSzexKm+HllNVaLVcSnPXitU11wkoiJ0Gh73ZwEAAVHxheUrWTkvDuuKtEM
         t/k58x3rlJECSnZjCToVV0C6qrfhcKZJaVemY=
MIME-Version: 1.0
In-Reply-To: <4D0652FB.2090208@redhat.com>
References: <201012131244.547034648@firstfloor.org>
	<20101212234644.B05DAB27BF@basil.firstfloor.org>
	<4D05DC98.40105@redhat.com>
	<044a861a2279c7e3e328c73e6694fbf3.squirrel@www.firstfloor.org>
	<4D05E096.6060307@redhat.com>
	<74ff92a8c4cf72e42e7559de72e77b52.squirrel@www.firstfloor.org>
	<4D05E2A5.8070204@redhat.com>
	<20101213091254.GA999@basil.fritz.box>
	<4D05E483.1000106@redhat.com>
	<AANLkTinOWHcyjXsY3Xhe6pxi3gyQ3tJMr2qCpRPuyBW4@mail.gmail.com>
	<4D0652FB.2090208@redhat.com>
Date: Mon, 13 Dec 2010 12:36:13 -0500
X-Google-Sender-Auth: yyb0wwNSCJbk7rFQwKmYie9PQPs
Message-ID: <AANLkTikNp=mOBK9JNiNj2BC6eg=X13N-85+VWL-wiWh4@mail.gmail.com>
Subject: Re: [PATCH] [104/223] KVM: Write protect memory after slot swap
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Avi Kivity <avi@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, mst@redhat.com, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 13, 2010 at 12:08 PM, Avi Kivity <avi@redhat.com> wrote:
> On 12/13/2010 06:56 PM, Paul Gortmaker wrote:
>>
>> On Mon, Dec 13, 2010 at 4:16 AM, Avi Kivity<avi@redhat.com>  wrote:
>> >  On 12/13/2010 11:12 AM, Andi Kleen wrote:
>> >>
>> >>  >    - Greg rejects kvm patches (but not virtio etc) pointing
>> >> submitters
>> >>  >    to the kvm maintainers
>> >>  >    - The kvm maintainers collect stable kvm patches and autotest
>> >> them
>> >>
>> >>  As I understand this patch came in this way for .36
>> >>  (I took it from .36-stable)
>> >
>> >  The patch was autotested for .36-stable, it wasn't autotested for
>> >  .35-stable.  It will very likely work (this isn't code that changes a
>> > lot),
>> >  but still.
>> >
>> >>  >    - They then submit the patches to stable@
>> >>
>> >>  Do you want to do the autotest explicitely for .35 too and no
>> >> automatic
>> >>  backports and do the same procedure as for newer kernels?
>> >>
>> >>  I can do that, but you would need to do it for a long time.
>> >
>> >  Yes.  In fact it gets more important as time goes by, since as time
>> > goes by
>> >  patches are more likely to cause regressions due to changes in the code
>> >  base.
>>
>> My workflow is largely the same as Andi's -- in that I'm using patches
>> that
>> have already been nominated for other stable releases and putting them
>> on the 34-lt (longterm) as appropriate.  Are you interested in also doing
>> the
>> same thing for 34-lt (i.e. you generating a 34 specific, pre-tested
>> patchset
>> instead of me doing the backports from other stable trees?)
>
> Wait, there's a 34-lt too?

There is also a 32-lt.

>
> I'd like to have all stable kvms pass some minimum acceptance test, but
> that's quiet a lot of trees to maintain.  Why do we have to have both 34-lt
> and 35-lt?

Well, ideally we'd all be aligned on one release, but that requires that it be
chosen somewhat in advance and communicated well, so that people have
time to align to it.  Without getting into details, different people had already
based projects and products off of 34, many months ago, at a point where
35 was not yet even being considered for extended maintenance.

Or you can go with Greg's shorter justification.  It is harder to
argue against. :)

P.

>
> --
> error compiling committee.c: too many arguments to function
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
