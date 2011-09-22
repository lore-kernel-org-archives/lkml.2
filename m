Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754023Ab1IVVZV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 17:25:21 -0400
Received: from smtp-out.google.com ([216.239.44.51]:25911 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753911Ab1IVVZU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 17:25:20 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:date:
	message-id:subject:from:to:cc:content-type:x-system-of-record;
	b=T5tBWVlElLZJ7Hn9JqZl9qNAHonzolFVe5QCVapG58h7eOroi7qY9oRS+HorlwM3w
	q9AnB4LhZ2B1WZxgsYG+g==
MIME-Version: 1.0
In-Reply-To: <m2pqisjmtw.fsf@firstfloor.org>
References: <20110922123128.GA9761@quad>
	<m2pqisjmtw.fsf@firstfloor.org>
Date: Thu, 22 Sep 2011 23:25:16 +0200
Message-ID: <CABPqkBTPF0Tqj5BEWanuh5=VYWjY_NuSLx1gAjPr3o1sbJB-JQ@mail.gmail.com>
Subject: Re: [PATCH] perf: make perf.data more self-descriptive (v5)
From: Stephane Eranian <eranian@google.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, peterz@infradead.org,
        mingo@elte.hu, dsahern@gmail.com, robert.richter@amd.com
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 22, 2011 at 11:20 PM, Andi Kleen <andi@firstfloor.org> wrote:
> Stephane Eranian <eranian@google.com> writes:
>
>> The goal of this patch is to include more information
>> about the host environment into the perf.data so it is
>> more self-descriptive. Overtime, profiles are captured
>> on various machines and it becomes hard to track what
>> was recorded, on what machine and when.
>
> I read it near completely.
>
> The only weird thing were the .byte coded push/pops
> in CPUID.
>
That's because it needs to compile for both 32 and 64
bit ABIs. I cloned my code in libpfm4. Here is the
comment I have in libpfm4:
/*
 * .byte 0x53 == push ebx. it's universal for 32 and 64 bit
 * .byte 0x5b == pop ebx.
 * Some gcc's (4.1.2 on Core2) object to pairing push/pop and ebx in
64 bit mode.
 * Using the opcode directly avoids this problem.
 */
But that may not be true anymore.

> Also the /proc parser doesn't seem very robust,
> e.g. strstr is not a good way to check for a field.
>
> And the code reading /proc lines with fgets should
> likely use getline()
>
Good point, I will fix that.

> Then the bswap code would be much nicer inside a macro.
>
> Other than that it looks good.
>
Thanks.
