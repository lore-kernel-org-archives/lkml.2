Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758601Ab1CCRqK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 12:46:10 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56177 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758465Ab1CCRqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 12:46:08 -0500
MIME-Version: 1.0
In-Reply-To: <1299137483-10975-1-git-send-email-ksumrall@android.com>
References: <1299137483-10975-1-git-send-email-ksumrall@android.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 3 Mar 2011 09:45:38 -0800
Message-ID: <AANLkTik1pNPzPqXaNrLNFnEt4+cknxYdOUwZ9Q=g5PCA@mail.gmail.com>
Subject: Re: [PATCH] Syscalls: reboot: Add options to the reboot syscall to
 remount filesystems ro
To: Ken Sumrall <ksumrall@android.com>
Cc: linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
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

On Wed, Mar 2, 2011 at 11:31 PM, Ken Sumrall <ksumrall@android.com> wrote:
>
> Add 4 new commands to the reboot system call, that do the same thing as the
> RESTART, HALT, POWER_OFF, and RESTART2 commands, but also remount writable
> filesystems as read-only just before doing what the command normally does.

This makes no sense.

If you can change whatever user-land process that does the reboot
system call (and clearly you can, since you're adding new commands and
using those), then why the heck don't you just do the remount-ro from
that same user land?

How many mounted filesystems do you have that it's so hard to keep track of?

                      Linus
