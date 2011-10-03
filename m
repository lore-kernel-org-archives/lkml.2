Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755494Ab1JCLJI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 07:09:08 -0400
Received: from mail3.vodafone.ie ([213.233.128.45]:28047 "EHLO
	mail3.vodafone.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853Ab1JCLJB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 07:09:01 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArQBAGiXiU5tTATM/2dsb2JhbAAMNoRlmAWNbgEBAQQjDwFGEAsNAQoCAgUWCwICCQMCAQIBDzYGDQEFAgEBry2QUIEthGGBEwSZJIRahyE
Message-ID: <4E8997CA.7060404@draigBrady.com>
Date: Mon, 03 Oct 2011 12:08:58 +0100
From: =?UTF-8?B?UMOhZHJhaWcgQnJhZHk=?= <P@draigBrady.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110816 Thunderbird/6.0
MIME-Version: 1.0
To: Dave Young <hidave.darkstar@gmail.com>
CC: Andreas Dilger <aedilger@gmail.com>, Jeff liu <jeff.liu@oracle.com>,
        "Ted Ts'o" <tytso@mit.edu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-ext4 development <linux-ext4@vger.kernel.org>,
        Coreutils <coreutils@gnu.org>
Subject: Re: [BUG] copy file result with zero
References: <CABqxG0feuZCmx=RfxU-50uFK9-P2vNbAMqJUdWM5RhuJifD5Ow@mail.gmail.com> <20111001143900.GH28234@thunk.org> <CABqxG0eiRiCSirXi5rBB0bJ2AJSQjF2dje2BcjbVYEYWgf-zpw@mail.gmail.com> <A2FF8835-2386-47F9-AFF8-4E09BEC4F80E@oracle.com> <CA140AD1-B715-46BF-81B3-EA2069CBC131@dilger.ca> <CABqxG0eMarBn_8xHCOZPq3pae4K01C51Rmxdox7uZr0gWOHGGw@mail.gmail.com>
In-Reply-To: <CABqxG0eMarBn_8xHCOZPq3pae4K01C51Rmxdox7uZr0gWOHGGw@mail.gmail.com>
X-Enigmail-Version: 1.3.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/02/2011 09:43 AM, Dave Young wrote:
> On Sun, Oct 2, 2011 at 4:02 PM, Andreas Dilger <aedilger@gmail.com> wrote:
>> On 2011-10-01, at 11:41 PM, Jeff liu wrote:
>>>> On Sat, Oct 1, 2011 at 10:39 PM, Ted Ts'o <tytso@mit.edu> wrote:
>>>>> On Sat, Oct 01, 2011 at 10:01:35PM +0800, Dave Young wrote:
>>>>>> Weird problem, when I build app from source,
>>>>>> make; make install
>>>>>> run the command, but got "cannot execute binary file"
>>>>>>
>>>>>> hexdump shows the installed binary is full of zero
>>>>>>
>>>>>> Is it related to ext4 fiemap problem described below?
>>>>>> http://lwn.net/Articles/429349/
>>>>>
>>>>> There is general agreement that /bin/cp should not have been relying
>>>>> on FIEMAP, and I believe the more recent versions of /bin/cp have
>>>>> removed that code by default pending implementation of
>>>>> SEEK_HOLE/SEEK_DATA.  That being said, ext4 had a workaround to its
>>>>> FIEMAP implementation that landed in 2.6.39, and you're using
>>>>> 3.1.0-rc6.
>>>
>>> Actually, upstream cp(1) using FIEMAP only if the source file is sparse,  or else, it will do normal copy, i.e, block based.
>>
>> Are there any distros that are shipping with a version of cp that depends on FIEMAP?  That would dramatically increase the severity of this problem, since orders of magnitude more users will hit the problem.
> 
> I'm not sure if it depends on FIEMAP, I think it should be not so old.
> 
>>
>> Dave, what distro were you seeing this problem on, and had you installed/upgraded your coreutils and/or kernel yourself?
> 
> Slackware 13.37, coreutils 8.11
> kernel is always built from linus's git by myself

Coreutils 8.11 was only released for 13 days,
before 8.12 was released specifically to avoid this issue.
Slackware should update.

Coreutils 8.12 only uses a fiemap based copy for
sparse files, where it will do a sync first.
The sparseness heuristic is st_blocks < st_size / st_blksize

cheers,
Pádraig.
