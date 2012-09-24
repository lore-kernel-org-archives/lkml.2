Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755518Ab2IXMyv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 08:54:51 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:33227 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751997Ab2IXMys (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 08:54:48 -0400
MIME-Version: 1.0
X-Originating-IP: [2001:998:22:0:c685:8ff:fe10:f3d8]
In-Reply-To: <1348489478.11847.55.camel@twins>
References: <1347923013-4253-1-git-send-email-daniel.vetter@ffwll.ch>
	<1347923013-4253-2-git-send-email-daniel.vetter@ffwll.ch>
	<1348489027.11847.53.camel@twins>
	<1348489478.11847.55.camel@twins>
Date: Mon, 24 Sep 2012 14:54:47 +0200
Message-ID: <CAKMK7uGyDOhCtP_fCRa-oirQ8edQcSiW8L_vSE9M29LU3EUoqg@mail.gmail.com>
Subject: Re: [PATCH 2/2] [RESEND] console: implement lockdep support for console_lock
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        Dave Airlie <airlied@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 24, 2012 at 2:24 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Mon, 2012-09-24 at 14:17 +0200, Peter Zijlstra wrote:
>> On Tue, 2012-09-18 at 01:03 +0200, Daniel Vetter wrote:
>> > - In the printk code there's a special trylock, only used to kick off
>> >   the logbuffer printk'ing in console_unlock. But all that happens
>> >   while lockdep is disable (since printk does a few other evil
>> >   tricks). So no issue there, either.
>>
>> Not particularly evil, just plain broken.
>>
>> See this series:
>>
>>   http://marc.info/?l=linux-kernel&m=132446644123326&w=2
>>
>> In particular see patches 1-4. The problem with lockdep is that lockdep
>> uses printk and printk's recursion stuff is utterly broken.
>>
>> Console drivers being on crack simply doesn't help :-) Note that I would
>> never recommend drm/ksm to anybody who really cares about their console
>> output.

I've read through the patches and I'm hoping you don't volunteer me to
pick these up ... ;-) But there doesn't seem to be anything that would
get worse through this lockdep annotation patch, right?

> Also, don't cross-post with a subscribe only list.

Sorry, forgot about this, I'll try to fix this - we really need an
intel-gfx that's open to people not subscribed to it.

Thanks, Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
