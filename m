Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755523Ab2LLSIZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 13:08:25 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:57053 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755134Ab2LLSIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 13:08:22 -0500
MIME-Version: 1.0
In-Reply-To: <20121120145804.74c74400@pyramind.ukuu.org.uk>
References: <1353090754-30233-1-git-send-email-ajax@redhat.com>
	<20121120145804.74c74400@pyramind.ukuu.org.uk>
Date: Wed, 12 Dec 2012 10:08:19 -0800
Message-ID: <CAFDufb-4QxohGZw4VatUfgAzrrnVC9BhcO1NszLNaSfSV9=WmA@mail.gmail.com>
Subject: Re: [PATCH] vt: Drop K_OFF for VC_MUTE
From: Arthur Taylor <art@ified.ca>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Adam Jackson <ajax@redhat.com>, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Drop the K_OFF handling and replace it with a new "mute" ioctl pair.
>> Anybody using K_OFF would already need to be prepared to handle it
>> throwing -EINVAL for old kernel compatibility, so userspace will degrade
>> gracefully.
>
> Interesting theory. It may degrade but it'll degrade to a state worse
> than current.

AFAIK  the only consumer of K_OFF is Xorg, as I wrote both the
patches, and Xorg will degrade nicely if K_OFF doesn't work.

I'm confused why g-c-c is trying to set the virtual console keyboard
mode, as it is completely the wrong thing to do. X never wants its
virtual console set to K_UNICODE, which is the same as K_XLATE, but in
unicode. Doing so causes the kernel to buffer lines and handle things
like CTRL-C and ALT-Fn.

As this is a per-virtual console setting, setting it on the current VT
where X is running has no effect on other virtual consoles.

Modern X uses the input event subsystem directly and has no need for
the virtual console to be involved with input. Ancient X required that
the virtual console be in K_RAW.

-Art
