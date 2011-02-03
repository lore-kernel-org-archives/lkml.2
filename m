Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756738Ab1BCUBI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 15:01:08 -0500
Received: from claw.goop.org ([74.207.240.146]:60804 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754986Ab1BCUBH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 15:01:07 -0500
Message-ID: <4D4B097C.5050405@goop.org>
Date: Thu, 03 Feb 2011 12:01:00 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Andres Salomon <dilinger@queued.net>
Subject: Re: RFC: can we kill the KEEP_SEGMENTS bzImage flag?
References: <4D4AE3AE.7000009@zytor.com>
In-Reply-To: <4D4AE3AE.7000009@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/03/2011 09:19 AM, H. Peter Anvin wrote:
>>   Bit 6 (write): KEEP_SEGMENTS
>>         Protocol: 2.07+
>>         - If 0, reload the segment registers in the 32bit entry point.
>>         - If 1, do not reload the segment registers in the 32bit entry point.
>>                 Assume that %cs %ds %ss %es are all set to flat segments with
>>                 a base of 0 (or the equivalent for their environment).
> Does anything actually rely on this bit or can we kill it?  I think it
> was added as a crutch for paravirtualization, but I'm being told it is
> not used...

We originally added it with the idea that we might change the Xen boot
sequence to just enter via the normal entrypoint before wandering off to
the Xen paravirt path - mostly as a way of making use of the bzImage's
own decompresser rather than having to have that externally.

But we never ended up doing that, so the paravirt boot path is unused by
Xen, and I don't see that changing.

I think VMI may have used it, but that's moot now.

So I think lguest is the only potential user, and I'm not sure if it
actually does.

    J
