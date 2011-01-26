Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753946Ab1AZT3S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 14:29:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8414 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753437Ab1AZT3R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 14:29:17 -0500
Message-ID: <4D4075E5.70401@redhat.com>
Date: Wed, 26 Jan 2011 17:28:37 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Red Hat/3.1.7-3.el6_0 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Gerd Hoffmann <kraxel@redhat.com>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Mark Lord <kernel@teksavvy.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-input@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: 2.6.36/2.6.37: broken compatibility with userspace input-utils
 ?
References: <20110125205453.GA19896@core.coreip.homeip.net> <4D3F4804.6070508@redhat.com> <4D3F4D11.9040302@teksavvy.com> <20110125232914.GA20130@core.coreip.homeip.net> <20110126020003.GA23085@core.coreip.homeip.net> <4D4004F9.6090200@redhat.com> <4D401CC5.4020000@redhat.com> <4D402D35.4090206@redhat.com> <20110126165132.GC29163@core.coreip.homeip.net> <4D4059E5.7050300@redhat.com> <20110126182415.GB29268@core.coreip.homeip.net> <4D4072F9.5060206@redhat.com>
In-Reply-To: <4D4072F9.5060206@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 26-01-2011 17:16, Gerd Hoffmann escreveu:
>   Hi,
> 
>>>> The check should be against concrete version (0x10000 in this case).

Dmitry,

Ok, now I see what you're meaning. Yeah, an absolute version check like
what you've proposed is better than a relative version check.

> 
> Stepping back: what does the version mean?
> 
> 0x10000 == 1.0 ?
> 0x10001 == 1.1 ?
> 
> Can I expect the interface stay backward compatible if only the minor revision changes, i.e. makes it sense to accept 1.x?
> 
> Will the major revision ever change?  Does it make sense to check the version at all?

Gerd,

Dmitry will likely have a better answer for me, but I think you should
just remove the test. By principle, the interface should always be 
backward compatible (if it isn't, then we have a regression to fix). 
You may expect newer features on newer versions, so I understand 
that the version check is there to just allow userspace to enable 
new code for newer evdev protocol revisions.

Thanks,
Mauro
