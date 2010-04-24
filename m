Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752525Ab0DXSZW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Apr 2010 14:25:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9754 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751179Ab0DXSZV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Apr 2010 14:25:21 -0400
Message-ID: <4BD3377E.6010303@redhat.com>
Date: Sat, 24 Apr 2010 21:25:02 +0300
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
References: <20100422134249.GA2963@ca-server1.us.oracle.com> <4BD06B31.9050306@redhat.com> <53c81c97-b30f-4081-91a1-7cef1879c6fa@default> <4BD07594.9080905@redhat.com> <b1036777-129b-4531-a730-1e9e5a87cea9@default> <4BD16D09.2030803@redhat.com> <b01d7882-1a72-4ba9-8f46-ba539b668f56@default> <4BD1A74A.2050003@redhat.com> <4830bd20-77b7-46c8-994b-8b4fa9a79d27@default> <4BD1B427.9010905@redhat.com 4BD1B626.7020702@redhat.com> <5fa93086-b0d7-4603-bdeb-1d6bfca0cd08@default>
In-Reply-To: <5fa93086-b0d7-4603-bdeb-1d6bfca0cd08@default>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23/2010 07:26 PM, Dan Magenheimer wrote:
>>
>> Looks like "init" == open, "put_page" == write, "get_page" == read,
>> "flush_page|flush_area" == trim.  The only difference seems to be that
>> an overwriting put_page may fail.  Doesn't seem to be much of a win,
>>      
> No, ANY put_page can fail, and this is a critical part of the API
> that provides all of the flexibility for the hypervisor and all
> the guests. (See previous reply.)
>    

The guest isn't required to do any put_page()s.  It can issue lots of 
them when memory is available, and keep them in the hypervisor forever.  
Failing new put_page()s isn't enough for a dynamic system, you need to 
be able to force the guest to give up some of its tmem.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

