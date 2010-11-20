Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753935Ab0KTNji (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Nov 2010 08:39:38 -0500
Received: from ironport2-out.teksavvy.com ([206.248.154.181]:58999 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753768Ab0KTNjh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Nov 2010 08:39:37 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApIBAH9e50xLd/sX/2dsb2JhbAAHgz7KKJBRgSKDNnMEhFo
X-IronPort-AV: E=Sophos;i="4.59,229,1288584000"; 
   d="scan'208";a="83067485"
Message-ID: <4CE7CF95.2040608@teksavvy.com>
Date: Sat, 20 Nov 2010 08:39:33 -0500
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-GB; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: huang ying <huang.ying.caritas@gmail.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Huang Ying <ying.huang@intel.com>, Len Brown <lenb@kernel.org>,
        linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        linux-acpi@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 0/2] Generic hardware error reporting support
References: <1290154233-28695-1-git-send-email-ying.huang@intel.com>	<AANLkTin_SyFFP_2=pKoS+8+4V1qXVWyrus7BKz8ENVsJ@mail.gmail.com>	<AANLkTincYS7G1yb2ukT67qvpjwQmptXzQZabLQLYrEqn@mail.gmail.com>	<AANLkTi=U7F7MS48dC=GgGqh=cm8YrtVhrm6sDXOma6Fc@mail.gmail.com> <AANLkTiki3d3Ft3-XJwFg8DUzUYcz3xPoYTzLZokLf+dv@mail.gmail.com>
In-Reply-To: <AANLkTiki3d3Ft3-XJwFg8DUzUYcz3xPoYTzLZokLf+dv@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10-11-20 02:11 AM, huang ying wrote:
>
> I think the BIOS error should be reported to hardware vendor instead
> of software vendor. Do you think so?

If you (and the code) are absolutely certain that a particular error instance
is totally due to the BIOS, then stick the words "BIOS ERROR" into the printk().

Problem solved.

And in the even that the diagnosis is wrong, the rest of us will still
have the complete picture of what happened from dmesg, rather than seeing
random kernel errors (from other code) happen later without knowing there
was some kind of BIOS or hardware fault that triggered it.

Having them all in one place is rather useful.
And you can still configure rsyslogd to _also_ send the BIOS/hardware
errors to a separate destination, if that turns out to be useful.

Cheers
