Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755757Ab2CCBDF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 20:03:05 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48270 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752787Ab2CCBDD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 20:03:03 -0500
Message-ID: <4F516DBA.2030809@zytor.com>
Date: Fri, 02 Mar 2012 17:02:50 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andi Kleen <andi@firstfloor.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: Word-at-a-time dcache name accesses (was Re: .. anybody know
 of any filesystems that depend on the exact VFS 'namehash' implementation?)
References: <alpine.LFD.2.02.1203021544300.28247@i5.linux-foundation.org> <4F516811.8060800@zytor.com> <CA+55aFzoOOCOU-N6Zaq8Dd+U0no0a9U5ndU-LA_TrctM5tPP2Q@mail.gmail.com>
In-Reply-To: <CA+55aFzoOOCOU-N6Zaq8Dd+U0no0a9U5ndU-LA_TrctM5tPP2Q@mail.gmail.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/02/2012 04:57 PM, Linus Torvalds wrote:
> On Fri, Mar 2, 2012 at 4:38 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>>
>> My biggest concern is what happens when this happens to be at the end of
>> mapped kernel memory and we overrun the page?
> 
> Yes. It's very unlikely, and it never happens with the dentry data
> itself (the name is always aligned for those).
> 
> But it *can* happen if:
> 
>  - the page contains the filename we copied from user space
> 
>  - the page is the last page mapped
> 
>  - the filename is PATH_MAX in size (or very close)
> 
>  - the last component is sufficiently unaligned
> 
> but I was thinking we'd just make sure not to free the last page, and
> just solve it that way.
> 
> I was playing around with other ideas (take the page fault and fix it
> up), but those are all really complicated when the notion of "don't
> use the last page" is so much simpler.
> 

Note that does mean we need a guard page after each and every
discontiguous RAM range, not just the last one.  Raising that issue
since we have had serious bugs in that area in the past.

	-hpa


