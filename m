Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756197Ab1LWJXF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 04:23:05 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:58035 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755604Ab1LWJWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 04:22:46 -0500
MIME-Version: 1.0
In-Reply-To: <20111223062649.GD21994@1wt.eu>
References: <1324576939-23619-3-git-send-email-pbonzini@redhat.com>
 <CA+55aFzAo5hjCkKe1aaHgyCYc6RYRb8tf+zPTUwO6R8WWd9T-Q@mail.gmail.com>
 <4EF38269.7080804@redhat.com> <CA+55aFz9aRjSaof+vtHRquYn4w3fYd_+qXdNO3M+7kRWWfKxvA@mail.gmail.com>
 <4EF391A6.2040504@redhat.com> <CA+55aFzmCoX17j9h5-RLrPctpf5GAh5i7bG3vDUBKsZoXNFugg@mail.gmail.com>
 <4EF3AA74.1060801@redhat.com> <CA+55aFw+ipBQFTj9SbNjE1KkS+xNpY7RdF1emSf7WrzavyReqA@mail.gmail.com>
 <20111222234830.GC31021@agk-dp.fab.redhat.com> <CA+55aFxqy1wJFFVbykBJWuGm8YAjA-VP=xAqHttVOwC_zuxvOA@mail.gmail.com>
 <20111223062649.GD21994@1wt.eu>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 23 Dec 2011 01:22:24 -0800
X-Google-Sender-Auth: nmUA0eeMd92YQO7PohVRtNXIjjE
Message-ID: <CA+55aFxnOwkquH8tirqJnM_KTcavAejY8drL11jy2S+2PXmZuw@mail.gmail.com>
Subject: Re: [PATCH 2/3] block: fail SCSI passthrough ioctls on partition devices
To: Willy Tarreau <w@1wt.eu>
Cc: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        security@kernel.org, pmatouse@redhat.com, agk@redhat.com,
        jbottomley@parallels.com, mchristi@redhat.com, msnitzer@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 22, 2011 at 10:26 PM, Willy Tarreau <w@1wt.eu> wrote:
>
> Call me dumb, but why would someone use "eject" on a non-physically
> ejectable device such as a memory stick ?

Perhaps because that's the operation that works everywhere and is the
simplest one?

Just look at the icon on your desktop - it probably has "Eject" above
the silly "Safely remove drive" when you right-click it. It has for
me.

And I've taught myself (and my wife) to always eject media before
removing them. I don't "unmount" them, because then for cdroms I need
to first unmount them and then eject them. Or I'd need to do different
operations for different devices. Both of which are just stupid.

So yes, I claim that "eject" is actually the *natural* thing to do
before you physically remove the medium, because it works across
different media.

But more importantly, we don't break what works. So what the f&^k was
the point of even asking? THAT was the "dumb" thing here.

                                    Linus
