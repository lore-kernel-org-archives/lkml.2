Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752219Ab0DZNso (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 09:48:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7991 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751312Ab0DZNsn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 09:48:43 -0400
Message-ID: <4BD599A7.6090202@redhat.com>
Date: Mon, 26 Apr 2010 16:48:23 +0300
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
References: <20100422134249.GA2963@ca-server1.us.oracle.com> <4BD06B31.9050306@redhat.com> <53c81c97-b30f-4081-91a1-7cef1879c6fa@default> <4BD07594.9080905@redhat.com> <b1036777-129b-4531-a730-1e9e5a87cea9@default> <4BD16D09.2030803@redhat.com> <b01d7882-1a72-4ba9-8f46-ba539b668f56@default> <4BD1A74A.2050003@redhat.com> <4830bd20-77b7-46c8-994b-8b4fa9a79d27@default> <4BD1B427.9010905@redhat.com> <b559c57a-0acb-4338-af21-dbfc3b3c0de5@default> <4BD336CF.1000103@redhat.com> <d1bb78ca-5ef6-4a8d-af79-a265f2d4339c@default> <4BD43182.1040508@redhat.com> <c5062f3a-3232-4b21-b032-2ee1f2485ff0@default> <4BD44E74.2020506@redhat.com> <7264e3c0-15fe-4b70-a3d8-2c36a2b934df@default 4BD52C4F.40505@redhat.com> <f038ee35-8b34-4305-b93a-49383c86f83e@default>
In-Reply-To: <f038ee35-8b34-4305-b93a-49383c86f83e@default>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/26/2010 03:45 PM, Dan Magenheimer wrote:
>> dma engines are present on commodity hardware now:
>>
>> http://en.wikipedia.org/wiki/I/O_Acceleration_Technology
>>
>> I don't know if consumer machines have them, but servers certainly do.
>> modprobe ioatdma.
>>      
> They don't seem to have gained much ground in the FIVE YEARS
> since the patch was first posted to Linux, have they?
>    

Why do you say this?  Servers have them and AFAIK networking uses them.  
There are other uses of the API in the code, but I don't know how much 
of this is for bulk copies.

> Maybe it's because memory-to-memory copy using a CPU
> is so fast (especially for page-ish quantities of data)
> and is a small percentage of CPU utilization these days?
>    

Copies take a small percentage of cpu because a lot of care goes into 
avoiding them, or placing them near the place where the copy is used.  
They certainly show up in high speed networking.

A page-sized copy is small, but many of them will be expensive.

-- 
error compiling committee.c: too many arguments to function

