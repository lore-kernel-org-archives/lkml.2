Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754046Ab2AWToy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 14:44:54 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:61981 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754010Ab2AWTow (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 14:44:52 -0500
MIME-Version: 1.0
In-Reply-To: <CAE9FiQXDHHJ0rG6hd6a3B+f0ZyJmjJ3rJGNWTsCwn21o+84C_Q@mail.gmail.com>
References: <1327139539-14301-1-git-send-email-yinghai@kernel.org>
 <1327139539-14301-2-git-send-email-yinghai@kernel.org> <CA+55aFz7B5ebEGKKJmvuWY+2O-6qarUj40CHASu_4EQ0KDgi_Q@mail.gmail.com>
 <CAE9FiQWbmO+FFsE06eQ=-PVNtdaTG3EsqXNXdUCxb9YxtPS8Cw@mail.gmail.com>
 <CA+55aFyok04YrmEYXLbAE2vB_944+aEJZhd5tzu6U2k0CLaN5A@mail.gmail.com> <CAE9FiQXDHHJ0rG6hd6a3B+f0ZyJmjJ3rJGNWTsCwn21o+84C_Q@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 23 Jan 2012 11:44:30 -0800
X-Google-Sender-Auth: BH53k8nWbCzeKoRixlax2C7gCCE
Message-ID: <CA+55aFy4nv5bYdjiZM2HY1E=RU_CaBoQWy6iWXReAK98yRKZpw@mail.gmail.com>
Subject: Re: [PATCH 1/7] PCI: Make sriov work with hotplug remove
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Matthew Wilcox <matthew@wil.cx>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 23, 2012 at 11:36 AM, Yinghai Lu <yinghai@kernel.org> wrote:
>
> Maybe we can put VF and PF in bus->devices like:
> VF come first than PF?

Ugh. Ok, so that's a disgusting hack, but it's better than messing up
the generic PCI subsystem. At least it's a disgusting hack in the IOV
code.

I still would prefer to just do the virtual devices right instead. Or
even just make the removal loop inherently robust, rather than have
that insane knowledge of virtual function devices that were done so
horribly wrong.

Or even just *keep* the virtual devices on the list even though the
physical device has been removed - make them independent of the
physical device.

Anything but that "do virtual devices utterly wrong, and then have to
work around it in the generic pci layer because it was done so badly".

                      Linus
