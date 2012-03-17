Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030228Ab2CQHw3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2012 03:52:29 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:63997 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790Ab2CQHwZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2012 03:52:25 -0400
MIME-Version: 1.0
In-Reply-To: <1331969567.3022.233.camel@deadeye>
References: <20120316233829.GA14022@kroah.com>
	<20120316233811.484341257@linuxfoundation.org>
	<20120317023740.GH12704@decadent.org.uk>
	<CAKywueTUH_Zrh7iD_zsyvtmLt9O2dbd_KNrzNWzFQm4z8ZtbcQ@mail.gmail.com>
	<1331969567.3022.233.camel@deadeye>
Date: Sat, 17 Mar 2012 11:52:24 +0400
X-Google-Sender-Auth: vMjR4YaC07DFXG6zb1HLEhj4tDE
Message-ID: <CAKywueQoKN51mea7TkpT3WS=Vgj5ijNn1pOSb3cC=UZ9vVu6dw@mail.gmail.com>
Subject: Re: [ 10/41] CIFS: Do not kmalloc under the flocks spinlock
From: Pavel Shilovsky <piastry@etersoft.ru>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jeff Layton <jlayton@redhat.com>, Steve French <sfrench@us.ibm.com>
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

17 марта 2012 г. 11:32 пользователь Ben Hutchings <ben@decadent.org.uk> написал:
> On Sat, 2012-03-17 at 10:14 +0400, Pavel Shilovsky wrote:
>> 17 марта 2012 г. 6:37 пользователь Ben Hutchings <ben@decadent.org.uk> написал:
>> > On Fri, Mar 16, 2012 at 04:38:20PM -0700, Greg KH wrote:
>> >> 3.2-stable review patch.  If anyone has any objections, please let me know.
> [...]
>> > But we test this before flock->fl_flags & FL_POSIX, which means we
>> > don't know whether this lock actually needs to be assigned one of
>> > those structures.  So it appears that we might report a spurious error
>> > if the lock list ends with a mandatory lock.  If so, this is
>> > relatively harmless but does need to be fixed.
>> >
>>
>> You are right here, thanks for the catch! I will repost the patch asap.
>
> This has already been merged into Linus's tree, so you need to submit a
> patch to apply on top of it.
>

I posted two patches:
1) the whole fixed version for the stable tree [PATCH v2] CIFS: Do not
kmalloc under the flocks spinlock
2) fixup for mainline [PATCH] CIFS: Fix a spurious error in
cifs_push_posix_locks

-- 
Best regards,
Pavel Shilovsky.
