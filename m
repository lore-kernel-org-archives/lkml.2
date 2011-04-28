Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932983Ab1D1SR7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 14:17:59 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59456 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756103Ab1D1SR6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 14:17:58 -0400
Message-ID: <4DB9AF3C.3090901@zytor.com>
Date: Thu, 28 Apr 2011 11:17:32 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Jan Beulich <JBeulich@novell.com>, mingo@elte.hu, tglx@linutronix.de,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86-64: re-use kernel/syscall_table_32.S in ia32/ia32entry.S
References: <4DB85376020000780003E6C9@vpn.id2.novell.com> <201104271840.32015.arnd@arndb.de> <4DB847BF.1060307@zytor.com> <201104281435.33344.arnd@arndb.de>
In-Reply-To: <201104281435.33344.arnd@arndb.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/28/2011 05:35 AM, Arnd Bergmann wrote:
>>
>> Yep, something like that (although I have to say the __SC_3264 syntax
>> makes me want to barf.)
> 
> If you have a suggestion for a better syntax, I'd hope we can do
> that in asm-generic as well. My goal is to have those files set
> an example of how to best write architecture specific versions if
> they have to be different.
> 

I would just call it __SYSCALL2() -- for two versions of this syscall.
I'm not all that fond of our current "compat" notion hard-coding the
assumption of a "primary" and a "compat" ABI -- largely because that
assumption is frequently false, and it is a clear violation of the
zero-one-infinity rule.

	-hpa

