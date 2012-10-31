Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932700Ab2JaCa0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 22:30:26 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:34949 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752875Ab2JaCaX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 22:30:23 -0400
MIME-Version: 1.0
In-Reply-To: <50908354.5070608@cn.fujitsu.com>
References: <0a2274eccf1b1dd420f16359f7e1de74fa2f9fbe.1351131144.git.hutao@cn.fujitsu.com>
 <20121031011256.GC12325@amt.cnet> <50908354.5070608@cn.fujitsu.com>
From: Sasha Levin <levinsasha928@gmail.com>
Date: Tue, 30 Oct 2012 22:30:02 -0400
Message-ID: <CA+1xoqdcaeAm05_=rx3h9KHph+j7Ab8vRG_w9yUk7jtn+wHuBg@mail.gmail.com>
Subject: Re: [PATCH v11] kvm: notify host when the guest is panicked
To: Wen Congyang <wency@cn.fujitsu.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>, Hu Tao <hutao@cn.fujitsu.com>,
        kvm list <kvm@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Avi Kivity <avi@redhat.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, Gleb Natapov <gleb@redhat.com>,
        Blue Swirl <blauwirbel@gmail.com>, Eric Blake <eblake@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Luiz Capitulino <lcapitulino@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 30, 2012 at 9:48 PM, Wen Congyang <wency@cn.fujitsu.com> wrote:
> At 10/31/2012 09:12 AM, Marcelo Tosatti Wrote:
>> It has been asked earlier why a simple virtio device is not usable
>> for this (with no response IIRC).
>
> 1. We can't use virtio device when the kernel is booting.

So the issue here is the small window between the point the guest
becomes "self aware" and to the point virtio drivers are loaded,
right?

I agree that if something happens during that interval, a
"virtio-notifier" driver won't catch that, but anything beyond that is
better done with a virtio driver, so how is the generic infrastructure
added in this patch useful to anything beyond detecting panics in that
initial interval?

> 2. The virtio's driver can be built as a module, and if it is not loaded
>    and the kernel is panicked, there is no way to notify the host.

Even if the suggested virtio-notifier driver is built as a module, it
would get auto-loaded when the guest is booting, so I'm not sure about
this point?

> 3. I/O port is more reliable than virtio device.
>    If virtio's driver has some bug, and it cause kernel panicked, we can't
>    use it. The I/O port is more reliable because it only depends on notifier
>    chain(If we use virtio device, it also depends on notifier chain).

This is like suggesting that we let KVM emulate virtio-blk on it's
own, parallel to the virtio implementation, so that even if there's a
problem with virtio-blk, KVM can emulate a virtio-blk on it's own.

Furthermore, why stop at virtio? What if the KVM code has a bug and it
doesn't pass IO properly? Or the x86 code? we still want panic
notifications if that happens...


Thanks,
Sasha
