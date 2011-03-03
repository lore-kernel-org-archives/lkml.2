Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758464Ab1CCSSY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 13:18:24 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56777 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758536Ab1CCSSW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 13:18:22 -0500
MIME-Version: 1.0
In-Reply-To: <AANLkTik1pNPzPqXaNrLNFnEt4+cknxYdOUwZ9Q=g5PCA@mail.gmail.com>
References: <1299137483-10975-1-git-send-email-ksumrall@android.com> <AANLkTik1pNPzPqXaNrLNFnEt4+cknxYdOUwZ9Q=g5PCA@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 3 Mar 2011 10:17:32 -0800
Message-ID: <AANLkTi=z0gHbrGPUZ+vvNPGrOzGowBuWjMUEZpqS+ZCc@mail.gmail.com>
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

On Thu, Mar 3, 2011 at 9:45 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> How many mounted filesystems do you have that it's so hard to keep track of?

Btw, /proc/mounts will track them for you even if you don't have a
'mount' binary that does.

Parsing that is pretty trivial. If you have spaces or special
characters in your pathnames (you may control the mount paths, you may
not - I have no idea), you'll need to be able to handle the escape
format (\oct). But other than that, it's literally just

 - read all of /proc/mounts into a buffer

 - for each line, split by space, and you'll have the directory name
right there in the second field

 - do the unescaping ("\oct" -> character) if needed. It's good
practice. Test it.

 - just do a read-only remount on it.

All done. No kernel changes necessary. It just works.

                            Linus
