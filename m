Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752488Ab2KECej (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2012 21:34:39 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:47640 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406Ab2KECei (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2012 21:34:38 -0500
MIME-Version: 1.0
In-Reply-To: <20121102201048.GA20993@blackbox.djwong.org>
References: <CAEH94LjTedn0n00ZtqFxBL=kDA3u8G39q+x79-vPoMYvEKW1gw@mail.gmail.com>
	<CAEH94LgUcAL6RquMZKTrDg87_0J2sEqTsDXUbnhrQ37KuMJ4sg@mail.gmail.com>
	<20121102084109.GA19753@gmail.com>
	<20121102201048.GA20993@blackbox.djwong.org>
Date: Mon, 5 Nov 2012 10:34:34 +0800
Message-ID: <CAEH94Lg-m=BAaaUfpN=vYWKjJQEZLXED=znSiH5OCnaY+6JzCQ@mail.gmail.com>
Subject: Re: VFS hot tracking: How to calculate data temperature?
From: Zhi Yong Wu <zwu.kernel@gmail.com>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-fsdevel@vger.kernel.org, linuxram@linux.vnet.ibm.com,
        Dave Chinner <david@fromorbit.com>, cmm@us.ibm.com,
        Ben Chociej <bchociej@gmail.com>,
        James Northrup <northrup.james@gmail.com>,
        linux-kernel mlist <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 3, 2012 at 4:10 AM, Darrick J. Wong <darrick.wong@oracle.com> wrote:
> On Fri, Nov 02, 2012 at 04:41:09PM +0800, Zheng Liu wrote:
>> On Fri, Nov 02, 2012 at 02:38:29PM +0800, Zhi Yong Wu wrote:
>> > Here also has another question.
>> >
>> > How to save the file temperature among the umount to be able to
>> > preserve the file tempreture after reboot?
>> >
>> > This above is the requirement from DB product.
>> > I thought that we can save file temperature in its inode struct, that
>> > is, add one new field in struct inode, then this info will be written
>> > to disk with inode.
>> >
>> > Any comments or ideas are appreciated, thanks.
>>
>> Hi Zhiyong,
>>
>> I think that we might define a callback function.  If a filesystem wants
>> to save these data, it can implement a function to save them.  The
>> filesystem can decide whether adding it or not by themselves.
>>
>> BTW, actually I don't really care about how to save these data because I
>> only want to observe which file is accessed in real time, which is very
>> useful for me to track a problem in our product system.
>
> <shrug> I _think_ the vfs quota code simply asks the filesystem for a special
> inode where it save the quota data in whatever (FS-agnostic) format it wants.
> Have you considered something like that?
No, but it is one good hint for my issue. thanks.
>
> (Or, maybe everyone secretly hates doing that?  Secret files, yaaay...)
ah, do you think of doing that?

>
> --D
>>
>> Regards,
>> Zheng
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Regards,

Zhi Yong Wu
