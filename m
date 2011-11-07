Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752933Ab1KGVgN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 16:36:13 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:42459 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752212Ab1KGVgK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 16:36:10 -0500
MIME-Version: 1.0
In-Reply-To: <20111107203255.GF24234@thunk.org>
References: <CAOJsxLFGAnNL9uA=WHD8eJVs5V2+BSrtC+3ff2FsPi326dtjZw@mail.gmail.com>
	<4EB6BAED.2030400@redhat.com>
	<4EB6BEFA.6000303@codemonkey.ws>
	<20111106183132.GA4500@thunk.org>
	<CAOJsxLHvYo5zA+_m-AXuZHjAcGKE5q0ytmPCZ0Gye52LWq1p9Q@mail.gmail.com>
	<CAOJsxLG6kyq-RoQiBj0B_tThvOy1AxJf6XB2VfQFQJkwQ5cHcQ@mail.gmail.com>
	<20111106231953.GD4500@thunk.org>
	<alpine.LFD.2.02.1111070838520.1823@tux.localdomain>
	<alpine.DEB.2.02.1111071156230.28615@pianoman.cluster.toy>
	<CAOJsxLEfapPPU8cEfeCMq9_oG6858YzFS_fkWQEo_fxs+xde9A@mail.gmail.com>
	<20111107203255.GF24234@thunk.org>
Date: Mon, 7 Nov 2011 23:36:09 +0200
X-Google-Sender-Auth: X2LMXqC4xeTooONB8WyP9_ETHCo
Message-ID: <CAOJsxLEKx5M5L_N42pQpo2hcNhseQKhUo6CXAyQHesJRWFASKQ@mail.gmail.com>
Subject: Re: [Qemu-devel] [PATCH] KVM: Add wrapper script around QEMU to test kernels
From: Pekka Enberg <penberg@kernel.org>
To: "Ted Ts'o" <tytso@mit.edu>, Pekka Enberg <penberg@kernel.org>,
        Vince Weaver <vince@deater.net>,
        Anthony Liguori <anthony@codemonkey.ws>, Avi Kivity <avi@redhat.com>,
        "kvm@vger.kernel.org list" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        qemu-devel Developers <qemu-devel@nongnu.org>,
        Alexander Graf <agraf@suse.de>, Blue Swirl <blauwirbel@gmail.com>,
        =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
        Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ted,

On Mon, Nov 7, 2011 at 10:32 PM, Ted Ts'o <tytso@mit.edu> wrote:
> Personally, I consider code that runs in userspace as a pretty bright
> line, as being "not kernel code", and while perhaps things like
> initramfs and the crazy ideas people have had in the past of moving
> stuff out of kernel/init.c into userspace might have qualified as
> stuff really close to the kernel, something like kvm-tool that runs
> way after boot, doesn't even come close.  Wine is another example of
> another package that has lots of close kernel ties, but was also not
> bundled into the kernel.

It's not as clear line as you make it out to be.

KVM tool also has mini-BIOS code that runs in guest space. It has a
code that runs in userspace but is effectively a simple bootloader. So
it definitely doesn't fit the simple definition of "running way after
boot" (we're _booting_ the kernel too).

Linsched fits your definition but is clearly worth integrating to the
kernel tree. While you are suggesting that maybe we should move Perf
out of the tree now that it's mature, I'm pretty sure you'd agree that
it probably would not have happened if the userspace parts were
developed out of tree.

There's also spectacular failures in the kernel history where the
userspace split was enforced. For example, userspace suspend didn't
turn out the way people envisioned it at the time. We don't know how
it would have worked out if the userspace components would have been
in the tree but it certainly would have solved many if the early ABI
issues.

I guess I'm trying to argue here that there's a middle ground. I'm
willing to bet projects like klibc and unified initramfs will
eventually make it to the kernel tree because they simply make so much
sense. I'm also willing to be that the costs of moving Perf out of the
tree are simply too high to make it worthwhile.

Does that mean KVM tool should get a free pass in merging? Absolutely
not. But I do think your position is too extreme and ignores the
benefits of developing userspace tools in the kernel ecosystem which
was summed up by Anthony rather well in this thread:

https://lkml.org/lkml/2011/11/7/169

                                Pekka
