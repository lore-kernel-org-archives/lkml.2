Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751240Ab1HQEcm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 00:32:42 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:52389 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750844Ab1HQEck convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 00:32:40 -0400
MIME-Version: 1.0
In-Reply-To: <1313488648.3436.126.camel@mfleming-mobl1.ger.corp.intel.com>
References: <1312362279.10579.38.camel@mfleming-mobl1.ger.corp.intel.com>
	<CAF8ieYU2ThME1Q3u6xOp0sVOh-dPep-874TDY-=-q9E3OiSQAg@mail.gmail.com>
	<1312799149.10579.109.camel@mfleming-mobl1.ger.corp.intel.com>
	<CAF8ieYV_3skMFo4Mc59hX1g1tFEjg8Fjnag36ZQwU9w=CPkLLQ@mail.gmail.com>
	<1313488648.3436.126.camel@mfleming-mobl1.ger.corp.intel.com>
Date: Tue, 16 Aug 2011 21:32:38 -0700
Message-ID: <CAF8ieYXD0Ekke0aimptPN_0ZYPesVZu1nNkp1dvWxz9+qYOEfw@mail.gmail.com>
Subject: Re: avr32: handle_signal() bug?
From: =?ISO-8859-1?Q?H=E5vard_Skinnemoen?= <hskinnemoen@gmail.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 16, 2011 at 2:57 AM, Matt Fleming <matt@console-pimps.org> wrote:
> On Mon, 2011-08-15 at 22:55 -0700, Håvard Skinnemoen wrote:
>> /root # ./nodefer
>> SIGUSR2: not blocked
>> SIGTERM: not blocked
>
> Hmm.. that's interesting. I had a quick look through the rest of the
> code in the signal path and couldn't find anything obviously wrong. The
> only thing that looked suspicious is that you don't clear
> TIF_RESTORE_SIGMASK if you successsfully deliver a signal. Maybe try
> adding a clear_thread_flag(TIF_RESTORE_SIGMASK); to the success path in
> handle_signal() and see if you get better results? See the x86
> implementation for more details.

Yeah, probably worth a try. I wonder if I should take the opportunity
to make the signal handling code look more like x86. There's no good
reason to be different, really, other than a natural tendency to drift
apart over time.

>> On my desktop, it behaves as expected:
>>
>> $ ./nodefer-pc
>> SIGUSR2: blocked
>> SIGTERM: blocked
>>
>> Your patch doesn't appear to do any harm though, and it looks correct
>> to me. Perhaps there's another bug lurking somewhere as well. Some
>> preliminary debugging makes me suspicious about libc, but I can't tell
>> for sure yet.
>
> Which libc is this by the way?

uClibc-0.9.30. Dang, I thought I was running 0.9.31...I recall fixing
several nasty bugs between those two versions, so perhaps I should
upgrade it and see if it helps.

Havard
