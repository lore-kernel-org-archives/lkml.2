Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753761Ab0DYNTT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Apr 2010 09:19:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64650 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753289Ab0DYNTS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Apr 2010 09:19:18 -0400
Message-ID: <4BD4413D.5030808@redhat.com>
Date: Sun, 25 Apr 2010 16:18:53 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Dan Magenheimer <dan.magenheimer@oracle.com>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org, jeremy@goop.org,
       hugh.dickins@tiscali.co.uk, ngupta@vflare.org, JBeulich@novell.com,
       chris.mason@oracle.com, kurt.hackel@oracle.com,
       dave.mccracken@oracle.com, npiggin@suse.de, akpm@linux-foundation.org,
       riel@redhat.com
Subject: Re: Frontswap [PATCH 0/4] (was Transcendent Memory): overview
References: <20100422134249.GA2963@ca-server1.us.oracle.com> <4BD06B31.9050306@redhat.com> <53c81c97-b30f-4081-91a1-7cef1879c6fa@default> <4BD07594.9080905@redhat.com> <b1036777-129b-4531-a730-1e9e5a87cea9@default> <4BD16D09.2030803@redhat.com> <b01d7882-1a72-4ba9-8f46-ba539b668f56@default> <4BD1A74A.2050003@redhat.com> <4830bd20-77b7-46c8-994b-8b4fa9a79d27@default> <4BD1B427.9010905@redhat.com> <4BD1B626.7020702@redhat.com> <5fa93086-b0d7-4603-bdeb-1d6bfca0cd08@default> <4BD3377E.6010303@redhat.com> <1c02a94a-a6aa-4cbb-a2e6-9d4647760e91@default 4BD43033.7090706@redhat.com> <ce808441-fae6-4a33-8335-f7702740097a@default>
In-Reply-To: <ce808441-fae6-4a33-8335-f7702740097a@default>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/25/2010 04:12 PM, Dan Magenheimer wrote:
>>
>> In this case you could use the same mechanism to stop new put_page()s?
>>      
> You are suggesting the hypervisor communicate dynamically-rapidly-changing
> physical memory availability information to a userland daemon in each guest,
> and each daemon communicate this information to each respective kernel
> to notify the kernel that hypervisor memory is not available?
>
> Seems very convoluted to me, and anyway it doesn't eliminate the need
> for a hook placed exactly where the frontswap_put hook is placed.
>    

Yeah, it's pretty ugly.  Balloons typically communicate without a daemon 
too.

>> Seems frontswap is like a reverse balloon, where the balloon is in
>> hypervisor space instead of the guest space.
>>      
> That's a reasonable analogy.  Frontswap serves nicely as an
> emergency safety valve when a guest has given up (too) much of
> its memory via ballooning but unexpectedly has an urgent need
> that can't be serviced quickly enough by the balloon driver.
>    

(or ordinary swap)

-- 
error compiling committee.c: too many arguments to function

