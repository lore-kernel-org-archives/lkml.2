Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932226Ab0JDSYy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 14:24:54 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54500 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932099Ab0JDSYu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 14:24:50 -0400
Message-ID: <4CAA1BA3.1010306@zytor.com>
Date: Mon, 04 Oct 2010 11:23:31 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Thunderbird/3.1.4
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Jan Beulich <JBeulich@novell.com>, Ingo Molnar <mingo@elte.hu>,
        heukelum@fastmail.fm, tglx@linutronix.de, akpm@linux-foundation.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: gas 2.16 and assembly macros -- entry_64.S build failure
References: <201009152110.o8FLAJeJ015584@imap1.linux-foundation.org> <4C91F07E0200007800016B50@vpn.id2.novell.com> <20100916082816.GA25681@elte.hu> <4C91F3A30200007800016B64@vpn.id2.novell.com> <20100916101355.GA31458@elte.hu> <4C9219BC0200007800016C53@vpn.id2.novell.com> <4CA52AA5.5040402@zytor.com> <4CA9A69F.8000006@redhat.com> <4CA9F625.7090709@zytor.com> <4CA9FEE2.7000900@redhat.com>
In-Reply-To: <4CA9FEE2.7000900@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/04/2010 09:20 AM, Avi Kivity wrote:
>   On 10/04/2010 05:43 PM, H. Peter Anvin wrote:
>> On 10/04/2010 03:04 AM, Avi Kivity wrote:
>>>   On 10/01/2010 02:26 AM, H. Peter Anvin wrote:
>>>>  ... but that doesn't work with the macros like movq_cfi.  On those, we
>>>>  could argue that at least people won't put $ on them, but cpp will still
>>>>  split them apart with spaces; this apparently causes problems at least
>>>>  as soon as there is an expression more complicated than addition
>>>>  involved (apparently plus signs are okay, but minus signs aren't!)
>>>
>>>  Likely due to the fact that a minus sign can later join with a number
>>>  and become a new token, but a plug sign cannot.
>>>
>>
>> ... except the same thing applies to other operators, other than the
>> plus sign.  This kind of characterization is insanely frustrating, and
>> really doesn't seem to follow logical rules ... we had a previous one
>> where changing a macro name from upper case to lower case made gas 2.16
>> work...
>> 	
> 
> Well, / and * do join.  % doesn't.  In a way, + does.
> 
> cpp is not a pure text processing language.  It's specifically geared to 
> C, and is fairly creaky when applying it to something other than C (and 
> is only somewhat creaky when applying it to C).
> 

The problem isn't with cpp, though, it's with gas.  There are bugs in
the gas 2.16 macro features that don't apply to any other gas version,
before *or* after.

	-hpa
