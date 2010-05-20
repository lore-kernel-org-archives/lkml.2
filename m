Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755036Ab0ETOaL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 10:30:11 -0400
Received: from smtp-out.google.com ([74.125.121.35]:62628 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755001Ab0ETOaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 10:30:09 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:x-system-of-record;
	b=h77o12kjT7/QFF/2f/6fgJohcdMNf600Fg8/saa5v2DNuOEOFqtDEqA7je2MjottN
	bQGnCK7/Zu4F1sQIzddDQ==
MIME-Version: 1.0
In-Reply-To: <AANLkTilSrJLHOpC0IkoMbiWxnCXHSgQhBUsSkm3fs6HG@mail.gmail.com>
References: <1274304024-6551-1-git-send-email-robert.richter@amd.com>
	 <1274304024-6551-2-git-send-email-robert.richter@amd.com>
	 <AANLkTiniEWKJIrbTSZQ0jBXps75WVQbvGSXVyUVttJ7P@mail.gmail.com>
	 <1274347413.5605.13636.camel@twins>
	 <20100520135819.GP21799@erda.amd.com>
	 <AANLkTilSrJLHOpC0IkoMbiWxnCXHSgQhBUsSkm3fs6HG@mail.gmail.com>
Date: Thu, 20 May 2010 16:30:03 +0200
Message-ID: <AANLkTikVvohrLz9gG-OdmiyZqTHiPEp-R8DuswW0clfx@mail.gmail.com>
Subject: Re: [PATCH 1/7] perf: introduce raw_type attribute to specify the 
	type of a raw sample
From: Stephane Eranian <eranian@google.com>
To: Robert Richter <robert.richter@amd.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
       David Miller <davem@davemloft.net>, Will Deacon <will.deacon@arm.com>,
       Paul Mundt <lethal@linux-sh.org>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> But it's not the question how to pass the config, the question is how
>> to mark the event configuration as a certain IBS event.
>>
> Yes, we agree on that.
>
IBS uses at most 58 out of 64 bits today. We know we can
move sampling period, random out to other fields in attr. In
fact all we would need would be two bits. But to distinguish
with regular events, I think we could reuse the event select
field of 8 bits. So you would be using 8 out of 64. IBS could
go from 58 to 64 = 6 more bits. Those could be encoded in
the config field, where you have > 50 bits left.
