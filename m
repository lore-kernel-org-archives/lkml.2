Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754691Ab0DNJcB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 05:32:01 -0400
Received: from mail-ew0-f220.google.com ([209.85.219.220]:40478 "EHLO
	mail-ew0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754423Ab0DNJb7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 05:31:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=N7Spc2ePri9Zjh/8IgY0zAgZwwiCqM2tmpIHtBfDzjMslqn2U/vYwQKTjRiknZFLpp
         UoZPIDWbkJ22WFpYA1ml7ZjnTeYBhUihFL++yYVsyo6BORCYDnMgyfWfzLJG/s/ptymX
         r5bIWwAxZby8uyHTk8J6iAYl6FeYe01TbQCcQ=
Message-ID: <4BC58B85.1020204@gmail.com>
Date: Wed, 14 Apr 2010 11:31:49 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.2pre) Gecko/20100308 SUSE/3.1b1-6.2 Thunderbird/3.1b1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Alexey Dobriyan <adobriyan@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       Neil Horman <nhorman@tuxdriver.com>, Oleg Nesterov <oleg@redhat.com>
Subject: Re: [git pull] pull request for writable limits for 2.6.34-rc0
References: <4B1D32D1.4090404@gmail.com> <4B9136F4.4010007@gmail.com> <alpine.LFD.2.00.1003201207160.18017@i5.linux-foundation.org> <20100321060607.GA4062@x200> <alpine.LFD.2.00.1003211128520.18017@i5.linux-foundation.org> <4BAA4595.3050203@gmail.com>
In-Reply-To: <4BAA4595.3050203@gmail.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/24/2010 06:02 PM, Jiri Slaby wrote:
> On 03/21/2010 07:38 PM, Linus Torvalds wrote:
>> Or even just _one_ system call that takes two pointers, and can do an 
>> atomic replace-and-return-the-old-value, like 'sigaction()' does, ie 
>> something like
>>
>> 	int prlimit64(pid, limit, const struct rlimit64 *new, struct rlimit64 *old);
>>
>> wouldn't that be a nice generic interface?
> 
> Seconded. But should the limits be by default 64-bit even on 32-bit? I
> mean: switch 'struct limit' in signal_struct to 'struct rlimit64'? This
> would make the limits non-atomic on 32-bit. Oh, they are not already if
> reader wants both cur and max without any locks, but I'm not sure now
> what implications this will have (I haven't checked compilers, but I
> think a store of 00000001 0000000 in place of 00000000 ffffffff may
> result in a read of 00000001 ffffffff or alike). Or did I misunderstand you?

Maybe it is a silly question or you was just busy at that time?

thanks,
-- 
js
