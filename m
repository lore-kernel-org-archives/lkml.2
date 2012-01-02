Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753461Ab2ABWrV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jan 2012 17:47:21 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:56880 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752335Ab2ABWrS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jan 2012 17:47:18 -0500
MIME-Version: 1.0
In-Reply-To: <20120102222920.GA16160@srcf.ucam.org>
References: <Pine.LNX.4.44L0.1201021041550.10702-100000@netrider.rowland.org>
 <4F02165C.1060400@fastmail.fm> <CA+55aFwf06vRraVqtz8_2qWjxH0V=Yj5m7mEy3XVbA7+qj5k5A@mail.gmail.com>
 <20120102211904.GA15316@srcf.ucam.org> <CA+55aFwJuuvqcsgHnZ4-VhUhbVvL6beKogo1adgYyZt_ZM=H7A@mail.gmail.com>
 <20120102215028.GA15701@srcf.ucam.org> <CA+55aFz73GuHiOW1NoAuJLea_GKLepiZjrnrgpOKdQizPgnhoA@mail.gmail.com>
 <20120102221235.GA16012@srcf.ucam.org> <CA+55aFyHvmvast_kuNddU3iotReR1mOpKM4HGAw80ma8kn+2-g@mail.gmail.com>
 <20120102222920.GA16160@srcf.ucam.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 2 Jan 2012 14:46:56 -0800
X-Google-Sender-Auth: wTKt9mbqqcANU6xFfz8E4-AC2ZI
Message-ID: <CA+55aFyUK6X7ip2UXV9iT07=qezXfbw82wn6UKAN8JFQtYNs5Q@mail.gmail.com>
Subject: Re: loading firmware while usermodehelper disabled.
To: Matthew Garrett <mjg@redhat.com>
Cc: Jack Stone <jwjstone@fastmail.fm>, Alan Stern <stern@rowland.harvard.edu>,
        Oliver Neukum <oliver@neukum.org>, Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        "John W. Linville" <linville@tuxdriver.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        USB list <linux-usb@vger.kernel.org>,
        Linux Wireless List <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 2, 2012 at 2:29 PM, Matthew Garrett <mjg@redhat.com> wrote:
>>
>> Why do you make up all these idiotic theoretical cases that nobody
>> cares about and has no relevance what-so-ever for the 99%?
>
> Rebooting is a theoretical case?

Your forcing the issue to be some crazy one that "cannot be solved" is
the theoretical case. I'm telling you that "reloading the firmware at
resume time" is wrong, and trivially solved by loading it before
resume time. You then make up all these invalid arguments about why
it's somehow magically impossible, but you *literally* do it by
refusing to look at what *is* possible.

It's *trivial* to attach the firmware driver and load the firmware
even if the firmware isn't needed - because you know it *will* be
needed if somebody suspends. Why not just do that? Why make up these
horrible problems that are totally irrelevant?

You can match the driver by various things like DMI strings etc, if
you really don't have a USB (or PCI or whatever) ID to match against.
But in fact, almost always you at least have things like subvendor
ID's etc that you *can* match against.

So why are you actively trying to make something complicated that
isn't? Why are you arguing against the simple solution that can easily
be made to work for the odd and unusual case you are trying to push?

                         Linus
