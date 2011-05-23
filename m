Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753272Ab1EWJPN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 05:15:13 -0400
Received: from smtp-out.google.com ([74.125.121.67]:60569 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752643Ab1EWJPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 05:15:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=ofGRwpykJ+k0sBafBgU9k7Z/PwqxBBPmPnlWASyF9IcR8b6X+18D1X8ss85kPwOUqX
         YncPQVS6qwCJQFruYUrg==
MIME-Version: 1.0
In-Reply-To: <1306136878.18455.4.camel@twins>
References: <20110520143716.GA5381@quad>
	<1305903917.2466.7237.camel@twins>
	<BANLkTimZhpfgKoEki16r5zabNCrvK-GsUw@mail.gmail.com>
	<1306136878.18455.4.camel@twins>
Date: Mon, 23 May 2011 11:15:05 +0200
Message-ID: <BANLkTi=m+kaRfMzFh7-p8E+YJC_O+Ja6cw@mail.gmail.com>
Subject: Re: [PATCH 2/3] perf_events: fix validation of events using an extra
 reg (v2)
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>, Lin Ming <ming.m.lin@intel.com>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 23, 2011 at 9:47 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Fri, 2011-05-20 at 18:45 +0200, Stephane Eranian wrote:
>> On Fri, May 20, 2011 at 5:05 PM, Peter Zijlstra <peterz@infradead.org> wrote:
>> > On Fri, 2011-05-20 at 16:37 +0200, Stephane Eranian wrote:
>> >> The is_fake field is necessary to avoid a lockdep issue having
>> >> to do with interrupt masking and era->lock.
>> >
>> > Why not simply disable IRQs in both validate_* functions?
>> >
>> Could do that too if you think that's cleaner.
>
> Its saner than making that code path conditional, but an alternative
> solution is to give the fake thing a different lock class.
>
Looks like using irqsave()/irqrestore() would be easier. Let me respin
the patch series for this.
