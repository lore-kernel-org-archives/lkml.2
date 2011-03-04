Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758545Ab1CDCsQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 21:48:16 -0500
Received: from ironport2-out.teksavvy.com ([206.248.154.183]:60881 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758280Ab1CDCsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 21:48:14 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApIBAHPhb01Ld/sX/2dsb2JhbAAMhB7RI5ELgSeDRHYEhRo
X-IronPort-AV: E=Sophos;i="4.62,262,1297054800"; 
   d="scan'208";a="94333347"
Message-ID: <4D7052E5.9030506@teksavvy.com>
Date: Thu, 03 Mar 2011 21:48:05 -0500
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-GB; rv:1.9.2.14) Gecko/20110221 Thunderbird/3.1.8
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ken Sumrall <ksumrall@android.com>, linux-kernel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@lst.de>,
        Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Jens Axboe <axboe@kernel.dk>, Matthew Wilcox <matthew@wil.cx>,
        Eric Paris <eparis@redhat.com>, Dave Young <hidave.darkstar@gmail.com>,
        Jiri Slaby <jslaby@suse.cz>, James Morris <jmorris@namei.org>,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] Syscalls: reboot: Add options to the reboot syscall to
 remount filesystems ro
References: <1299137483-10975-1-git-send-email-ksumrall@android.com> <AANLkTik1pNPzPqXaNrLNFnEt4+cknxYdOUwZ9Q=g5PCA@mail.gmail.com> <4D6FDDB1.3060209@teksavvy.com> <AANLkTimXhGRsuL3Z51msS_YEtsa4UZuN9XW8Xb+hu_KN@mail.gmail.com> <AANLkTinQ30f-7bi8QSBjwcmHXH6aydqws1vrFMMaMCWc@mail.gmail.com> <AANLkTi=UuVxtvLqWq=8gTGQyoNKmJwvs3Kr=xSWHbxtx@mail.gmail.com>
In-Reply-To: <AANLkTi=UuVxtvLqWq=8gTGQyoNKmJwvs3Kr=xSWHbxtx@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11-03-03 09:33 PM, Linus Torvalds wrote:
> On Thu, Mar 3, 2011 at 6:00 PM, Ken Sumrall <ksumrall@android.com> wrote:
>>
>> Writing a single byte to /proc/sysrq-trigger is an asynchronous
>> operation, with no obvious way to be informed that it has completed
>> the remount.
> 
> Right you are. That's something of a misfeature, but it comes from the
> way sysrq works: obviously the "real" sysrq thing is about keyboard
> input, so all the sysrq stuff has to be async.
> 
> The fact that that async nature then ends up also affecting the
> /proc/sysrq-trigger case (which _could_ be synchronous) is a bit sad
> in this case.

Agreed.

I have the echo s/u to sysrq-trigger (plus a 2-sec sleep ala MS-Win)
on my Ubuntu systems here, because their shutdown "sequence"
is racy and buggy, and frequently powers off the box with the
rootfs still mounted rw otherwise.

And don't get me started about the races on system startup
 -- "upstart" is an abomination, or at least the Ubuntu use of it is.

Cheers
