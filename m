Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757440Ab2AEREx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 12:04:53 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:52199 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754871Ab2AEREw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 12:04:52 -0500
MIME-Version: 1.0
In-Reply-To: <4F05D286.7030205@redhat.com>
References: <1324576939-23619-3-git-send-email-pbonzini@redhat.com>
 <CA+55aFzAo5hjCkKe1aaHgyCYc6RYRb8tf+zPTUwO6R8WWd9T-Q@mail.gmail.com>
 <4EF38269.7080804@redhat.com> <CA+55aFz9aRjSaof+vtHRquYn4w3fYd_+qXdNO3M+7kRWWfKxvA@mail.gmail.com>
 <4EF391A6.2040504@redhat.com> <CA+55aFzmCoX17j9h5-RLrPctpf5GAh5i7bG3vDUBKsZoXNFugg@mail.gmail.com>
 <4EF3AA74.1060801@redhat.com> <CA+55aFw+ipBQFTj9SbNjE1KkS+xNpY7RdF1emSf7WrzavyReqA@mail.gmail.com>
 <20111222234830.GC31021@agk-dp.fab.redhat.com> <CA+55aFxqy1wJFFVbykBJWuGm8YAjA-VP=xAqHttVOwC_zuxvOA@mail.gmail.com>
 <20111223062649.GD21994@1wt.eu> <CA+55aFxnOwkquH8tirqJnM_KTcavAejY8drL11jy2S+2PXmZuw@mail.gmail.com>
 <4EF48CE4.3000104@redhat.com> <CA+55aFy=7wGzQv76dirJ=ZjeNdbKVKDRCLA323orsE13GcKvwQ@mail.gmail.com>
 <4F05A332.1060600@redhat.com> <CA+55aFwcZjxZsVV_9rsKgApDfEMdCdHYvkDW5Wz7j-=gd_tFeQ@mail.gmail.com>
 <4F05D286.7030205@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 5 Jan 2012 09:04:31 -0800
X-Google-Sender-Auth: A8isvSPKCI8risHFvcnCXOuRNy8
Message-ID: <CA+55aFwi2xWsmRb+kMsqJ5cq5c8WD=iPZS9WXU=9VRVaJCu2sQ@mail.gmail.com>
Subject: Re: [PATCH 2/3] block: fail SCSI passthrough ioctls on partition devices
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Willy Tarreau <w@1wt.eu>, linux-kernel@vger.kernel.org,
        security@kernel.org, pmatouse@redhat.com, agk@redhat.com,
        jbottomley@parallels.com, mchristi@redhat.com, msnitzer@redhat.com,
        Christoph Hellwig <hch@lst.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 5, 2012 at 8:40 AM, Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> Aha, so this is clear and obvious.  And who knows that something else won't
> break?  Such as the 32-on-64 logic that already uses ENOIOCTLCMD for
> something else?

Exactly. Which is why we can try to do this in the merge window, and
fix up the fallout.

> Foolish me who found a bug, and an exploitable one for that matter, and even
> tried to fix it.  Looks like security by obscurity would have served users better.

Umm. I just sent out what I think is what we *should* be doing.

You are the one who seems to just want to add hack upon hack to
things. THAT is what I really hate. It's not only in bad taste, it
*will* come back and bite us some day.

If you think that "security" is about adding new special cases and
hacks, you're so out to lunch that it isn't even funny. It is
absolutely the *last* thing you want.

                    Linus
