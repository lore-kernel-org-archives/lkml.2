Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753344Ab1AYUKl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 15:10:41 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40334 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751460Ab1AYUKj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 15:10:39 -0500
MIME-Version: 1.0
In-Reply-To: <20110125164803.GA19701@core.coreip.homeip.net>
References: <4D3E1A08.5060303@teksavvy.com> <20110125005555.GA18338@core.coreip.homeip.net>
 <4D3E4DD1.60705@teksavvy.com> <20110125042016.GA7850@core.coreip.homeip.net>
 <4D3E5372.9010305@teksavvy.com> <20110125045559.GB7850@core.coreip.homeip.net>
 <4D3E59CA.6070107@teksavvy.com> <4D3E5A91.30207@teksavvy.com>
 <20110125053117.GD7850@core.coreip.homeip.net> <4D3EB734.5090100@redhat.com> <20110125164803.GA19701@core.coreip.homeip.net>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 26 Jan 2011 06:09:45 +1000
Message-ID: <AANLkTi=1Mh0JrYk5itvef7O7e7pR+YKos-w56W5q4B8B@mail.gmail.com>
Subject: Re: 2.6.36/2.6.37: broken compatibility with userspace input-utils ?
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Mark Lord <kernel@teksavvy.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-input@vger.kernel.org, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 26, 2011 at 2:48 AM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
>
> We should be able to handle the case where scancode is valid even though
> it might be unmapped yet. This is regardless of what version of
> EVIOCGKEYCODE we use, 1 or 2, and whether it is sparse keymap or not.
>
> Is it possible to validate the scancode by driver?

More appropriately, why not just revert the thing? The version change
and the buggy EINVAL return both.

As Mark said, breaking user space simply isn't acceptable. And since
breaking user space isn't acceptable, then incrementing the version is
stupid too.

The way we add new ioctl's is not by incrementing some "ABI version"
crap. It's by adding new ioctl's or system calls or whatever that
simply used to return -ENOSYS or other error before, while preserving
the old ABI. That way old binaries don't break (for _ANY_ reason), and
new binaries can see "oh, this doesn't support the new thing".

                Linus
