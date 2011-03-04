Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758633Ab1CDCzN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 21:55:13 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:51356 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758213Ab1CDCzM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 21:55:12 -0500
MIME-Version: 1.0
X-Originating-IP: [76.195.162.181]
In-Reply-To: <4D7052E5.9030506@teksavvy.com>
References: <1299137483-10975-1-git-send-email-ksumrall@android.com>
	<AANLkTik1pNPzPqXaNrLNFnEt4+cknxYdOUwZ9Q=g5PCA@mail.gmail.com>
	<4D6FDDB1.3060209@teksavvy.com>
	<AANLkTimXhGRsuL3Z51msS_YEtsa4UZuN9XW8Xb+hu_KN@mail.gmail.com>
	<AANLkTinQ30f-7bi8QSBjwcmHXH6aydqws1vrFMMaMCWc@mail.gmail.com>
	<AANLkTi=UuVxtvLqWq=8gTGQyoNKmJwvs3Kr=xSWHbxtx@mail.gmail.com>
	<4D7052E5.9030506@teksavvy.com>
Date: Thu, 3 Mar 2011 18:55:11 -0800
Message-ID: <AANLkTinb01zP9kj4ULwqoSHFrkRKA=K9DDG66ndtw-UP@mail.gmail.com>
Subject: Re: [PATCH] Syscalls: reboot: Add options to the reboot syscall to
 remount filesystems ro
From: Scott James Remnant <scott@netsplit.com>
To: Mark Lord <kernel@teksavvy.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ken Sumrall <ksumrall@android.com>, linux-kernel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@lst.de>,
        Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Jens Axboe <axboe@kernel.dk>, Matthew Wilcox <matthew@wil.cx>,
        Eric Paris <eparis@redhat.com>, Dave Young <hidave.darkstar@gmail.com>,
        Jiri Slaby <jslaby@suse.cz>, James Morris <jmorris@namei.org>,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 3, 2011 at 6:48 PM, Mark Lord <kernel@teksavvy.com> wrote:
> On 11-03-03 09:33 PM, Linus Torvalds wrote:
>> On Thu, Mar 3, 2011 at 6:00 PM, Ken Sumrall <ksumrall@android.com> wrote:
>>>
>>> Writing a single byte to /proc/sysrq-trigger is an asynchronous
>>> operation, with no obvious way to be informed that it has completed
>>> the remount.
>>
>> Right you are. That's something of a misfeature, but it comes from the
>> way sysrq works: obviously the "real" sysrq thing is about keyboard
>> input, so all the sysrq stuff has to be async.
>>
>> The fact that that async nature then ends up also affecting the
>> /proc/sysrq-trigger case (which _could_ be synchronous) is a bit sad
>> in this case.
>
> Agreed.
>
> I have the echo s/u to sysrq-trigger (plus a 2-sec sleep ala MS-Win)
> on my Ubuntu systems here, because their shutdown "sequence"
> is racy and buggy, and frequently powers off the box with the
> rootfs still mounted rw otherwise.
>
> And don't get me started about the races on system startup
>  -- "upstart" is an abomination, or at least the Ubuntu use of it is.
>
Ubuntu doesn't use Upstart on shutdown, it uses the plain-old sysv init scripts.

Oddly enough I don't see any bugs filed by you about startup issues?
Now, don't get me wrong, I'm not saying Ubuntu is perfect here - but
I'm not aware of any races that are Upstart's fault. If there are,
please file bugs! How else am I to fix them if I don't know about
them?

Scott
