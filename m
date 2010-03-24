Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932276Ab0CXSxR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 14:53:17 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:1052 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932645Ab0CXSxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 14:53:15 -0400
Message-ID: <4BAA5F99.3050904@caviumnetworks.com>
Date: Wed, 24 Mar 2010 11:53:13 -0700
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Joakim Tjernlund <Joakim.Tjernlund@transmode.se>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [RFC] #define __BYTE_ORDER
References: <1268849455-19503-1-git-send-email-Joakim.Tjernlund@transmode.se>	 <20100324112106.c8e7b96d.akpm@linux-foundation.org> <10f740e81003241137y382d155fnb777344d3af25f03@mail.gmail.com>
In-Reply-To: <10f740e81003241137y382d155fnb777344d3af25f03@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 Mar 2010 18:53:14.0016 (UTC) FILETIME=[41E4FA00:01CACB83]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/24/2010 11:37 AM, Geert Uytterhoeven wrote:
> On Wed, Mar 24, 2010 at 19:21, Andrew Morton<akpm@linux-foundation.org>  wrote:
>> On Wed, 17 Mar 2010 19:10:55 +0100
>> Joakim Tjernlund<Joakim.Tjernlund@transmode.se>  wrote:
>>
>>> Linux does not define __BYTE_ORDER in its endian header files
>>> which makes some header files bend backwards to get at the
>>> current endian. Lets #define __BYTE_ORDER in big_endian.h/litte_endian.h
>>> to make it easier for header files that are used in user space too.
>>
>> I don't get it.  Why not nuke __BYTE_ORDER altogether and do `#ifdef
>> __LITTLE_ENDIAN' and `#ifdef __BIG_ENDIAN' everywhere?
>
> Because in userspace the convention is that
>    1. _both_ __LITTLE_ENDIAN and __BIG_ENDIAN are defined,
>    2. you have to test for e.g. __BYTE_ORDER == __BIG_ENDIAN.
>

I have stumbled on this issue as well.

However, consider this:

If you make such a change, then you will start to see:

#if __BYTE_ORDER == __BIG_ENDIAN

appearing in kernel source code.  Do we want two different endian 
checking idioms in the kernel?  Or would it be just a single idiom, but 
one that is different than the status quo?

The only time I can see that it makes a difference is if you want to 
share things like driver source code files between in-kernel drivers and 
userspace.  A discussion of which, would probably provoke much discussion.

David Daney


