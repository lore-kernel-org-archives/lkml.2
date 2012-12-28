Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753828Ab2L1PlA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 10:41:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23183 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753686Ab2L1Pk4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 10:40:56 -0500
Date: Fri, 28 Dec 2012 16:40:19 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrey Vagin <avagin@openvz.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, criu@openvz.org,
        linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, Dave Jones <davej@redhat.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>
Subject: Re: [PATCH 3/3] signalfd: add ability to read siginfo-s without
	dequeuing signals (v3)
Message-ID: <20121228154019.GA31095@redhat.com>
References: <1356690181-1796-1-git-send-email-avagin@openvz.org> <1356690181-1796-4-git-send-email-avagin@openvz.org> <20121228143200.GB24229@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121228143200.GB24229@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/28, Oleg Nesterov wrote:
>
> On 12/28, Andrey Vagin wrote:
> >
> > @@ -338,6 +379,7 @@ SYSCALL_DEFINE4(signalfd4, int, ufd, sigset_t __user *, user_mask,
> >  		}
> >
> >  		file->f_flags |= flags & SFD_RAW;
> > +		file->f_mode |= FMODE_PREAD;
>
> Again, this is not needed or the code was broken by the previous patch.
>
> Given that 2/3 passes O_RDWR to anon_inode_getfile() I think FMODE_PREAD
> should be already set. Note OPEN_FMODE(flags) in anon_inode_getfile().

As you explained in another thread I was wrong, I confused FMODE_PREAD
and FMODE_READ.

Oleg.

