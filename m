Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753529Ab1EWJgG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 05:36:06 -0400
Received: from smtp-out.google.com ([216.239.44.51]:49566 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061Ab1EWJgF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 05:36:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ZS99F61x6p0hgqLng3R05DcDNegjUaow4tUJexOeGNt07uviFSeu1ceGg0SGGFOD78
         tSuq3l+pC7YKtG6ZKptg==
MIME-Version: 1.0
In-Reply-To: <1306143168.18455.10.camel@twins>
References: <20110520143707.GA5347@quad>
	<1306141897.18455.8.camel@twins>
	<1306143168.18455.10.camel@twins>
Date: Mon, 23 May 2011 11:36:02 +0200
Message-ID: <BANLkTimVM2XvpJ1d9SbmAh7xZ+qSjukX+A@mail.gmail.com>
Subject: Re: [PATCH 0/3] perf_events: update extra shared registers management (v2)
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>, Lin Ming <ming.m.lin@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 23, 2011 at 11:32 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Mon, 2011-05-23 at 11:11 +0200, Peter Zijlstra wrote:
>> +       if (event->hw.extra_reg.idx == EXTRA_REG_RSP_0) {
>> +               event->attr.config = 0x01bb;
>> +               event->hw.extra_reg.idx = EXTRA_REG_RSP_1;
>> +               event->hw.extra_reg.msr = MSR_OFFCORE_RSP_1;
>> +       } else if (event->hw.extra_reg.idx == EXTRA_REG_RSP_1) {
>> +               event->attr.config = 0x01b7;
>> +               event->hw.extra_reg.idx = EXTRA_REG_RSP_0;
>> +               event->hw.extra_reg.msr = MSR_OFFCORE_RSP_0;
>> +       }
>
> clearly I meant to write:
>
> event->hw.config &= ~X86_RAW_EVENT_MASK;
> event->hw.config |= 0x01b[b7];
>
Yes, to preserve the other bits.
This patch looks good, I will test it some more.
Thanks.
