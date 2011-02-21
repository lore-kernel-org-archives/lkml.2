Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751208Ab1BUXtu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 18:49:50 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:36063 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750860Ab1BUXtt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 18:49:49 -0500
Message-ID: <4D62FA0D.2070102@linux.vnet.ibm.com>
Date: Mon, 21 Feb 2011 15:49:33 -0800
From: Corey Ashford <cjashfor@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Andy Whitcroft <apw@canonical.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [BUG ?] checkpatch.pl rejects as error something I think it ought
 to be allow
References: <4D62F502.9040506@linux.vnet.ibm.com> <20110221234015.GG2809@shadowen.org>
In-Reply-To: <20110221234015.GG2809@shadowen.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/21/2011 03:40 PM, Andy Whitcroft wrote:
> On Mon, Feb 21, 2011 at 03:28:02PM -0800, Corey Ashford wrote:
>> Hi,
>>
>> I have a piece of code where I have two constants defined as follows:
>>
>> 	static const unsigned long polling_interval_sec = 1;
>> 	static const unsigned long polling_interval_ns = 0;
>>
>> Now, it's clear to me that I want these two values to have the
>> keywords const and static.  I could use a #define here, but const
>> static seemed cleaner to me.
>>
>> When I run checkpatch.pl across this code, I get this error:
>>
>> ERROR: do not initialise statics to 0 or NULL.
>>
>> I think the problem here is that another case is needed for "static
>> const" that does allow 0.
>>
>> What do you think?
>>
>> Thanks for your consideration,
>
> The warning is intended to tell you that the = 0 is unnecessary.  Any
> static is 0 by default I believe.  At some point the addition of the 0
> would move the value from the bss to the data segment bloating the code.
> This may no longer be true.

OK, but that means I'd have to have a declaration like this, which looks 
quite odd to me:

	static const poll_interval_ns; /* = 0 */

I don't think that is preferable to this:

	static const poll_interval_ns = 0;

- Corey
