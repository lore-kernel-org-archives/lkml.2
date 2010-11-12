Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757148Ab0KLKj1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 05:39:27 -0500
Received: from smtp-out.google.com ([216.239.44.51]:59702 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756679Ab0KLKjZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 05:39:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=T0BYBnh3ds2j2ADzrxEnQoUQG2L75YbVpCvkXtZJUs/89ciwm0M1n5nfh8H70+fqLO
         5C45ArH3/EpWTWFmLNmA==
MIME-Version: 1.0
In-Reply-To: <1289505587.2084.193.camel@laptop>
References: <1289492117-18066-1-git-send-email-andi@firstfloor.org>
	<1289492117-18066-2-git-send-email-andi@firstfloor.org>
	<4CDC2DDD.50508@linux.vnet.ibm.com>
	<4CDC3845.4030104@linux.intel.com>
	<4CDC4628.8020109@linux.vnet.ibm.com>
	<20101111194936.GJ18718@basil.fritz.box>
	<1289505587.2084.193.camel@laptop>
Date: Fri, 12 Nov 2010 11:39:20 +0100
Message-ID: <AANLkTin3khDj2FpJ-SY+xhLykiKer23uAjRdBM4m8gXD@mail.gmail.com>
Subject: Re: [PATCH 2/3] perf: Add support for extra parameters for raw events
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andi Kleen <andi@firstfloor.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, mingo@elte.hu, acme@redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 11, 2010 at 8:59 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Thu, 2010-11-11 at 20:49 +0100, Andi Kleen wrote:
>> > I think it would have parsed OK, but it is a confusing syntax to
>> > look at.  I should point out that there are also the u,k,h modifiers
>> > which can be specified, even on raw events, so the full syntax looks
>> > something like:
>> >
>> > -e rXXXX[+YYYY][:u|:k|:h]
>>
>> Ok I can fix the help text for that.
>
> If we're frobbing it in the existing config qword, do we still need
> special syntax?
>
I don't think you need special syntax. You can simply come up with
the 64-bit raw hex value. corey recently added a small utility to do
this via libpfm4: perf stat -e `evt2raw unhalted_core_cycles:u` ....

With libpfm4, I'll expose the event as a normal one. Therefore
you would do:

perf stat -e OFFCORE_RESPONSE_0:PF_DATA_RD:REMOTE_DRAM ...

This will encode to:
  attr.config = 0x01b7ULL | ((1ULL << 4) | (1ULL << 13)) << 32


> Also, I think we can use the same mechanism to program the
> PEBS-load-latency MSR, right?
>
Yes, we could hardcode the latency the same way.
