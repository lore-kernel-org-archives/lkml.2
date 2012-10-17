Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757213Ab2JQOUG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 10:20:06 -0400
Received: from relay.parallels.com ([195.214.232.42]:40279 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751748Ab2JQOUF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 10:20:05 -0400
Message-ID: <507EBE8C.2030707@parallels.com>
Date: Wed, 17 Oct 2012 18:19:56 +0400
From: Stanislav Kinsbursky <skinsbursky@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: "peterz@infradead.org" <peterz@infradead.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@openvz.org" <devel@openvz.org>
Subject: Re: [RFC PATCH v2] posix timers: allocate timer id per task
References: <20121017131732.8781.75295.stgit@localhost.localdomain> <1350481466.26103.464.camel@edumazet-glaptop>
In-Reply-To: <1350481466.26103.464.camel@edumazet-glaptop>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

17.10.2012 17:44, Eric Dumazet пишет:
> On Wed, 2012-10-17 at 17:18 +0400, Stanislav Kinsbursky wrote:
>
>> +static int hash(struct signal_struct *sig, unsigned int nr)
>> +{
>> +	int hash = hash_ptr(sig, POSIX_TIMERS_HASH_BITS);
>> +	return hash ^ hash_32(nr, POSIX_TIMERS_HASH_BITS);
>> +}
>> +
>
> This is quite expensive on 64 bit arches. I suggest instead :
>
> return hash_32(hash32_ptr(sig) ^ nr, POSIX_TIMERS_HASH_BITS);
>
>

I'm not familiar with hashing costs, so sure, I'll update.

-- 
Best regards,
Stanislav Kinsbursky
