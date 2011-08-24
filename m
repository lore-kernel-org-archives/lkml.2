Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752098Ab1HXFTJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 01:19:09 -0400
Received: from mail-iy0-f170.google.com ([209.85.210.170]:46922 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750835Ab1HXFTH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 01:19:07 -0400
MIME-Version: 1.0
In-Reply-To: <1314137806-5747-1-git-send-email-agraf@suse.de>
References: <1314137806-5747-1-git-send-email-agraf@suse.de>
Date: Wed, 24 Aug 2011 08:19:07 +0300
X-Google-Sender-Auth: -ZOhtdeIvZYCCtmAkWrA2bh8ne4
Message-ID: <CAOJsxLHzFnP0GuUWyg4U91_AkrK8q5=k1ZhN3JikUxqLQNK5tQ@mail.gmail.com>
Subject: Re: [PATCH] KVM: Add wrapper script around Qemu to test kernels
From: Pekka Enberg <penberg@kernel.org>
To: Alexander Graf <agraf@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Avi Kivity <avi@redhat.com>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org list" <kvm@vger.kernel.org>,
        qemu-devel Developers <qemu-devel@nongnu.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 24, 2011 at 1:16 AM, Alexander Graf <agraf@suse.de> wrote:
> On LinuxCon I had a nice chat with Linus on what he thinks kvm-tool
> would be doing and what he expects from it. Basically he wants a
> small and simple tool he and other developers can run to try out and
> see if the kernel they just built actually works.
>
> Fortunately, Qemu can do that today already! The only piece that was
> missing was the "simple" piece of the equation, so here is a script
> that wraps around Qemu and executes a kernel you just built.
>
> If you do have KVM around and are not cross-compiling, it will use
> KVM. But if you don't, you can still fall back to emulation mode and
> at least check if your kernel still does what you expect. I only
> implemented support for s390x and ppc there, but it's easily extensible
> to more platforms, as Qemu can emulate (and virtualize) pretty much
> any platform out there.
>
> If you don't have qemu installed, please do so before using this script. Your
> distro should provide a package for it (might even call it "kvm"). If not,
> just compile it from source - it's not hard!
>
> To quickly get going, just execute the following as user:
>
>    $ ./Documentation/run-qemu.sh -r / -a init=/bin/bash
>
> This will drop you into a shell on your rootfs.
>
> Happy hacking!

It's nice to see such an honest attempt at improving QEMU usability, Alexander!

One comment: in my experience, having shell scripts under
Documentation reduces the likelihood that people actually discover
them so you might want to consider putting it under scripts or tools.

                        Pekka
