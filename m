Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760146Ab2EKTvl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 15:51:41 -0400
Received: from ironport-out.teksavvy.com ([206.248.143.162]:23936 "EHLO
	ironport-out.teksavvy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752506Ab2EKTvk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 15:51:40 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApMBACxOgk8Y9geI/2dsb2JhbAANNoVztlABAQEBAyNVARALGAICBRYLAgIJAwIBAgFFBg0BBQIBAbQkihiBL44TgRgEqSU
X-IronPort-AV: E=Sophos;i="4.75,391,1330923600"; 
   d="scan'208";a="179684232"
Message-ID: <4FAD6DCA.4030909@teksavvy.com>
Date: Fri, 11 May 2012 15:51:38 -0400
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Kay Sievers <kay@vrfy.org>, Greg KH <gregkh@linuxfoundation.org>,
        Sasha Levin <levinsasha928@gmail.com>, Yinghai Lu <yinghai@kernel.org>,
        Joe Perches <joe@perches.com>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND 1/3] printk: convert byte-buffer to variable-length
 record buffer
References: <CA+1xoqdCk9FcqdLEvwgHtfrauNh=s0dDwcpaJimMC_H83N=_5w@mail.gmail.com> <1336475689.1179.12.camel@mop> <CA+55aFwbQTq_f7p2j-eu8-hVpiZ1Uf2MCU7R+DDWHimiVbcScg@mail.gmail.com> <CAPXgP13-XQdn0wMP=coVqS=Eko1vWkOrjOtfq4JQLHFZ3JNbgg@mail.gmail.com> <1336571457.30189.29.camel@joe2Laptop> <CAPXgP11jt5u=wXs9Pe7QksZ25QTKCwNXgTHn+T6JXD6+2NzgBQ@mail.gmail.com> <CAE9FiQUzsu8CFNLXxUyZnu53YobdNdJfQQmPQd8s8r5rgJpcNg@mail.gmail.com> <20120509230649.GA10695@kroah.com> <1336617045.25027.2.camel@mop> <CA+1xoqft4aM_qedn+TDx0z8creS_4mFf3S+4SUNjz0pe+=YHAg@mail.gmail.com> <20120511151944.GA6990@kroah.com> <CA+55aFz8-96rHLfqRrRSgFAzOFmyDaDKSB15WKkCoUssHq8R-A@mail.gmail.com> <CAPXgP11teuiH0cPRrhWdvKCW1jtq4_6wkH21wgRT6UpDF0G1gQ@mail.gmail.com> <CA+55aFyG2jQFURwWebMWw7bAt3=zbXRsHSOtZVYBw-frUXqiRg@mail.gmail.com>
In-Reply-To: <CA+55aFyG2jQFURwWebMWw7bAt3=zbXRsHSOtZVYBw-frUXqiRg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12-05-11 11:47 AM, Linus Torvalds wrote:
> On Fri, May 11, 2012 at 8:40 AM, Kay Sievers <kay@vrfy.org> wrote:
>>
>> Should we just pad the multi-newline-in-one-record output with 15
>> spaces when printk_time is on?
> 
> Yeah, I think that would be the nicest thing.
> 
> Btw, I'd also *love* to see some model (eventually - not necessarily
> now) where we could have the option of the time printouts being a bit
> different (rather than just on/off). It would be very nice if we had
> "relative" time printouts for events close together, so the rule could
> be something like:
> 
>  - if time is same as last line, pad with empty
> 
>  - if time is more than a minute from last one, show an absolute value
> of dd hh:mm:ss
> 
>  - otherwise, show a relative value of +ss.mmmmmm
> 
> So the on/off choice could be on/off/relative.
> 
> Hmm?

Breaks the "grep for specific messages" case.

