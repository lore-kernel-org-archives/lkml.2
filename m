Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752096Ab1HPJ5d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 05:57:33 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:60769 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751624Ab1HPJ5c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 05:57:32 -0400
Subject: Re: avr32: handle_signal() bug?
From: Matt Fleming <matt@console-pimps.org>
To: =?ISO-8859-1?Q?H=E5vard?= Skinnemoen <hskinnemoen@gmail.com>
Cc: Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>
In-Reply-To: <CAF8ieYV_3skMFo4Mc59hX1g1tFEjg8Fjnag36ZQwU9w=CPkLLQ@mail.gmail.com>
References: <1312362279.10579.38.camel@mfleming-mobl1.ger.corp.intel.com>
	 <CAF8ieYU2ThME1Q3u6xOp0sVOh-dPep-874TDY-=-q9E3OiSQAg@mail.gmail.com>
	 <1312799149.10579.109.camel@mfleming-mobl1.ger.corp.intel.com>
	 <CAF8ieYV_3skMFo4Mc59hX1g1tFEjg8Fjnag36ZQwU9w=CPkLLQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 16 Aug 2011 10:57:28 +0100
Message-ID: <1313488648.3436.126.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-08-15 at 22:55 -0700, Håvard Skinnemoen wrote:
> Hi,
> 
> Sorry for taking so long to test this.

No worries!

> On Mon, Aug 8, 2011 at 3:25 AM, Matt Fleming <matt@console-pimps.org> wrote:
> > On Sun, 2011-08-07 at 10:20 -0700, Håvard Skinnemoen wrote:
> >> Looks good to me. I'm not sure how to test it though...I can try to
> >> build a kernel, run it on my board and see if it explodes, but I
> >> suspect this bug is a lot more subtle than that.
> >
> > I suspect the best test would be one that makes use of SA_NODEFER.
> > Something like this,
> 
> Thanks for the test. Unfortunately, the result is the same regardless
> of whether I apply the patches or not. In both cases:
> 
> /root # ./nodefer
> SIGUSR2: not blocked
> SIGTERM: not blocked

Hmm.. that's interesting. I had a quick look through the rest of the
code in the signal path and couldn't find anything obviously wrong. The
only thing that looked suspicious is that you don't clear
TIF_RESTORE_SIGMASK if you successsfully deliver a signal. Maybe try
adding a clear_thread_flag(TIF_RESTORE_SIGMASK); to the success path in
handle_signal() and see if you get better results? See the x86
implementation for more details.

> On my desktop, it behaves as expected:
> 
> $ ./nodefer-pc
> SIGUSR2: blocked
> SIGTERM: blocked
> 
> Your patch doesn't appear to do any harm though, and it looks correct
> to me. Perhaps there's another bug lurking somewhere as well. Some
> preliminary debugging makes me suspicious about libc, but I can't tell
> for sure yet.

Which libc is this by the way?

-- 
Matt Fleming, Intel Open Source Technology Center

