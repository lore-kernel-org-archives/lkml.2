Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754061Ab1AZUIU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 15:08:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36876 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751906Ab1AZUIS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 15:08:18 -0500
Message-ID: <4D407F15.4030204@redhat.com>
Date: Wed, 26 Jan 2011 21:07:49 +0100
From: Gerd Hoffmann <kraxel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Red Hat/3.1.7-3.el6_0 Thunderbird/3.1.7
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Mark Lord <kernel@teksavvy.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-input@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: 2.6.36/2.6.37: broken compatibility with userspace input-utils
 ?
References: <4D3F4D11.9040302@teksavvy.com> <20110125232914.GA20130@core.coreip.homeip.net> <20110126020003.GA23085@core.coreip.homeip.net> <4D4004F9.6090200@redhat.com> <4D401CC5.4020000@redhat.com> <4D402D35.4090206@redhat.com> <20110126165132.GC29163@core.coreip.homeip.net> <4D4059E5.7050300@redhat.com> <20110126182415.GB29268@core.coreip.homeip.net> <4D4072F9.5060206@redhat.com> <20110126193259.GC29268@core.coreip.homeip.net>
In-Reply-To: <20110126193259.GC29268@core.coreip.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

   Hi,

> It depends. We do not have a clear way to see if new ioctls are
> supported (and I do not consider "try new ioctl and see if data sticks"
> being a good way) so that facilitated protocol version rev-up.

Yea, EVIOCGKEYCODE_V2 on a old kernel returns EINVAL.  Not good.  There 
is another one which should have been used to signal "unknown ioctl", 
ENOTTY IIRC (a bit silly for historical reasons), so you can figure 
whenever your input data is invalid or whenever the ioctl isn't 
supported in the first place (in which case you could just fallback to 
the old version).

> So keymap
> manipulating tools might be forced to check protocol version.

Guess that is the best way indeed.

cheers,
   Gerd.
