Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754702Ab2AWWfx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 17:35:53 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:62500 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753501Ab2AWWfu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 17:35:50 -0500
MIME-Version: 1.0
In-Reply-To: <CAE9FiQVTtjTsTizCjg3KE=yxbyh9Y_J4XBUo77RMLdxiUWv1gA@mail.gmail.com>
References: <1327139539-14301-1-git-send-email-yinghai@kernel.org>
 <1327139539-14301-2-git-send-email-yinghai@kernel.org> <CA+55aFz7B5ebEGKKJmvuWY+2O-6qarUj40CHASu_4EQ0KDgi_Q@mail.gmail.com>
 <CAE9FiQWbmO+FFsE06eQ=-PVNtdaTG3EsqXNXdUCxb9YxtPS8Cw@mail.gmail.com>
 <CA+55aFyok04YrmEYXLbAE2vB_944+aEJZhd5tzu6U2k0CLaN5A@mail.gmail.com>
 <CA+55aFwEbbq0yuN4mAtfDSbOE86mAWsBBz+pgBzn8_QHVk+B3g@mail.gmail.com>
 <CAE9FiQUPwvg0159-My4B+9FG0AeR=86Y5baQT5v8bSVcvGH=Hg@mail.gmail.com> <CAE9FiQVTtjTsTizCjg3KE=yxbyh9Y_J4XBUo77RMLdxiUWv1gA@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 23 Jan 2012 14:35:29 -0800
X-Google-Sender-Auth: WbvT2FOh_Eu2DBeX-loE8luJiQ0
Message-ID: <CA+55aFw+wqCAiPRLmW5E9uGtY_NLsiXP5rTYbnzLVjjxKn486A@mail.gmail.com>
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

On Mon, Jan 23, 2012 at 12:48 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>
> it does not work... get lock up

Hmm. That's consistent with pci_stop_bus_device() just not removing
the device at all from the bus list. Which on the face of it would be
sane, since it's "stop", not "remove".

There's definitely something odd going on about that whole thing - not
just the confusion about "stop" vs "remove". It has that "is_added"
logic too. I have no idea what the logic of that whole thing is, it
really doesn't look sane.

                        Linus
