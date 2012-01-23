Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754072Ab2AWT7W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 14:59:22 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:39602 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753803Ab2AWT7U convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 14:59:20 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFwEbbq0yuN4mAtfDSbOE86mAWsBBz+pgBzn8_QHVk+B3g@mail.gmail.com>
References: <1327139539-14301-1-git-send-email-yinghai@kernel.org>
	<1327139539-14301-2-git-send-email-yinghai@kernel.org>
	<CA+55aFz7B5ebEGKKJmvuWY+2O-6qarUj40CHASu_4EQ0KDgi_Q@mail.gmail.com>
	<CAE9FiQWbmO+FFsE06eQ=-PVNtdaTG3EsqXNXdUCxb9YxtPS8Cw@mail.gmail.com>
	<CA+55aFyok04YrmEYXLbAE2vB_944+aEJZhd5tzu6U2k0CLaN5A@mail.gmail.com>
	<CA+55aFwEbbq0yuN4mAtfDSbOE86mAWsBBz+pgBzn8_QHVk+B3g@mail.gmail.com>
Date: Mon, 23 Jan 2012 11:59:19 -0800
X-Google-Sender-Auth: OQnQCfJa11odVGQqqb1tsR8Z1ok
Message-ID: <CAE9FiQUPwvg0159-My4B+9FG0AeR=86Y5baQT5v8bSVcvGH=Hg@mail.gmail.com>
Subject: Re: [PATCH 1/7] PCI: Make sriov work with hotplug remove
From: Yinghai Lu <yinghai@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Matthew Wilcox <matthew@wil.cx>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 23, 2012 at 11:34 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>  (b) if that isn't an option, and the virtual devices make a mess, at
> least don't make the code uglier, just do something like:
>
>    while (!list_empty(&bus->devices)) {
>        struct pci_dev *dev = list_first_entry(struct pci_dev, bus_list);
>
>        pci_stop_bus_device(dev);
>    }
>
> which at least isn't butt ugly. Add a large comment about how
> pci_stop_bus_device() can remove multiple devices due to the virtual
> devices having been done badly.

yes, this one should work and less confusing.

>
> Who is in charge of the whole 'is_virtfn' mess? How realistic is it to
> fix that crud?

Not sure.  it seems the guy Yu Zhao (?) already left intel several years ago.

It seems  ./scripts/get_maintainer.pl for pci patches now only return Jesse.

Yinghai
