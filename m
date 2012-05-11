Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760699Ab2EKPrn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 11:47:43 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:33503 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760340Ab2EKPrm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 11:47:42 -0400
MIME-Version: 1.0
In-Reply-To: <CAPXgP11teuiH0cPRrhWdvKCW1jtq4_6wkH21wgRT6UpDF0G1gQ@mail.gmail.com>
References: <CA+1xoqdCk9FcqdLEvwgHtfrauNh=s0dDwcpaJimMC_H83N=_5w@mail.gmail.com>
 <1336475689.1179.12.camel@mop> <CA+55aFwbQTq_f7p2j-eu8-hVpiZ1Uf2MCU7R+DDWHimiVbcScg@mail.gmail.com>
 <CAPXgP13-XQdn0wMP=coVqS=Eko1vWkOrjOtfq4JQLHFZ3JNbgg@mail.gmail.com>
 <1336571457.30189.29.camel@joe2Laptop> <CAPXgP11jt5u=wXs9Pe7QksZ25QTKCwNXgTHn+T6JXD6+2NzgBQ@mail.gmail.com>
 <CAE9FiQUzsu8CFNLXxUyZnu53YobdNdJfQQmPQd8s8r5rgJpcNg@mail.gmail.com>
 <20120509230649.GA10695@kroah.com> <1336617045.25027.2.camel@mop>
 <CA+1xoqft4aM_qedn+TDx0z8creS_4mFf3S+4SUNjz0pe+=YHAg@mail.gmail.com>
 <20120511151944.GA6990@kroah.com> <CA+55aFz8-96rHLfqRrRSgFAzOFmyDaDKSB15WKkCoUssHq8R-A@mail.gmail.com>
 <CAPXgP11teuiH0cPRrhWdvKCW1jtq4_6wkH21wgRT6UpDF0G1gQ@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 11 May 2012 08:47:19 -0700
X-Google-Sender-Auth: 98sdsPCbv0SCmmF1oYiwM7jUwBE
Message-ID: <CA+55aFyG2jQFURwWebMWw7bAt3=zbXRsHSOtZVYBw-frUXqiRg@mail.gmail.com>
Subject: Re: [PATCH RESEND 1/3] printk: convert byte-buffer to variable-length
 record buffer
To: Kay Sievers <kay@vrfy.org>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Sasha Levin <levinsasha928@gmail.com>, Yinghai Lu <yinghai@kernel.org>,
        Joe Perches <joe@perches.com>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 11, 2012 at 8:40 AM, Kay Sievers <kay@vrfy.org> wrote:
>
> Should we just pad the multi-newline-in-one-record output with 15
> spaces when printk_time is on?

Yeah, I think that would be the nicest thing.

Btw, I'd also *love* to see some model (eventually - not necessarily
now) where we could have the option of the time printouts being a bit
different (rather than just on/off). It would be very nice if we had
"relative" time printouts for events close together, so the rule could
be something like:

 - if time is same as last line, pad with empty

 - if time is more than a minute from last one, show an absolute value
of dd hh:mm:ss

 - otherwise, show a relative value of +ss.mmmmmm

So the on/off choice could be on/off/relative.

Hmm?

             Linus
