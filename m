Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754230Ab0DYOPl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Apr 2010 10:15:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27185 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752413Ab0DYOPk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Apr 2010 10:15:40 -0400
Message-ID: <4BD44E74.2020506@redhat.com>
Date: Sun, 25 Apr 2010 17:15:16 +0300
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
References: <20100422134249.GA2963@ca-server1.us.oracle.com> <4BD06B31.9050306@redhat.com> <53c81c97-b30f-4081-91a1-7cef1879c6fa@default> <4BD07594.9080905@redhat.com> <b1036777-129b-4531-a730-1e9e5a87cea9@default> <4BD16D09.2030803@redhat.com> <b01d7882-1a72-4ba9-8f46-ba539b668f56@default> <4BD1A74A.2050003@redhat.com> <4830bd20-77b7-46c8-994b-8b4fa9a79d27@default> <4BD1B427.9010905@redhat.com> <b559c57a-0acb-4338-af21-dbfc3b3c0de5@default> <4BD336CF.1000103@redhat.com> <d1bb78ca-5ef6-4a8d-af79-a265f2d4339c@default 4BD43182.1040508@redhat.com> <c5062f3a-3232-4b21-b032-2ee1f2485ff0@default>
In-Reply-To: <c5062f3a-3232-4b21-b032-2ee1f2485ff0@default>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/25/2010 04:37 PM, Dan Magenheimer wrote:
>> My issue is with the API's synchronous nature.  Both RAM and more
>> exotic
>> memories can be used with DMA instead of copying.  A synchronous
>> interface gives this up.
>>   :
>> Let's not allow the urge to merge prevent us from doing the right
>> thing.
>>   :
>> I see.  Given that swap-to-flash will soon be way more common than
>> frontswap, it needs to be solved (either in flash or in the swap code).
>>      
> While I admit that I started this whole discussion by implying
> that frontswap (and cleancache) might be useful for SSDs, I think
> we are going far astray here.  Frontswap is synchronous for a
> reason: It uses real RAM, but RAM that is not directly addressable
> by a (guest) kernel.  SSD's (at least today) are still I/O devices;
> even though they may be very fast, they still live on a PCI (or
> slower) bus and use DMA.  Frontswap is not intended for use with
> I/O devices.
>
> Today's memory technologies are either RAM that can be addressed
> by the kernel, or I/O devices that sit on an I/O bus.  The
> exotic memories that I am referring to may be a hybrid:
> memory that is fast enough to live on a QPI/hypertransport,
> but slow enough that you wouldn't want to randomly mix and
> hand out to userland apps some pages from "exotic RAM" and some
> pages from "normal RAM".  Such memory makes no sense today
> because OS's wouldn't know what to do with it.  But it MAY
> make sense with frontswap (and cleancache).
>
> Nevertheless, frontswap works great today with a bare-metal
> hypervisor.  I think it stands on its own merits, regardless
> of one's vision of future SSD/memory technologies.
>    

Even when frontswapping to RAM on a bare metal hypervisor it makes sense 
to use an async API, in case you have a DMA engine on board.

-- 
error compiling committee.c: too many arguments to function

