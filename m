Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754101Ab1APWFi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jan 2011 17:05:38 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:51414 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753992Ab1APWFf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jan 2011 17:05:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=fs9p0Wob8knAT9iE5en9nVrkQxzF8u2q7hGmBxVi7m96K6pA1ObqMsLPHfLsNvIpKR
         6lF/nP7RZEmTU3s8H9AJbinZKYrkB1vHLhnpiSGwGR7AViD7I+CY6u+HYLPH9Fp1Mj0W
         OCQ+fKjzcQkGFmV5clhw/yxZ9iwEaQ7aBsYKQ=
MIME-Version: 1.0
In-Reply-To: <20110116213650.GC22723@ZenIV.linux.org.uk>
References: <20110116185745.GB22723@ZenIV.linux.org.uk>
	<AANLkTim1SS2Y1EL9iB2jDSUbqofoaWXig-xHa12Ogm95@mail.gmail.com>
	<20110116213650.GC22723@ZenIV.linux.org.uk>
Date: Sun, 16 Jan 2011 23:05:32 +0100
Message-ID: <AANLkTin1_KDLt7sCvfG=HNzKq2R+j1hScG_n6Ys61jL6@mail.gmail.com>
Subject: Re: [git pull] vfs pile 2 (automount work)
From: Joachim Eastwood <manabian@gmail.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/16/11, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Sun, Jan 16, 2011 at 10:15:31PM +0100, Joachim Eastwood wrote:
>> Hi,
>>
>> On 1/16/11, Al Viro <viro@zeniv.linux.org.uk> wrote:
>> > Al Viro (3):
>> >       sanitize vfsmount refcounting changes
>>
>> f03c65993b98eeb909a4012ce7833c5857d74755 - sanitize vfsmount refcounting
>> changes
>>
>> Breaks my ARM !CONFIG_SMP compile
>>
>>   CC      fs/namespace.o
>> fs/namespace.c: In function 'commit_tree':
>> fs/namespace.c:629: error: 'struct vfsmount' has no member named
>> 'mnt_longterm'
>> fs/namespace.c: In function 'umount_tree':
>> fs/namespace.c:1192: error: 'struct vfsmount' has no member named
>> 'mnt_longterm'
>> fs/namespace.c: In function 'mnt_make_longterm':
>> fs/namespace.c:2246: error: 'struct vfsmount' has no member named
>> 'mnt_longterm'
>> fs/namespace.c: In function 'mnt_make_shortterm':
>> fs/namespace.c:2251: error: 'struct vfsmount' has no member named
>> 'mnt_longterm'
>> fs/namespace.c:2254: error: 'struct vfsmount' has no member named
>> 'mnt_longterm'
>> fs/namespace.c: In function 'dup_mnt_ns':
>> fs/namespace.c:2295: error: 'struct vfsmount' has no member named
>> 'mnt_longterm'
>> fs/namespace.c:2299: error: 'struct vfsmount' has no member named
>> 'mnt_longterm'
>> fs/namespace.c:2305: error: 'struct vfsmount' has no member named
>> 'mnt_longterm'
>> fs/namespace.c: In function 'create_mnt_ns':
>> fs/namespace.c:2351: error: 'struct vfsmount' has no member named
>> 'mnt_longterm'
>
> Aaaaargh... Brown paperbag time - all testing was on SMP boxen ;-/  The fix
> follows.  Linus, I've dropped that into for-linus in usual place
> (git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs-2.6.git/), so if you
> prefer to pull it, it's there.
>
> commit 91ed228ab50daa7aca54faa8bf5208b97e3448b8
> Author: Al Viro <viro@zeniv.linux.org.uk>
> Date:   Sun Jan 16 16:32:11 2011 -0500
>
>     mnt_longterm is there only on SMP
>
>     Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

Thanks,
The patch fixed it.

regards
Joachim Eastwood
