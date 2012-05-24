Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759207Ab2EXUnK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 16:43:10 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:42952 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756374Ab2EXUnG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 16:43:06 -0400
MIME-Version: 1.0
In-Reply-To: <4FBE5518.5090705@redhat.com>
References: <4FBE5518.5090705@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 24 May 2012 13:42:45 -0700
X-Google-Sender-Auth: meB_ttkc5w3nNSVyep4Mxp228Dc
Message-ID: <CA+55aFyt2OFOsr5uCpQ6nrur4zhHhmWUJrvMgLH_Wy1niTbC6w@mail.gmail.com>
Subject: Re: [GIT PULL for v3.5-rc1] media updates for v3.5
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Btw, I only noticed now, because I normally don't build DVB on my main
machine with "oldconfig" - why the hell does DVB add tuners with
"default m"?

Why would *anybody* with an old config ever want to get those new
drivers as modules?

Get rid of all the stupid

  default m if DVB_FE_CUSTOMISE

because there's no reason for them. If somebody wants that module,
they can damn well press the 'm' button. There's absolutely no reason
for it to default to on.

This is true of *all* drivers. No driver (and certainly DVB is not at
all an exception) is so important that it should be "default m" (or
y).

There are a few valid reasons to use "default m/y", but I don't see
that that is the case here:

 - if you have an *existing* driver that got split up, and "make
oldconfig" with that old driver enabled would result in it no longer
supporting the same capability, then a

     default OLD_DRIVER_WAS_ENABLED

   is appropriate - it makes "oldconfig" work the way people expect it to work.

   But this is only when that piece of hardware used to be supported
already, it's irrelevant for new hardware.

 - if it's *such* a basic piece of hardware that you simply don't want
to bother the user with an insane default. Like supporting an ATKBD
driver on a PC etc.

   This simply isn't true for media devices.

So stop doing the silly "enable this driver by default for old
configurations". It's *wrong*.

                  Linus
