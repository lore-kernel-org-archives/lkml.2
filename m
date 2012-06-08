Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762298Ab2FHRod (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 13:44:33 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:63141 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752127Ab2FHRob convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 13:44:31 -0400
MIME-Version: 1.0
In-Reply-To: <20120608162234.GB17251@fieldses.org>
References: <20120606194233.GA1537@redhat.com> <CA+55aFwxFVLPk4-dp73uccKXepKwjpGFgh0NW1u8d0zYzr=hBA@mail.gmail.com>
 <20120606230040.GA18089@redhat.com> <CA+55aFx_oREEd2XS_aG7PJ7dwzWjgx689V_uRPGWpVS01_++6A@mail.gmail.com>
 <20120606235403.GC30000@ZenIV.linux.org.uk> <20120607002914.GB22223@redhat.com>
 <CA+55aFyp2GUbc218eb5BDyAqz+cOPTJMVcb4ptk+f1_RBB+-mg@mail.gmail.com>
 <20120607011915.GA17566@redhat.com> <20120607012900.GE30000@ZenIV.linux.org.uk>
 <20120607193607.GI30000@ZenIV.linux.org.uk> <20120608162234.GB17251@fieldses.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 8 Jun 2012 10:44:09 -0700
X-Google-Sender-Auth: LMQw7ZoPKoHdyagD0GFt4shlZHY
Message-ID: <CA+55aFzimZezPFpNMdM_HRORWSzJGFLN_Go0Ci+hiZ3Vapu1Fg@mail.gmail.com>
Subject: Re: processes hung after sys_renameat, and 'missing' processes
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Miklos Szeredi <mszeredi@suse.cz>, Jan Kara <jack@suse.cz>,
        Peter Zijlstra <peterz@infradead.org>, linux-fsdevel@vger.kernel.org,
        "J. Bruce Fields" <bfields@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Sage Weil <sage@newdream.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 8, 2012 at 9:22 AM, J. Bruce Fields <bfields@fieldses.org> wrote:
> On Thu, Jun 07, 2012 at 08:36:07PM +0100, Al Viro wrote:
>
>> I really believe that this pair of commits needs to be reverted.  The
>> earlier code used to guarantee that alias would be detached.
>
> In the case that prompted that first commit, the directory in question
> had an alias that was detached (which I'm taking to mean IS_ROOT(dentry)
> was true?), but not flagged DISCONNECTED.  The particular case was only
> reproduceable on an older kernel, and I couldn't find a similar
> reproducer on recent upstream, but I also couldn't convince myself it
> was impossible.
>
> So, maybe the correct thing is to revert that change.  Or maybe it
> should be picking an IS_ROOT dentry instead of a DISCONNECTED one?

I've reverted the changes for now, it looks like the discussion about
them is still on-going, and I think I'll feel happier if we just go
back to the old status quo for the nonce.

            Linus
