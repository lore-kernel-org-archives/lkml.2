Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754350Ab0C2Jo2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 05:44:28 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:51186 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753505Ab0C2Jo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 05:44:26 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4BB07636.7010708@jp.fujitsu.com>
Date: Mon, 29 Mar 2010 18:43:18 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; ja; rv:1.9.1.8) Gecko/20100227 Thunderbird/3.0.3
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: tglx@linutronix.de, linux-kernel@vger.kernel.org, torvalds@osdl.org
Subject: Re: [PATCH] Allow Intel platforms to declare unsynchronized TSC to
 kernel
References: <20100324053257.GA4088@basil.fritz.box> <87zl1r7eod.fsf@basil.nowhere.org>
In-Reply-To: <87zl1r7eod.fsf@basil.nowhere.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2010/03/29 16:46), Andi Kleen wrote:
> Andi Kleen <andi@firstfloor.org> writes:
> 
>> Allow Intel platforms to declare unsynchronized TSC to kernel
>>
>> [This came out of a private discussion with Linus last week]
> 
> Ping?  Please review this patch.
> 
> -Andi

Does "constant" implicitly means "synchronized"?
IMHO the answer is no.

Following commit tells us that there could be
"constant-but-unsynchronized TSC":
 6c56ccecf05fafe100ab4ea94f6fccbf5ff00db7
> So, reenable TSC sync test even on constant and non-stop TSC systems.

Quote from the patch description of commit:
 40fb17152c50a69dc304dd632131c2f41281ce44
> Add support for CPUID_0x80000007_Bit8 on Intel CPUs as well. This bit means
> that the TSC is invariant with C/P/T states and always runs at constant
> frequency.
>
> With Intel CPUs, we have 3 classes
> * CPUs where TSC runs at constant rate and does not stop n C-states
> * CPUs where TSC runs at constant rate, but will stop in deep C-states
> * CPUs where TSC rate will vary based on P/T-states and TSC will stop in
>   deep C-states.

It looks like that "invariant" also means "constant."

I suppose your change is intended to allow newer platform to declare
"not invariant", instead of "not invariant but constant."
Humm, but how things change...?  Still newer platform cannot declare
one of 3 classes.  Which class is "never on newer platform"?
Or we need to have 4th new class? 

At least I think your patch description needs some update,
to get more comments without confusing reviewers.


Thanks,
H.Seto

