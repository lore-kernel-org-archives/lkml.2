Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068Ab1I2HX3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 03:23:29 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:56314 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752627Ab1I2HX2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 03:23:28 -0400
MIME-Version: 1.0
In-Reply-To: <20110929070940.GA2838@udknight.homenetwork>
References: <20110929070940.GA2838@udknight.homenetwork>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 29 Sep 2011 00:23:07 -0700
X-Google-Sender-Auth: IP0vvkBsfcaelAyNfs5dBFgewic
Message-ID: <CA+55aFzjAinwRcw-xd4U8tR+bDdpf2h2kP=cEd5hw+K6ZPt3QQ@mail.gmail.com>
Subject: Re: [PATCH] init:main.c: start 'usermodehelper_enable()' a little early
To: wangyanqing <Udknight@gmail.com>, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 29, 2011 at 12:09 AM, wangyanqing <udknight@gmail.com> wrote:
> commit d5767c53535ac79758084773418e0ad186aba4a2 move 'usermodehelper_enable()'
> to end of rest_init, then I get failed to let uvesafb work on my computer, and
> lose the splash boot.So maybe we could start usermodehelper_enable a little early
> to make some task work that need eary init with the help of user mode.

Grr. Initcalls *really* shouldn't depend on usermode helpers.

That said, I'm not entirely shocked if they do. But could you try to
describe *which* initcall it is? The call trace should tell you?

I'm not saying the patch is wrong (and it may be what we have to do at
this point), but I do think it would be even better if we could fix
the real problem of initcalls calling usermode helpers instead...

           Linus
