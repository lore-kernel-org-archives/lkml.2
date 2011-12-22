Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755851Ab1LVUxT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 15:53:19 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:65469 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752951Ab1LVUxR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 15:53:17 -0500
MIME-Version: 1.0
In-Reply-To: <4EF391A6.2040504@redhat.com>
References: <1324576939-23619-1-git-send-email-pbonzini@redhat.com>
 <1324576939-23619-3-git-send-email-pbonzini@redhat.com> <CA+55aFzAo5hjCkKe1aaHgyCYc6RYRb8tf+zPTUwO6R8WWd9T-Q@mail.gmail.com>
 <4EF38269.7080804@redhat.com> <CA+55aFz9aRjSaof+vtHRquYn4w3fYd_+qXdNO3M+7kRWWfKxvA@mail.gmail.com>
 <4EF391A6.2040504@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 22 Dec 2011 12:52:55 -0800
X-Google-Sender-Auth: YuVEoVqfrlhGdH2_1z5VGz_h3KQ
Message-ID: <CA+55aFzmCoX17j9h5-RLrPctpf5GAh5i7bG3vDUBKsZoXNFugg@mail.gmail.com>
Subject: Re: [PATCH 2/3] block: fail SCSI passthrough ioctls on partition devices
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, security@kernel.org, pmatouse@redhat.com,
        agk@redhat.com, jbottomley@parallels.com, mchristi@redhat.com,
        msnitzer@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 22, 2011 at 12:23 PM, Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> I disagree.  ENOTTY is perfect in all cases except the compat_ioctl (which
> I'm not denying is ugly, but beautifying it would make everything else
> ugly).

No it's not.

ENOTTTY isn't ever perfect. We should never have used it to begin with
inside the kernel.

Why would it make *anything* else uglier? Just return it, don't try to
change it anywhere. Does it break anything?

> Secondarily, ENOIOCTLCMD is ultimately turned into EINVAL when the system
> call returns (not ENOTTY).

That's a completely independent bug that has been discussed several
times. We probably should just bite the bullet and fix it. EINVAL is
never the right return value (unless the per-ioctl arguments
themselves are invalid, not for bad ioctls).

The EINVAL return comes from some people who didn't understand that
ENOTTY means "no such ioctl" despite the name.

But regardless, for your patch, it shouldn't matter.

                  Linus
