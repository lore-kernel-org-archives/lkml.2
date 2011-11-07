Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753697Ab1KGKS4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 05:18:56 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:64320 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752383Ab1KGKSy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 05:18:54 -0500
MIME-Version: 1.0
In-Reply-To: <4EB7AEE5.8020803@redhat.com>
References: <1320543320-32728-1-git-send-email-agraf@suse.de>
	<CAOJsxLENwuDgt1S2O8XMsgp9uet92gWeS=GFP_6QgW2w7bRQrw@mail.gmail.com>
	<4EB65C5B.8070709@redhat.com>
	<CAOJsxLEi9TU7zHzcH8KScMNm3CRyJA=ANR3ujWX3cqGFqkUxJw@mail.gmail.com>
	<4EB66036.4080102@redhat.com>
	<1320577728.1428.73.camel@jaguar>
	<4EB67486.1070105@redhat.com>
	<CAOJsxLE2_ce+SCT25cmS7iFuH3SyJeYRNHjxG5iBPkodTX1AoA@mail.gmail.com>
	<4EB67D17.7000701@redhat.com>
	<CAOJsxLGRDeMg1CWJ+A6zYCb7dZnm1cm7UL0UVipmJJk4GFGtWA@mail.gmail.com>
	<4EB680D9.2070706@redhat.com>
	<CAOJsxLFpNG1iZt8=XU2xH3x9dFCqjM=+i8y4EMPg0Ah47bYfqg@mail.gmail.com>
	<4EB6B385.4070804@web.de>
	<4EB7AEE5.8020803@redhat.com>
Date: Mon, 7 Nov 2011 12:18:53 +0200
X-Google-Sender-Auth: 6DKaA98cp1wUACMZZKmh_3XLWlM
Message-ID: <CAOJsxLGetY3ChCAMcEqUGXKsqy44hUB1FK1kR9AHphi9DqbYwQ@mail.gmail.com>
Subject: Re: [PATCH] KVM: Add wrapper script around QEMU to test kernels
From: Pekka Enberg <penberg@kernel.org>
To: Gerd Hoffmann <kraxel@redhat.com>
Cc: Jan Kiszka <jan.kiszka@web.de>, Avi Kivity <avi@redhat.com>,
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

On Mon, Nov 7, 2011 at 12:11 PM, Gerd Hoffmann <kraxel@redhat.com> wrote:
> No support for booting from CDROM.
> No support for booting from Network.
> Thus no way to install a new guest image.

Sure. It's a pain point which we need to fix.

On Mon, Nov 7, 2011 at 12:11 PM, Gerd Hoffmann <kraxel@redhat.com> wrote:
> Booting an existing qcow2 guest image failed, the guest started throwing
> I/O errors.  And even to try that I had to manually extract the kernel
> and initrd images from the guest.  Maybe you should check with the Xen
> guys, they have a funky 'pygrub' which sort-of automates the
> copy-kernel-from-guest-image process.

QCOW2 support is experimental. The I/O errors are caused by forced
read-only mode.

On Mon, Nov 7, 2011 at 12:11 PM, Gerd Hoffmann <kraxel@redhat.com> wrote:
> Booting the host kernel failed too.  Standard distro kernel.  The virtio
> bits are modular, not statically compiled into the kernel.  kvm tool
> can't handle that.

I think we have some support for booting modular distro kernels too if
you tell KVM tool where to find initrd. It sucks out-of-the-box though
because nobody seems to be using it.

On Mon, Nov 7, 2011 at 12:11 PM, Gerd Hoffmann <kraxel@redhat.com> wrote:
> You have to build your own kernel and make sure you flip the correct
> config bits, then you can boot it to a shell prompt.  Trying anything
> else just doesn't work today ...

What can I say? Patches welcome? :-)

                        Pekka
