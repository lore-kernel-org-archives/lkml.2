Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757459Ab1GASAb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 14:00:31 -0400
Received: from smtp-out.google.com ([216.239.44.51]:28276 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756486Ab1GASAa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 14:00:30 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:x-system-of-record;
	b=IAkhJGNTeLxi0J9Xqg0mVqNIOC77iRVKo/9XYjL7LwKMhw13f6+7QyWyptq/V/n+z
	QSrhbX5b3N9Ot90gqb+0Q==
MIME-Version: 1.0
In-Reply-To: <BANLkTimEcPmH_XgLy5aEW+znwJyVZzfoCg@mail.gmail.com>
References: <1308797024.23204.95.camel@debian> <BANLkTimEcPmH_XgLy5aEW+znwJyVZzfoCg@mail.gmail.com>
From: Nikhil Rao <ncrao@google.com>
Date: Fri, 1 Jul 2011 11:00:07 -0700
Message-ID: <CAOM-RdN3cweRQnNxCaCGuyj2GMojix15XG5MVj8pxj7FHX79hg@mail.gmail.com>
Subject: Re: power increase issue on light load
To: Ming Lei <tom.leiming@gmail.com>
Cc: "Alex,Shi" <alex.shi@intel.com>, peterz@infradead.org, mingo@elte.hu,
        "Chen, Tim C" <tim.c.chen@intel.com>,
        "Li, Shaohua" <shaohua.li@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ming,

On Thu, Jun 30, 2011 at 10:44 PM, Ming Lei <tom.leiming@gmail.com> wrote:
> Hi,
>
> On Thu, Jun 23, 2011 at 10:43 AM, Alex,Shi <alex.shi@intel.com> wrote:
>> commit c8b281161dfa4bb5d5be63fb036ce19347b88c63 causes light load
>> benchmark use more than 10% system power on platform NHM-EP and laptop
>> Thinkpad T410 etc. The benchmarks are specpower and bltk office.
>>
>> I tried to track this issue, but only find deep C sate time reduced
>> much, about from 90% to 30~40%, the C0 or C1 state increase much on
>> different machines.
>>
>> Powertop just hints RES interrupts has a bit more. but when I try "perf
>> probe native_smp_send_reschedule". I didn't find much.
>
> I see the problem on -rc5 in my T410 too, the fan has been ringing always
> and powertop reports "Wakeups-from-idle per second : 508.6".
>

Thanks for reporting this issue. Looks like the increased resolution
has a negative impact on power savings balance. I'm looking into this
issue based on Alex's data, but If you can give a trace or something
that I can work with it will be really helpful.

-Thanks,
Nikhil
