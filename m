Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756532Ab1CVRbW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 13:31:22 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59024 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756393Ab1CVRbU convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 13:31:20 -0400
MIME-Version: 1.0
In-Reply-To: <20110322153018.790784895@szeredi.hu>
References: <20110322152602.053930811@szeredi.hu> <20110322153018.790784895@szeredi.hu>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 22 Mar 2011 10:30:30 -0700
Message-ID: <AANLkTimS-x-+JGvpEbHcWyEMcp-nCno8kwuaBAcTjDnV@mail.gmail.com>
Subject: Re: [PATCH 4/6 v7] overlay filesystem prototype
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        apw@canonical.com, nbd@openwrt.org, neilb@suse.de
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 22, 2011 at 8:26 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>
>  fs/Kconfig               |    1
>  fs/Makefile              |    1
>  fs/overlayfs/Kconfig     |    4
>  fs/overlayfs/Makefile    |    5
>  fs/overlayfs/overlayfs.c | 2394 +++++++++++++++++++++++++++++++++++++++++++++++
>  5 files changed, 2405 insertions(+)

Just one single C file? Is there no structure to the code at all? No
separate issues for directory lookup vs file operations, no helper
libraries vs core ops? No "mount time" vs "runtime" structure to the
code?

So 2400 lines isn't all that much, but things have a tendency to grow.
So when I see one single file that tries to do everything, I go "hmm".
Normal filesystems tend to have super.c for handling the mount itself,
and dir.c vs file.c for directory ops vs file ops. Maybe this doesn't
have a file.c because that's all delegated to the lower filesystems,
but still.. Just one file?

Yeah, yeah, we have those horrible drivers that have 10k+ files, and
there are certainly filesystems with much bigger files, but I'd still
wish for more structure.  You've got a whole subdirectory of your own.

                          Linus
