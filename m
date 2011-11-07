Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753355Ab1KGKMT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 05:12:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48185 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752640Ab1KGKMR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 05:12:17 -0500
Message-ID: <4EB7AEE5.8020803@redhat.com>
Date: Mon, 07 Nov 2011 11:11:49 +0100
From: Gerd Hoffmann <kraxel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110927 Red Hat/3.1.15-1.el6_1 Thunderbird/3.1.15
MIME-Version: 1.0
To: Jan Kiszka <jan.kiszka@web.de>
CC: Pekka Enberg <penberg@kernel.org>, Avi Kivity <avi@redhat.com>,
        "kvm@vger.kernel.org list" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        qemu-devel Developers <qemu-devel@nongnu.org>,
        Alexander Graf <agraf@suse.de>, Blue Swirl <blauwirbel@gmail.com>,
        =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
        Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] KVM: Add wrapper script around QEMU to test kernels
References: <1320543320-32728-1-git-send-email-agraf@suse.de> <CAOJsxLENwuDgt1S2O8XMsgp9uet92gWeS=GFP_6QgW2w7bRQrw@mail.gmail.com> <4EB65C5B.8070709@redhat.com> <CAOJsxLEi9TU7zHzcH8KScMNm3CRyJA=ANR3ujWX3cqGFqkUxJw@mail.gmail.com> <4EB66036.4080102@redhat.com> <1320577728.1428.73.camel@jaguar> <4EB67486.1070105@redhat.com> <CAOJsxLE2_ce+SCT25cmS7iFuH3SyJeYRNHjxG5iBPkodTX1AoA@mail.gmail.com> <4EB67D17.7000701@redhat.com> <CAOJsxLGRDeMg1CWJ+A6zYCb7dZnm1cm7UL0UVipmJJk4GFGtWA@mail.gmail.com> <4EB680D9.2070706@redhat.com> <CAOJsxLFpNG1iZt8=XU2xH3x9dFCqjM=+i8y4EMPg0Ah47bYfqg@mail.gmail.com> <4EB6B385.4070804@web.de>
In-Reply-To: <4EB6B385.4070804@web.de>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi,

> "Usable" - I've tried kvm-tool several times and still (today) fail to
> get a standard SUSE image (with a kernel I have to compile and provide
> separately...) up and running *). Likely a user mistake, but none that
> is very obvious. At least to me.

Same here.

No support for booting from CDROM.
No support for booting from Network.
Thus no way to install a new guest image.

Booting an existing qcow2 guest image failed, the guest started throwing
I/O errors.  And even to try that I had to manually extract the kernel
and initrd images from the guest.  Maybe you should check with the Xen
guys, they have a funky 'pygrub' which sort-of automates the
copy-kernel-from-guest-image process.

Booting the host kernel failed too.  Standard distro kernel.  The virtio
bits are modular, not statically compiled into the kernel.  kvm tool
can't handle that.

You have to build your own kernel and make sure you flip the correct
config bits, then you can boot it to a shell prompt.  Trying anything
else just doesn't work today ...

cheers,
  Gerd
