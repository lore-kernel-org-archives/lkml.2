Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754061Ab0CZVex (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 17:34:53 -0400
Received: from smtp2.caviumnetworks.com ([209.113.159.134]:16264 "EHLO
	smtp2.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753948Ab0CZVeu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 17:34:50 -0400
X-Greylist: delayed 980 seconds by postgrey-1.27 at vger.kernel.org; Fri, 26 Mar 2010 17:34:50 EDT
Message-ID: <4BAD248D.7070603@caviumnetworks.com>
Date: Fri, 26 Mar 2010 14:18:05 -0700
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: [PATCH] Protect prefetch macro arguments.
References: <1269636240-8895-1-git-send-email-ddaney@caviumnetworks.com> <alpine.LFD.2.00.1003261402170.3721@i5.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.1003261402170.3721@i5.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Mar 2010 21:18:11.0284 (UTC) FILETIME=[D6B24140:01CACD29]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/26/2010 02:04 PM, Linus Torvalds wrote:
>
>
> On Fri, 26 Mar 2010, David Daney wrote:
>>
>> The GCC built-in __builtin_prefetch() is a vargs function.  If we
>> don't wrap the macro parameter in parentheses, a comma operator in the
>> actual argument list might cause unintended parameters to be passed to
>> __builtin_prefetch().
>
> This seems totally pointless and actively wrong.

Pointless, perhaps.  But 'actively wrong'?  Are you sure about that?

In any event I guess I don't care much one way or the other.  I was 
working on something else when I saw this. It looked wrong to me.

Thanks,
David Daney


>
> You cannot have a comma operator in the actual argument list to the
> #define, because if you did, then you'd get a
>
> 	macro "prefetch()" passed 2 arguments, but takes just 1
>
> so the only way I see to pass a comma operator is to _already_ have the
> macro parameter in parenthesis.
>
> 		Linus

