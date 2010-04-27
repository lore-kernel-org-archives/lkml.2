Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754222Ab0D0JWd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 05:22:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54345 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751451Ab0D0JWb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 05:22:31 -0400
Message-ID: <4BD6AC85.9000009@redhat.com>
Date: Tue, 27 Apr 2010 12:21:09 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Dan Magenheimer <dan.magenheimer@oracle.com>
CC: ngupta@vflare.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       jeremy@goop.org, hugh.dickins@tiscali.co.uk, JBeulich@novell.com,
       chris.mason@oracle.com, kurt.hackel@oracle.com,
       dave.mccracken@oracle.com, npiggin@suse.de, akpm@linux-foundation.org,
       riel@redhat.com
Subject: Re: Frontswap [PATCH 0/4] (was Transcendent Memory): overview
References: <20100422134249.GA2963@ca-server1.us.oracle.com> <4BD06B31.9050306@redhat.com> <53c81c97-b30f-4081-91a1-7cef1879c6fa@default> <4BD07594.9080905@redhat.com> <b1036777-129b-4531-a730-1e9e5a87cea9@default> <4BD16D09.2030803@redhat.com> <b01d7882-1a72-4ba9-8f46-ba539b668f56@default> <4BD1A74A.2050003@redhat.com> <4830bd20-77b7-46c8-994b-8b4fa9a79d27@default> <4BD1B427.9010905@redhat.com> <4BD24E37.30204@vflare.org> <4BD33822.2000604@redhat.com> <4BD3B2D1.8080203@vflare.org> <4BD4329A.9010509@redhat.com> <4BD4684E.9040802@vflare.org> <4BD52D55.3070803@redhat.com> <2634f2cb-3e7e-4c86-b7ef-cf4a3f1e0d8a@default 4BD5987F.7080505@redhat.com> <a0c1615e-c64a-4d4a-bd49-9e3e614d031b@default>
In-Reply-To: <a0c1615e-c64a-4d4a-bd49-9e3e614d031b@default>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/27/2010 11:29 AM, Dan Magenheimer wrote:
>
> OK, so on the one hand, you think that the proposed synchronous
> interface for frontswap is insufficiently extensible for other
> uses (presumably including KVM).  On the other hand, you agree
> that using the existing I/O subsystem is unnecessarily heavyweight.
> On the third hand, Nitin has answered your questions and spent
> a good part of three years finding that extending the existing swap
> interface to efficiently support swap-to-pseudo-RAM requires
> some kind of in-kernel notification mechanism to which Linus
> has already objected.
>
> So you are instead proposing some new guest-to-host asynchronous
> notification mechanism that doesn't use the existing bio
> mechanism (and so presumably not irqs),

(any notification mechanism has to use irqs if it exits the guest)

> imitates or can
> utilize a dma engine, and uses less cpu cycles than copying
> pages.  AND, for long-term maintainability, you'd like to avoid
> creating a new guest-host API that does all this, even one that
> is as simple and lightweight as the proposed frontswap hooks.
>
> Does that summarize your objection well?
>    

No.  Adding a new async API that parallels the block layer would be 
madness.  My first preference would be to completely avoid new APIs.  I 
think that would work for swap-to-hypervisor but probably not for 
compcache.  Second preference is the synchronous API, third is a new 
async API.

-- 
error compiling committee.c: too many arguments to function

