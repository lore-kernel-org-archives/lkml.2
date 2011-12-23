Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757924Ab1LWWqf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 17:46:35 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:50161 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754476Ab1LWWqd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 17:46:33 -0500
MIME-Version: 1.0
In-Reply-To: <4EF48CE4.3000104@redhat.com>
References: <1324576939-23619-3-git-send-email-pbonzini@redhat.com>
 <CA+55aFzAo5hjCkKe1aaHgyCYc6RYRb8tf+zPTUwO6R8WWd9T-Q@mail.gmail.com>
 <4EF38269.7080804@redhat.com> <CA+55aFz9aRjSaof+vtHRquYn4w3fYd_+qXdNO3M+7kRWWfKxvA@mail.gmail.com>
 <4EF391A6.2040504@redhat.com> <CA+55aFzmCoX17j9h5-RLrPctpf5GAh5i7bG3vDUBKsZoXNFugg@mail.gmail.com>
 <4EF3AA74.1060801@redhat.com> <CA+55aFw+ipBQFTj9SbNjE1KkS+xNpY7RdF1emSf7WrzavyReqA@mail.gmail.com>
 <20111222234830.GC31021@agk-dp.fab.redhat.com> <CA+55aFxqy1wJFFVbykBJWuGm8YAjA-VP=xAqHttVOwC_zuxvOA@mail.gmail.com>
 <20111223062649.GD21994@1wt.eu> <CA+55aFxnOwkquH8tirqJnM_KTcavAejY8drL11jy2S+2PXmZuw@mail.gmail.com>
 <4EF48CE4.3000104@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 23 Dec 2011 14:46:11 -0800
X-Google-Sender-Auth: Ac9LEp597VgQ7l5Yeohex1wORhk
Message-ID: <CA+55aFy=7wGzQv76dirJ=ZjeNdbKVKDRCLA323orsE13GcKvwQ@mail.gmail.com>
Subject: Re: [PATCH 2/3] block: fail SCSI passthrough ioctls on partition devices
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Willy Tarreau <w@1wt.eu>, linux-kernel@vger.kernel.org,
        security@kernel.org, pmatouse@redhat.com, agk@redhat.com,
        jbottomley@parallels.com, mchristi@redhat.com, msnitzer@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 23, 2011 at 6:15 AM, Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> But does it actually do anything?  For me, "eject /dev/sdf1" does nothing
> beyond unmounting the disk.  Yes, it sends a CDROMEJECT ioctl which becomes
> a start/stop unit SCSI command, but it has no effect on the USB stick I
> tried.

Guys, you are TOTALLY MISSING THE POINT.

The point is that the patch-series is damned dangerous. You have no
clue at all what it will do on various different distributions and
with various different hardware.

What's so hard to understand about this? Applying it at this point in
the release cycle with basically *zero* testing would be crazy. I gave
you just one example of where real people do ioctl's on a partition,
and where the behavior of the kernel clearly changes as a result.

The fact is, partitions are what most user interactions see. Suddenly
totally changing things and saying "you can't do that on a partition"
when clearly people *have* been doing that on partitions isn't
something we can do without serious testing.

No amount of "it didn't change in the one situation I tested" is going
to change that. What about somebody running their own distro (there's
this Russian distro maker who regularly finds regressions that nobody
else has ever seen)? What about somebody upgrading kernels on a
five-year-old user space (== pretty much any of the "enterprise"
distros)? What about other random hardware than just the USB disk
example that I gave?

It sounds like people didn't even *think* of the potential issues this
patch can bring. I'd absolutely be insane to apply them for -rc7.

             Linus
