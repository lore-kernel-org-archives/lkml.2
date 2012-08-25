Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757248Ab2HYTAX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2012 15:00:23 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:37106 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757041Ab2HYTAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2012 15:00:21 -0400
MIME-Version: 1.0
In-Reply-To: <CAPXgP13LBR6GD=VomBPim3mDPy1bJ=eFBZ=oDaKZCjEo=Xp94Q@mail.gmail.com>
References: <CACVXFVNYCZqxt9B=9F_71KP0gdinGbNXd_ePQ10NKsCGd1dY4g@mail.gmail.com>
 <CACVXFVOMdWQSutkBzdcLJ-ozmecq_p-yzYJbtoLVUafz5KV=KQ@mail.gmail.com> <CAPXgP13LBR6GD=VomBPim3mDPy1bJ=eFBZ=oDaKZCjEo=Xp94Q@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 25 Aug 2012 11:59:59 -0700
X-Google-Sender-Auth: L5S2tN_gLjuzXfIsm5tXuLBkjVo
Message-ID: <CA+55aFy6fXaBtsoTxWh-gXRSf8aEe7OBP-wUmBQT=HBe7+Xd0w@mail.gmail.com>
Subject: Re: udev 182: response timeout for request_firmware in module_probe path
To: Kay Sievers <kay@vrfy.org>
Cc: Ming Lei <tom.leiming@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        systemd-devel@lists.freedesktop.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 23, 2012 at 8:31 AM, Kay Sievers <kay@vrfy.org> wrote:
>
> Calling out from inside the kernel and blocking in a firmware loading
> userspace transaction during module_init() is kind of weird.

It's *very* common.

I personally would prefer if drivers did their firmware loading not at
probe time, but at device open time, but that's not always necessarily
possible. More importantly, it's not actually how things are done.

So udev had better be fixed. The whole "no regressions" should be the
rule not just for the kernel, but it damn well should be the rule at
*least* also for projects like udev that are so closely related to the
kernel.

The "I wish things were otherwise than they are" mindset is wishful
thinking. Reality is that probing - and firmware loading - happens
from the module init routines quite often, and it clearly used to
work. So udev broke. Fix it, don't argue that you wish things were
otherwise.

            Linus
