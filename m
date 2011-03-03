Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759115Ab1CCXhI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 18:37:08 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59243 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758752Ab1CCXhG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 18:37:06 -0500
MIME-Version: 1.0
In-Reply-To: <4D6FDDB1.3060209@teksavvy.com>
References: <1299137483-10975-1-git-send-email-ksumrall@android.com>
 <AANLkTik1pNPzPqXaNrLNFnEt4+cknxYdOUwZ9Q=g5PCA@mail.gmail.com> <4D6FDDB1.3060209@teksavvy.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 3 Mar 2011 15:36:27 -0800
Message-ID: <AANLkTimXhGRsuL3Z51msS_YEtsa4UZuN9XW8Xb+hu_KN@mail.gmail.com>
Subject: Re: [PATCH] Syscalls: reboot: Add options to the reboot syscall to
 remount filesystems ro
To: Mark Lord <kernel@teksavvy.com>
Cc: Ken Sumrall <ksumrall@android.com>, linux-kernel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@lst.de>,
        Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Jens Axboe <axboe@kernel.dk>, Matthew Wilcox <matthew@wil.cx>,
        Eric Paris <eparis@redhat.com>, Dave Young <hidave.darkstar@gmail.com>,
        Jiri Slaby <jslaby@suse.cz>, James Morris <jmorris@namei.org>,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 3, 2011 at 10:28 AM, Mark Lord <kernel@teksavvy.com> wrote:
> On 11-03-03 12:45 PM, Linus Torvalds wrote:
>>
>> If you can change whatever user-land process that does the reboot
>> system call (and clearly you can, since you're adding new commands and
>> using those), then why the heck don't you just do the remount-ro from
>> that same user land?
>
> Is there a system call for emergency_remount_*() ?
> I've been writing to /proc/proc/sysrq-trigger to accomplish this.

So I don't know what this has to do with "emergency_remount()" - we're
talking about a regular controlled shutdown/reset. The fact that the
patch used the emergency_remount() code seems to be purely an
implementation issue, nothing more.

And while sysrq-trigger certainly works (when it's enabled, but that's
true of /proc too, of course), I do think it's a rather odd way of
solving the problem, when the simple "just remount read-only" is what
the code actually _wants_ to do.

But you're certainly right that it takes less code to open
/proc/sysrq-trigger and writing a single byte to it than it does to do
the straightforward "let's just do the normal mount thing".

                             Linus
