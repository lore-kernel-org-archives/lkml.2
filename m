Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759387Ab2FGBkq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 21:40:46 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:46244 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752507Ab2FGBkp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 21:40:45 -0400
MIME-Version: 1.0
In-Reply-To: <20120607011915.GA17566@redhat.com>
References: <CA+55aFwCusEdMq3_3TAXSZ=+kbN7H6AbnngVaagAZw=ZpicckQ@mail.gmail.com>
 <20120603231709.GP30000@ZenIV.linux.org.uk> <20120603232820.GQ30000@ZenIV.linux.org.uk>
 <20120606194233.GA1537@redhat.com> <CA+55aFwxFVLPk4-dp73uccKXepKwjpGFgh0NW1u8d0zYzr=hBA@mail.gmail.com>
 <20120606230040.GA18089@redhat.com> <CA+55aFx_oREEd2XS_aG7PJ7dwzWjgx689V_uRPGWpVS01_++6A@mail.gmail.com>
 <20120606235403.GC30000@ZenIV.linux.org.uk> <20120607002914.GB22223@redhat.com>
 <CA+55aFyp2GUbc218eb5BDyAqz+cOPTJMVcb4ptk+f1_RBB+-mg@mail.gmail.com> <20120607011915.GA17566@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 6 Jun 2012 18:40:23 -0700
X-Google-Sender-Auth: U8ZSkhbnnpmRa5XPGFmLrpVNaKg
Message-ID: <CA+55aFysx_AA7QvOcZSaJPYPdaGvg6p_6u3fmNtn23a71F7ouw@mail.gmail.com>
Subject: Re: processes hung after sys_renameat, and 'missing' processes
To: Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Miklos Szeredi <mszeredi@suse.cz>, Jan Kara <jack@suse.cz>,
        Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 6, 2012 at 6:19 PM, Dave Jones <davej@redhat.com> wrote:
>
> ok, I ended up with..
>
>        WARN_ON_ONCE(!mutex_is_locked(&target->d_parent->d_inode->i_mutex));
>
>        if (dentry->d_parent != NULL)
>                WARN_ON_ONCE(!mutex_is_locked(&dentry->d_inode->i_mutex));

It should just be something like

    WARN_ON_ONCE(!mutex_is_locked(&dentry->d_parent->d_inode->i_mutex));
    WARN_ON_ONCE(!mutex_is_locked(&target->d_parent->d_inode->i_mutex));

(And doing it as two separate ones rather than one that tests both is
probably a good idea, so that you see *which* one it is that triggers
if they do)

                    Linus
