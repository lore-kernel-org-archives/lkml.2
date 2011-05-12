Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758825Ab1ELV4k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 17:56:40 -0400
Received: from smtp-out.google.com ([216.239.44.51]:6843 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758797Ab1ELV4i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 17:56:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=kw0tUWTaW1jSi+aQmAZAXq2CrAzFOGtcIxjbE5ZP57xhy8Vwc9Twavlk5Z4L76XnAN
         0OPmZVk5H98oSWgddHyg==
MIME-Version: 1.0
In-Reply-To: <20110512215023.GA20939@elte.hu>
References: <BANLkTim8mAzZbdOhBodaOFKM5esP-Q+K7g@mail.gmail.com>
	<BANLkTi==OatTqfDbnAmHQA0t2DmokEd-CA@mail.gmail.com>
	<BANLkTik7wQc05OQTHThBbrFhKx2pM1Tx+A@mail.gmail.com>
	<BANLkTimjHiaZ+b03FLb1LX=ycv=cAVyJZw@mail.gmail.com>
	<20110512213542.GB17596@elte.hu>
	<BANLkTikPmq=NOt-9t0odVVnrRshM=MsnJw@mail.gmail.com>
	<20110512215023.GA20939@elte.hu>
Date: Thu, 12 May 2011 23:56:35 +0200
Message-ID: <BANLkTimO-8QNumkjzYia5P-V3pm_4JMLxg@mail.gmail.com>
Subject: Re: [BUG] perf: bogus correlation of kernel symbols
From: Stephane Eranian <eranian@google.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 12, 2011 at 11:50 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Stephane Eranian <eranian@google.com> wrote:
>
>> On Thu, May 12, 2011 at 11:35 PM, Ingo Molnar <mingo@elte.hu> wrote:
>> >
>> > * Stephane Eranian <eranian@google.com> wrote:
>> >
>> >> The other contradiction, I see, is that you have perf_event paranoia level
>> >> and this new kptr masquerading feature which conflict with each
>> >> other.
>> >>
>> >> You can be allowed to monitor at the kernel level (paranoid=1, default)
>> >> but you cannot correlate symbols:
>> >>
>> >> $ perf record -e cycles:k foo
>> >>
>> >> I suspect if you have this kptr thing turned on, then you need to disallow
>> >> monitoring at the kernel level too.
>> >
>> > The better (and consistent) solution would be to turn the kptr_restrict thing
>> > off - see the patch i sent.
>>
>> I saw that. But I think that when someone turns it back on, then you need to
>> increase the perf_events paranoia level to disallow kernel monitoring to
>> regular users such that you maintain consistency across the board.
>
> Dunno, i would not couple them necessarily - certain users might still have
> access to kernel symbols via some other channel - for example the System.map.
>
Ok, that's true, but then you'd need to have perf print a message or refuse to
use /proc/kallsyms and suggest that the user provides a System.map.
