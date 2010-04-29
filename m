Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759362Ab0D3TQ6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 15:16:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50812 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757998Ab0D3QzK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 12:55:10 -0400
Message-ID: <4BD9D5BE.4010000@redhat.com>
Date: Thu, 29 Apr 2010 21:53:50 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Dan Magenheimer <dan.magenheimer@oracle.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, jeremy@goop.org, hugh.dickins@tiscali.co.uk,
       ngupta@vflare.org, JBeulich@novell.com, chris.mason@oracle.com,
       kurt.hackel@oracle.com, dave.mccracken@oracle.com, npiggin@suse.de,
       akpm@linux-foundation.org, riel@redhat.com
Subject: Re: Frontswap [PATCH 0/4] (was Transcendent Memory): overview
References: <4BD16D09.2030803@redhat.com> <b01d7882-1a72-4ba9-8f46-ba539b668f56@default> <4BD1A74A.2050003@redhat.com> <4830bd20-77b7-46c8-994b-8b4fa9a79d27@default> <4BD1B427.9010905@redhat.com> <4BD1B626.7020702@redhat.com> <5fa93086-b0d7-4603-bdeb-1d6bfca0cd08@default> <4BD3377E.6010303@redhat.com> <1c02a94a-a6aa-4cbb-a2e6-9d4647760e91@default4BD43033.7090706@redhat.com> <ce808441-fae6-4a33-8335-f7702740097a@default> <20100428055538.GA1730@ucw.cz>
In-Reply-To: <20100428055538.GA1730@ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/28/2010 08:55 AM, Pavel Machek wrote:
>
>> That's a reasonable analogy.  Frontswap serves nicely as an
>> emergency safety valve when a guest has given up (too) much of
>> its memory via ballooning but unexpectedly has an urgent need
>> that can't be serviced quickly enough by the balloon driver.
>>      
> wtf? So lets fix the ballooning driver instead?
>    

You can't have a negative balloon size.  The two models are not equivalent.

Balloon allows you to give up a page for which you have a struct page.  
Frontswap (and swap) allows you to gain a page for which you don't have 
a struct page, but you can't access it directly.  The similarity is that 
in both cases the host may want the guest to give up a page, but cannot 
force it.

> There's no reason it could not be as fast as frontswap, right?
> Actually I'd expect it to be faster -- it can deal with big chunks.
>    

There's no reason for swapping and ballooning to behave differently when 
swap backing storage is RAM (they probably do now since swap was tuned 
for disks, not flash, but that's a bug if it's true).

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

