Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752795Ab2DRBgW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 21:36:22 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:58027 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751318Ab2DRBgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 21:36:21 -0400
MIME-Version: 1.0
In-Reply-To: <20120417203223.GA31699@redhat.com>
References: <20120417172142.GA30237@redhat.com> <CA+55aFy-uhOgEoEBr-LkOjFQBVh14wwr-20jTrtsg_2EnuNY5g@mail.gmail.com>
 <20120417203223.GA31699@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 17 Apr 2012 18:36:00 -0700
X-Google-Sender-Auth: ACg_wTZtg9kthenxi5nRjekovws
Message-ID: <CA+55aFzWzhxaVHuPY_oB5PVhw2Gxiwr46vyHCHEsU0o-HFikTw@mail.gmail.com>
Subject: Re: [3.4-rc3] Thread overran stack, or stack corrupted
To: Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 17, 2012 at 1:32 PM, Dave Jones <davej@redhat.com> wrote:
>
> Ok, this builds. I'll run with this for a while, and see what falls out.

So assuming that works and doesn't have some silly thinko in it, I
think it is a worthwhile addition to the whole stack debugging thing.
Right now, the message about "process xyz used most stack, x bytes
free" really is pretty useless. If it were to actually show "hey, this
was the deepest actual stack chain", that sounds quite interesting.

Of course, if the stack is largely used by some leaf function that
just has a big stack frame, that won't show up in the stack trace, but
that's presumably not the worst worry. And hopefully the caller of
that would still be pretty deep and show up without having been
overwritten.

                     Linus
