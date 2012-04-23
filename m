Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755409Ab2DWWNP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 18:13:15 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56861 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751573Ab2DWWNO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 18:13:14 -0400
MIME-Version: 1.0
In-Reply-To: <20120423202839.GA14147@burratino>
References: <20120402150522.GA4980@burratino>
	<20120413193905.GD2387@burratino>
	<20120423182630.GA13067@burratino>
	<CAE9FiQVSdnqrno4VBZbcQmcYagpXPOo_Cvw=c9w_1GZycKv1Xg@mail.gmail.com>
	<20120423202839.GA14147@burratino>
Date: Mon, 23 Apr 2012 15:13:13 -0700
X-Google-Sender-Auth: _6omxC4sswpDT2rli4JL5ltW5e0
Message-ID: <CAE9FiQVaThbo0oQZThc9JdEtu53CWfBvFAH6Sc9bpkwFSVAFiw@mail.gmail.com>
Subject: Re: [PATCH resend v3] x86: memtest: WARN if bad RAM found
From: Yinghai Lu <yinghai@kernel.org>
To: Jonathan Nieder <jrnieder@gmail.com>
Cc: x86@kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Ben Hutchings <ben@decadent.org.uk>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Dave Jones <davej@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 23, 2012 at 1:28 PM, Jonathan Nieder <jrnieder@gmail.com> wrote:
> Yinghai Lu wrote:
>> On Mon, Apr 23, 2012 at 11:26 AM, Jonathan Nieder <jrnieder@gmail.com> wrote:
>
>>> --- a/arch/x86/mm/memtest.c
>>> +++ b/arch/x86/mm/memtest.c
>>> @@ -30,6 +30,8 @@ static u64 patterns[] __initdata = {
>>>
>>>  static void __init reserve_bad_mem(u64 pattern, u64 start_bad, u64 end_bad)
>>>  {
>>> +       WARN_ONCE(1, "Bad RAM detected. Use memtest86+ to perform a thorough test\n"
>>> +                 "and the memmap= parameter to reserve the bad areas.");
>>
>> You must be kidding : calling memtest86+ "thorough test".
>
> How about "more thorough test"?  Or do you have a better
> recommendation for users?

The reason for adding early_memtest is for debug purpose.
Sometimes BIOS mess up setting, on some booting memory is ok, but
other booting the memory is not initialized properly.

in that case: preboot memtest tools is not going to help.

also preboot memtest tools and early_memtest is not stressed enough.
--- only one process is running.
Need to run memtester multiple instances to test your memory and systems.

Yinghai
