Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753565Ab0JARWd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 13:22:33 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55851 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751544Ab0JARWc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 13:22:32 -0400
Message-ID: <4CA618AC.4000500@zytor.com>
Date: Fri, 01 Oct 2010 10:21:48 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Thunderbird/3.1.4
MIME-Version: 1.0
To: Jan Beulich <JBeulich@novell.com>
CC: Ingo Molnar <mingo@elte.hu>, heukelum@fastmail.fm, tglx@linutronix.de,
        akpm@linux-foundation.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: gas 2.16 and assembly macros -- entry_64.S build failure
References: <201009152110.o8FLAJeJ015584@imap1.linux-foundation.org> <4C91F07E0200007800016B50@vpn.id2.novell.com> <20100916082816.GA25681@elte.hu> <4C91F3A30200007800016B64@vpn.id2.novell.com> <20100916101355.GA31458@elte.hu> <4C9219BC0200007800016C53@vpn.id2.novell.com> <4CA52AA5.5040402@zytor.com> <4CA5B7910200007800019F50@vpn.id2.novell.com> <4CA5FC96.1030300@zytor.com> <4CA61E8B020000780001A22A@vpn.id2.novell.com>
In-Reply-To: <4CA61E8B020000780001A22A@vpn.id2.novell.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/01/2010 08:46 AM, Jan Beulich wrote:
> 
> Perhaps a misunderstanding? I meant to move the % back into
> movq_cfi's arguments, out of the macro body. pushq_cfi already
> is in the shape we need for having the option of using cpp macros
> when !CONFIG_AS_CFI.
> 

Hm... I guess I'm not quite following.  I don't really see how that
would help with movq_cfi, though?

>>> The other alternative, albeit disliked by Ingo, continues to be to use
>>> __stringify() on all non-trivial operands, which then wouldn't require
>>> suppressing CONFIG_AS_CFI for pre-2.17 binutils.
>>
>> You should be taken out and shot for even thinking that, never mind
>> putting it in writing...
> 
> Thank you!

Just in case the intended sarcasm didn't read... I was of course joking,
although in all seriousness the __stringify() truly is
stick-your-eyes-out ugly and is just begging for future problems.  It
really isn't an option.

	-hpa
