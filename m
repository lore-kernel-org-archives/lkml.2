Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753991Ab2DBBhm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 21:37:42 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47642 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753772Ab2DBBhl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 21:37:41 -0400
References: <20120401125741.GA7484@p183.telecom.by> <4F78D0BA.9040709@zytor.com> <CAGZ=bqJ4mAwzuHk5rDbvKTfR_Qi=QiPt6MrwbVhe7H63Yba2Wg@mail.gmail.com>
User-Agent: K-9 Mail for Android
In-Reply-To: <CAGZ=bqJ4mAwzuHk5rDbvKTfR_Qi=QiPt6MrwbVhe7H63Yba2Wg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] nextfd(2)
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Sun, 01 Apr 2012 18:37:26 -0700
To: Kyle Moffett <kyle@moffetthome.net>
CC: Alexey Dobriyan <adobriyan@gmail.com>, akpm@linux-foundation.org,
        viro@zeniv.linux.org.uk, torvalds@linux-foundation.org,
        drepper@gmail.com, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Message-ID: <782e192e-e1b5-4c53-895d-1eac4a4c9097@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Are those use cases heavyweight enough to motivate a new interface?

Kyle Moffett <kyle@moffetthome.net> wrote:

>On Sun, Apr 1, 2012 at 15:03, H. Peter Anvin <hpa@zytor.com> wrote:
>> On 04/01/2012 05:57 AM, Alexey Dobriyan wrote:
>>> * /proc/self/fd is unreliable:
>>>   proc may be unconfigured or not mounted at expected place.
>>>   Looking at /proc/self/fd requires opening directory
>>>   which may not be available due to malicious rlimit drop or ENOMEM
>situations.
>>>   Not opening directory is equivalent to dumb close(2) loop except
>slower.
>>
>> This is really the motivation for this... the real question is how
>much
>> functionality is actually available in the system without /proc
>mounted,
>> and in particular if this particular subcase is worth optimizing ...
>> after all, if someone is maliciously setting rlimit, we can just
>abort
>> (if someone can set an rlimit they can also force an abort) or revert
>to
>> the slow path.
>
>Well, I imagine one typical usecase for closing all FDs is for
>security isolation purposes (EG: chroot()+etc), and in a great deal of
>chroot environments you don't have /proc available.  In particular
>/proc has been a source of a lot of privilege escalations in the past,
>so avoiding mounting it in a chroot is good security policy if
>possible.
>
>Cheers,
>Kyle Moffett

-- 
Sent from my mobile phone. Please excuse my brevity and lack of formatting.
