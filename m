Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756815Ab1DVWPs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 18:15:48 -0400
Received: from smtp-out.google.com ([216.239.44.51]:52264 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756780Ab1DVWPq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 18:15:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=q1w9CaQQbUH4UqoDvj6c47+9joUJwwVN4bjQRcmTkmVsOxtpcDmS57H6JYjYUmG69x
         NKkoqLp3F8veApxG8MPQ==
MIME-Version: 1.0
In-Reply-To: <1303504929.4865.4.camel@laptop>
References: <BANLkTinNJERr_=ELO61UbrwCJjW1KAdK2A@mail.gmail.com>
	<1303478798.2461.11.camel@localhost>
	<BANLkTimXi0on1pLLqeW3C3YyKXNeyE1d5Q@mail.gmail.com>
	<1303504929.4865.4.camel@laptop>
Date: Sat, 23 Apr 2011 00:15:22 +0200
Message-ID: <BANLkTik4aRK-Xymww5=-duy1x=qmL1C4CA@mail.gmail.com>
Subject: Re: perf_events: questions about cpu_has_ht_siblings() and offcore support
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Lin Ming <ming.m.lin@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        "mingo@elte.hu" <mingo@elte.hu>, "Kleen, Andi" <andi.kleen@intel.com>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 22, 2011 at 10:42 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Fri, 2011-04-22 at 15:46 +0200, Stephane Eranian wrote:
>>
>> perf stat -e offcore_response_0:dmd_data_rd,offcore_response_0:dmnd_rfo ......
>>
>> This should still not be allowed.
>
> Aside from the problem you mention, I don't like the whole
> offcore_response_[01] thing. The offcore things are fully symmetric so
> the kernel should automatically select the other one if one is taken.
>
We could indeed do this. Though it would mean special casing
event codes 0xbb and 0xb7. You'd have to lookup the per-core struct
to decide whether it's worth it or not.
