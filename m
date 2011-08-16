Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753194Ab1HPFzt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 01:55:49 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45181 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751559Ab1HPFzq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 01:55:46 -0400
MIME-Version: 1.0
In-Reply-To: <1312799149.10579.109.camel@mfleming-mobl1.ger.corp.intel.com>
References: <1312362279.10579.38.camel@mfleming-mobl1.ger.corp.intel.com>
	<CAF8ieYU2ThME1Q3u6xOp0sVOh-dPep-874TDY-=-q9E3OiSQAg@mail.gmail.com>
	<1312799149.10579.109.camel@mfleming-mobl1.ger.corp.intel.com>
Date: Mon, 15 Aug 2011 22:55:45 -0700
Message-ID: <CAF8ieYV_3skMFo4Mc59hX1g1tFEjg8Fjnag36ZQwU9w=CPkLLQ@mail.gmail.com>
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

Hi,

Sorry for taking so long to test this.

On Mon, Aug 8, 2011 at 3:25 AM, Matt Fleming <matt@console-pimps.org> wrote:
> On Sun, 2011-08-07 at 10:20 -0700, Håvard Skinnemoen wrote:
>> Looks good to me. I'm not sure how to test it though...I can try to
>> build a kernel, run it on my board and see if it explodes, but I
>> suspect this bug is a lot more subtle than that.
>
> I suspect the best test would be one that makes use of SA_NODEFER.
> Something like this,

Thanks for the test. Unfortunately, the result is the same regardless
of whether I apply the patches or not. In both cases:

/root # ./nodefer
SIGUSR2: not blocked
SIGTERM: not blocked

On my desktop, it behaves as expected:

$ ./nodefer-pc
SIGUSR2: blocked
SIGTERM: blocked

Your patch doesn't appear to do any harm though, and it looks correct
to me. Perhaps there's another bug lurking somewhere as well. Some
preliminary debugging makes me suspicious about libc, but I can't tell
for sure yet.

Havard
