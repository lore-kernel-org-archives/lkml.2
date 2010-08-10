Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932417Ab0HJQnJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 12:43:09 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:43672 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932202Ab0HJQnG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 12:43:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=iIrPWoDFUwhxyiqRez+zDIuX6slni9LbtPNqZXZkC5k6WmJDMehiH+JVXKMQhghsvF
         iQT48J1n5DzVlhrdS+HwxsXH3nWuLxMRQjn3WVLsFYco8lsIs/yZ32tdtQWl/OHjEfnD
         ZpsZOca44CxiFJizbtZqfNxrBmJKiRnerJhKc=
Message-ID: <4C618195.4000706@suse.cz>
Date: Tue, 10 Aug 2010 18:43:01 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.8) Gecko/20100802 SUSE/3.1.2 Thunderbird/3.1.2
MIME-Version: 1.0
To: Chris Metcalf <cmetcalf@tilera.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>, LKML <linux-kernel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT] writable_limits for 2.6.36
References: <4C5D4E50.5050105@suse.cz> <AANLkTimPS_WFvEwyx+odwof5_AF5ZTOhu-3uK6m_VhYa@mail.gmail.com> <4C617C94.5010808@tilera.com>
In-Reply-To: <4C617C94.5010808@tilera.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/10/2010 06:21 PM, Chris Metcalf wrote:
> On 8/10/2010 12:01 PM, Linus Torvalds wrote:
>> 2010/8/7 Jiri Slaby <jslaby@suse.cz>:
>>   
>>> please consider the following repository for 2.6.36. It introduces a new
>>> syscall for arch independent resource limits handling. It also adds a
>>> support for runtime limits changing. This feature is needed mostly by
>>> daemons servicing databases and similar service where limits are needed
>>> to be changed without services being restarted on production systems.
>>>     
>> Ok, so the code looks fine, and I don't have any real objections any
>> more. I don't know how much use this will get, but it doesn't appear
>> to be "wrong" in any way. So I was going to pull it.

Ok, thanks.

>> However, in the meantime we have commit 5360bd776f73 ("Fix up the
>> "generic" unistd.h ABI to be more useful") that clashes with it. Now,
>> the conflict is trivial to resolve, and I could do that easily - it's
>> not a technical problem. But that commit code comments say
>>
>>   + * Architectures may provide up to 16 syscalls of their own
>>   + * starting with this value.
>>   + */
>>   +#define __NR_arch_specific_syscall 244
>>
>> and the new writable rlimits syscall is obviously 244.
>>   
> 
> Jiri and I actually discussed this back on July 20th on LKML when it
> first conflicted in linux-next, and at the time he said he'd move
> prlimit64 to 261 in <asm-generic/unistd.h>.  It looks like what actually
> stuck in linux-next was different, however.  It's partly my fault for
> not following up on this.

I would do that if the tree reached linus's tree earlier, so that I
could rebase my tree on the top of that. Otherwise I couldn't do much
with that.

The resolving (merge) in -next is done by Stephen, so he probably
misunderstood us. (Oh, I could have a for-next branch where I would
merge your tree to solve the -next merging done by Stephen, but it
wouldn't solve the situation we got into now.)

thanks,
-- 
js
suse labs
