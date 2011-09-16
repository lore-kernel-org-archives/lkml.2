Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754869Ab1IPOot (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 10:44:49 -0400
Received: from smtp-out.google.com ([74.125.121.67]:50443 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753431Ab1IPOor convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 10:44:47 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:date:
	message-id:subject:from:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=CU57NrS1uJu+GniVzkiBc/+0LyxOqDp6tF1X4FCKyN+UIiqPRb7W/focHLDuSWY+j
	/pliWZN62XjqR+yIQSQCw==
MIME-Version: 1.0
In-Reply-To: <1316183832.10174.28.camel@twins>
References: <20110907191045.GA13475@quad>
	<4E6E0D0B.3080306@gmail.com>
	<CABPqkBSfQo5E=MJ913E--dc8Fi7VLcFSGNbBf60tOnTLMuVN_w@mail.gmail.com>
	<4E6E181E.9080506@gmail.com>
	<CABPqkBQWd=DyRRDhaxwDGrpCs=XqyTUv72+dn7GKsT=kjPqiJg@mail.gmail.com>
	<1315838611.26517.51.camel@twins>
	<CABPqkBShe6OG1ukQ=7vn_Mr=Aa_c8jcbo1mYuF+41Euy5_R7Dw@mail.gmail.com>
	<1316183832.10174.28.camel@twins>
Date: Fri, 16 Sep 2011 16:44:44 +0200
Message-ID: <CABPqkBRmpnMNH16_HNWWHFn8dDtTE+jRjunkLDpc30SnA8_oYA@mail.gmail.com>
Subject: Re: [PATCH] perf: make perf.data more self-descriptive (v4)
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: David Ahern <dsahern@gmail.com>, linux-kernel@vger.kernel.org,
        acme@redhat.com, mingo@elte.hu
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 16, 2011 at 4:37 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Fri, 2011-09-16 at 16:35 +0200, Stephane Eranian wrote:
>> On Mon, Sep 12, 2011 at 4:43 PM, Peter Zijlstra <peterz@infradead.org> wrote:
>> > On Mon, 2011-09-12 at 16:40 +0200, Stephane Eranian wrote:
>> >> I don't think this should be the test to detect endianess.
>> >
>> > You should be able to tell the endianness from the PERF_MAGIC string, it
>> > stores the string as a u64, so depending on endianness it reads back as
>> > either: PERFFILE or ELIFFREP or whatever the bswap64 result is.
>> >
>>
>> I believe in big endian, if you do od -c perf.data | head -1, you also see:
>>
>> 0000000   P   E   R   F   F   I   L   E   h  \0  \0  \0  \0  \0  \0  \0
>
> Sure, but all you need to know is if the file you're reading is a
> different endian than your box, if it is swap stuff, if its not, you're
> good.

We agree on that. I am just saying the MAGIC string as it is today
may not be enough to tell us that.

>
>
>
