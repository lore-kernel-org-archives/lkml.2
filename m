Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758578Ab0EMKQg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 06:16:36 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:60382 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758509Ab0EMKQf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 06:16:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=dXv6Ph9K9oBXEdGYF9MjVI73psVIIEeYymDOh73LfrNvXadBq5NQO5qbkHiwwU5g4R
         7rhE1iVUIsmAADSzVfNP0IxQ/eYOACh5Hnk3ne66KbGbEZoGha1Hd9trMwx6A35GqQiZ
         RZq+lafsafuCw1OhxlIztb+C/KslPwFVa+Azo=
Message-ID: <4BEBD180.3040404@suse.cz>
Date: Thu, 13 May 2010 12:16:32 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.5pre) Gecko/20100430 SUSE/3.1b2-7.1 Thunderbird/3.1b2
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Changli Gao <xiaosuo@gmail.com>, akpm@linux-foundation.org,
       Eric Dumazet <eric.dumazet@gmail.com>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Alexey Dobriyan <adobriyan@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Avi Kivity <avi@redhat.com>,
       Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Subject: Re: [RFC] mm: generic adaptive large memory allocation APIs
References: <20100513174512.2179.A69D9226@jp.fujitsu.com> <4BEBC43F.6070407@suse.cz> <20100513182403.217C.A69D9226@jp.fujitsu.com>
In-Reply-To: <20100513182403.217C.A69D9226@jp.fujitsu.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/13/2010 11:40 AM, KOSAKI Motohiro wrote:
>>>> Anyway as this is a replacement for explicit tests, it shouldn't change
>>>> the behaviour in any way. Obviously when a user doesn't need virtually
>>>> contiguous space, he shouldn't use this interface at all.
>>>
>>> Why can't we make fdtable virtually contiguous free?
>>
>> This is possible, but the question is why to make the code more complex?
> 
> because  it's broken.

Well, could you explain what exactly is broken about
x = kmalloc(size, GFP_KERNEL);
if (!x)
  x = vmalloc(size);
? Is is that kmalloc doesn't return until is has the memory to return
when asking for order(size) <= COSTLY_ORDER? I think this is expected.

thanks,
-- 
js
suse labs
