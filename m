Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752715Ab2I0IdJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 04:33:09 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:54908 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500Ab2I0IdE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 04:33:04 -0400
Message-ID: <50640F4E.4020305@gmail.com>
Date: Thu, 27 Sep 2012 10:33:18 +0200
From: Sasha Levin <levinsasha928@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120913 Thunderbird/15.0.1
MIME-Version: 1.0
To: David Laight <David.Laight@ACULAB.COM>
CC: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Steven Rostedt <rostedt@goodmis.org>, torvalds@linux-foundation.org,
        tj@kernel.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        ebiederm@xmission.com, neilb@suse.de, bfields@fieldses.org,
        ejt@redhat.com, snitzer@redhat.com, edumazet@google.com,
        josh@joshtriplett.org, rmallon@gmail.com, palves@redhat.com
Subject: Re: [PATCH v6] hashtable: introduce a small and naive hashtable
References: <1348663729-2584-1-git-send-email-levinsasha928@gmail.com> <AE90C24D6B3A694183C094C60CF0A2F6026B7008@saturn3.aculab.com> <1348667992.22822.50.camel@gandalf.local.home> <506310AA.2050700@gmail.com> <20120926143905.GB22699@Krystal> <1348675764.22822.56.camel@gandalf.local.home> <20120926161956.GB28648@Krystal> <AE90C24D6B3A694183C094C60CF0A2F6026B7009@saturn3.aculab.com>
In-Reply-To: <AE90C24D6B3A694183C094C60CF0A2F6026B7009@saturn3.aculab.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/27/2012 10:25 AM, David Laight wrote:
>>>> And even then, if we would do:
>>>>
>>>>  	for (i = 0; i < HASH_SIZE(hashtable); i++)
>>>>  		if (!hlist_empty(&hashtable[i]))
>>>>  			break;
>>>>
>>>>  	return i >= HASH_SIZE(hashtable);
>>>>
>>>> What happens if the last entry of the table is non-empty ?
>>>
>>> It still works, as 'i' is not incremented due to the break. And i will
>>> still be less than HASH_SIZE(hashtable). Did you have *your* cup of
>>> coffee today? ;-)
>>
>> Ahh, right! Actually I had it already ;-)
> 
> I tend to dislike the repeated test, gcc might be able to optimise
> it away, but the code is cleaner written as:
> 
> 	for (i = 0; i < HASH_SIZE(hashtable); i++)
> 		if (!hlist_empty(&hashtable[i]))
> 			return false;
> 	return true;

Right, the flag thing in the macro was there just to make it work properly as a macro.

>> Agreed that the flags should be removed. Moving to define + static
>> inline is still important though.
> 
> Not sure I'd bother making the function inline.

I usually never make anything 'inline', I just let gcc do it's own thing when it compiles the code. If there are any objections
please let me know before I send the new version.


Thanks,
Sasha

