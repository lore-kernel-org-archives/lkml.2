Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932772Ab2AEQQ1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 11:16:27 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:38035 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757613Ab2AEQQ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 11:16:26 -0500
MIME-Version: 1.0
In-Reply-To: <4F05A332.1060600@redhat.com>
References: <1324576939-23619-3-git-send-email-pbonzini@redhat.com>
 <CA+55aFzAo5hjCkKe1aaHgyCYc6RYRb8tf+zPTUwO6R8WWd9T-Q@mail.gmail.com>
 <4EF38269.7080804@redhat.com> <CA+55aFz9aRjSaof+vtHRquYn4w3fYd_+qXdNO3M+7kRWWfKxvA@mail.gmail.com>
 <4EF391A6.2040504@redhat.com> <CA+55aFzmCoX17j9h5-RLrPctpf5GAh5i7bG3vDUBKsZoXNFugg@mail.gmail.com>
 <4EF3AA74.1060801@redhat.com> <CA+55aFw+ipBQFTj9SbNjE1KkS+xNpY7RdF1emSf7WrzavyReqA@mail.gmail.com>
 <20111222234830.GC31021@agk-dp.fab.redhat.com> <CA+55aFxqy1wJFFVbykBJWuGm8YAjA-VP=xAqHttVOwC_zuxvOA@mail.gmail.com>
 <20111223062649.GD21994@1wt.eu> <CA+55aFxnOwkquH8tirqJnM_KTcavAejY8drL11jy2S+2PXmZuw@mail.gmail.com>
 <4EF48CE4.3000104@redhat.com> <CA+55aFy=7wGzQv76dirJ=ZjeNdbKVKDRCLA323orsE13GcKvwQ@mail.gmail.com>
 <4F05A332.1060600@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 5 Jan 2012 08:16:06 -0800
X-Google-Sender-Auth: 75V6783Vf1JkunukG2CuHPpPQvM
Message-ID: <CA+55aFwcZjxZsVV_9rsKgApDfEMdCdHYvkDW5Wz7j-=gd_tFeQ@mail.gmail.com>
Subject: Re: [PATCH 2/3] block: fail SCSI passthrough ioctls on partition devices
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Willy Tarreau <w@1wt.eu>, linux-kernel@vger.kernel.org,
        security@kernel.org, pmatouse@redhat.com, agk@redhat.com,
        jbottomley@parallels.com, mchristi@redhat.com, msnitzer@redhat.com,
        Christoph Hellwig <hch@lst.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 5, 2012 at 5:18 AM, Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> Hence, changing scsi_verify_blk_ioctl to return ENOIOCTLCMD is not
> really possible.

What?

"We have a bug in the block IO layer, so we cannot possible fix
another problem?"

Whjat the f*ck is the logic there?

Just fix the *obvious* breakage in BLKROSET. It's clearly what the
code *intends* to do, it just didn't check for ENOIOCTLCMD.

In fact, fixing that BLKROSET case would make it much more obvious
*why* it has those error tests at all. And we really should try to
just remove the crazy EINVAL case, because it really is wrong - and
then fix any broken drivers that exposes.

It's a DISEASE how you seem to think that "we have ugly mistakes in
the kernel, SO LET'S ADD ANOTHER ONE".

That's not how we do things. We *fix* things, instead of making things
even *worse*.

Stop this insanity from spreading, instead of making it spread more!

                           Linus
