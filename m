Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753360Ab2KGVPB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 16:15:01 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:60944 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753187Ab2KGVO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 16:14:59 -0500
MIME-Version: 1.0
In-Reply-To: <1352317219.5552.6.camel@edumazet-glaptop>
References: <CAODwPW9kiG-jo=n0zedv5KT-8-gJcEUrdC3F2mAEjt78tne18g@mail.gmail.com>
	<1352316791-16491-1-git-send-email-jwerner@chromium.org>
	<1352317219.5552.6.camel@edumazet-glaptop>
Date: Wed, 7 Nov 2012 13:14:58 -0800
X-Google-Sender-Auth: biDxy3JE2PUaV5EGH0MlDLs3SP4
Message-ID: <CAODwPW8mBJspF3k5SCBR-BShNvBLQpD-vyhLRh5Cq-4h=VZDgg@mail.gmail.com>
Subject: Re: [PATCH] tcp: Avoid infinite loop on recvmsg bug
From: Julius Werner <jwerner@chromium.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Patrick McHardy <kaber@trash.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        James Morris <jmorris@namei.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        "David S. Miller" <davem@davemloft.net>, Dave Jones <davej@redhat.com>,
        Sameer Nanda <snanda@chromium.org>,
        Mandeep Singh Baines <msb@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> What I find very sad in all this is that you didnt mention the driver
> that was triggering this bug.

Sorry, I was just trying to keep this thread focussed on one patch.
The bug report that led me to this is publicly accessible at
http://crosbug.com/35827. We have encountered the problem only once,
on an Acer AC700 Chromebook that ran automated tests. The ethernet
interface for the offending socket was provided by a USB-to-Ethernet
dongle using the smsc95xx/usbnet module (v1.0.4).

Don't get me wrong, I do understand the importance of finding the
underlying cause of this... I just don't think I have much of a chance
with one report. I can go through the above-mentioned module and see
if something looks suspicious in the skb handling code if I can find
the time. But on the other hand the fact remains that this condition
is not handled well... not just for this particular case, but for all
future kernel and driver bugs that may trigger it again. I am not
trying to "hide" any issues, I am all for making them as visible as
possible... but as Dave pointed out, kernel panics may not be the best
way to do that either, and I think damage mitigation also has some
value. The current code clearly does the worst of both worlds, so
please let's just improve it one way or the other.
