Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758126Ab2CCBRx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 20:17:53 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48343 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755094Ab2CCBRw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 20:17:52 -0500
Message-ID: <4F517133.5070504@zytor.com>
Date: Fri, 02 Mar 2012 17:17:39 -0800
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
References: <alpine.LFD.2.02.1203021544300.28247@i5.linux-foundation.org> <4F516811.8060800@zytor.com> <CA+55aFzoOOCOU-N6Zaq8Dd+U0no0a9U5ndU-LA_TrctM5tPP2Q@mail.gmail.com> <4F516DBA.2030809@zytor.com> <CA+55aFwoifDB9YPC53KrFm1DZNVEzYL4+dfP96GE3rz8YCVaMg@mail.gmail.com>
In-Reply-To: <CA+55aFwoifDB9YPC53KrFm1DZNVEzYL4+dfP96GE3rz8YCVaMg@mail.gmail.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/02/2012 05:11 PM, Linus Torvalds wrote:
> On Fri, Mar 2, 2012 at 5:02 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>>
>> Note that does mean we need a guard page after each and every
>> discontiguous RAM range, not just the last one.  Raising that issue
>> since we have had serious bugs in that area in the past.
> 
> Are you sure? I didn't think we even *mapped* things at that granularity.
> 
> We only really need a guard page at the end of an actual end-of-ram
> where we no longer have page tables and/or could hit device space.
> 

Yes of course.  Note that I'm currently pushing for mapping only RAM
regions; we have a lot of bugs and workarounds related to mapping too
much, and the answer to fixing that should be pretty obvious.

> For robustness and actual deployment, I do think that yes, we do want
> to make it an explicit rule.

Definitely.  Ideally those pages should be zeroed and mapped readonly.

	-hpa



