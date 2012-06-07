Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759425Ab2FGBqA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 21:46:00 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:45145 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756629Ab2FGBp7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 21:45:59 -0400
MIME-Version: 1.0
In-Reply-To: <20120607013149.GF30000@ZenIV.linux.org.uk>
References: <20120603232820.GQ30000@ZenIV.linux.org.uk> <20120606194233.GA1537@redhat.com>
 <CA+55aFwxFVLPk4-dp73uccKXepKwjpGFgh0NW1u8d0zYzr=hBA@mail.gmail.com>
 <20120606230040.GA18089@redhat.com> <CA+55aFx_oREEd2XS_aG7PJ7dwzWjgx689V_uRPGWpVS01_++6A@mail.gmail.com>
 <20120606235403.GC30000@ZenIV.linux.org.uk> <20120607002914.GB22223@redhat.com>
 <CA+55aFyp2GUbc218eb5BDyAqz+cOPTJMVcb4ptk+f1_RBB+-mg@mail.gmail.com>
 <20120607011915.GA17566@redhat.com> <20120607012900.GE30000@ZenIV.linux.org.uk>
 <20120607013149.GF30000@ZenIV.linux.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 6 Jun 2012 18:45:35 -0700
X-Google-Sender-Auth: r3VdCX7i8ImJxOaWV47c4rgOrWQ
Message-ID: <CA+55aFx3QT0AA+s=M+QyJFKqQNh0cHiunwZ=fyrc1eneJTtarQ@mail.gmail.com>
Subject: Re: processes hung after sys_renameat, and 'missing' processes
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Miklos Szeredi <mszeredi@suse.cz>, Jan Kara <jack@suse.cz>,
        Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 6, 2012 at 6:31 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> And you want to check i_mutex on old parent, not the file being moved
> itself.  IOW, the second one should be
>
> if (dentry->d_parent != dentry)
>        WARN_ON_ONCE(!mutex_is_locked(&dentry->d_parent->d_inode->i_mutex));

Do you even need the "dentry->d_parent != dentry" test? When do we
even rename root dentries?

I do notice that we have that IS_ROOT() test in __d_move(), but now
that I look at it I wonder *why* we have it..

Anyway, Dave, you should probably trust Al over me here - that test
obviously won't hurt, even if I can't see immediately when it would
trigger either.

              Linus
