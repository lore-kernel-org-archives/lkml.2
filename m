Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932671Ab1KHOQL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 09:16:11 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:51766 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755871Ab1KHOPx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 09:15:53 -0500
MIME-Version: 1.0
In-Reply-To: <87aa87sd4y.fsf@rustcorp.com.au>
References: <20111104114033.GA21308@redhat.com> <1320409939.3334.6.camel@lappy>
 <20111104135113.GA24452@redhat.com> <1320414804.3334.13.camel@lappy>
 <20111104142338.GB24452@redhat.com> <1320418385.3334.25.camel@lappy>
 <20111106073007.GA7146@redhat.com> <1320611097.3299.10.camel@lappy>
 <20111106213849.GA14292@redhat.com> <871utktsuw.fsf@rustcorp.com.au>
 <20111107211413.GA11577@redhat.com> <87aa87sd4y.fsf@rustcorp.com.au>
From: Sasha Levin <levinsasha928@gmail.com>
Date: Tue, 8 Nov 2011 16:15:31 +0200
Message-ID: <CA+1xoqf0TzBtOwV1Uaz8Fph9KCpekF9vdRWQGczRE3Py8u=n=A@mail.gmail.com>
Subject: Re: virtio-pci new configuration proposal
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>,
        Anthony Liguori <anthony@codemonkey.ws>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 8, 2011 at 1:53 AM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> On Mon, 7 Nov 2011 23:14:14 +0200, "Michael S. Tsirkin" <mst@redhat.com> wrote:
>> On Mon, Nov 07, 2011 at 03:46:23PM +1030, Rusty Russell wrote:
>> > So far, the only three things make sense to have in a capability list:
>> > MSI-X, the upper 32 feature bits, and the per-device config.
>>
>> You mean the queue # to MSI-X vector mapping?
>
> Yep.
>
>> One thing to remember is that it must be in the same type of BAR as
>> the queue selection, since by PCI rules MMIO writes aren't I think
>> ordered with PIO writes (it doesn't matter with KVM but might
>> with another hypervisor).
>
> OK, I'm slowly getting up to speed.
>
> Next dumb q: Sasha, why did you introduce the idea of a separate
> virtio-pci capability list, rather than just using PCI capabilities
> directly?  ie. instead of VIRTIO_PCI_C_LAYOUT, have VIRTIO_PCI_CORE,
> VIRTIO_PCI_MSIX, VIRTIO_PCI_DEV_SPECIFIC?
>
> Is it because we really want this stuff outside the PCI configuration
> space?  Even so, should we just use the PCI cap list, and have each
> cap entry just contain a BIR & offset?

Mostly so that we can have the configuration out of PCI space so that
we can grow it later on.

We can go with doing it in PCI space with BIR & offset, yes.
