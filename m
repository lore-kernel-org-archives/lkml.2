Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933148Ab0E0I7t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 04:59:49 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:52980 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932861Ab0E0I7h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 04:59:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=OEFzd85Ulf0vekv2b7REq+W1yuJuCcMK7nG+lctMZKMfAPJ5uaadL3FOozXVyPUGWw
         bqk3R+iMHGD+hhGGH0PMSmAGBY4U3Q6HHUZF/djReDB8heapJ0GgOAm6FCs9Qr2zj3nA
         NFHzzTXkEml9mpP4IJbpuZQoVQ9EhHslZMcP0=
MIME-Version: 1.0
In-Reply-To: <4BFE1695.5000206@kernel.org>
References: <AANLkTikBrXROMvNKrhgxQ1jVh6aOsx3nIrNXTznXInV1@mail.gmail.com> 
	<20100526151152.28deaa6c@linux.intel.com> <AANLkTikuzGazcBpSvqU73UAAIvcTgxTBsmWTr9bNCSjB@mail.gmail.com> 
	<4BFE1695.5000206@kernel.org>
From: Frank Pan <frankpzh@gmail.com>
Date: Thu, 27 May 2010 16:59:17 +0800
Message-ID: <AANLkTik2MyWWogREK1DpXKeYrutr7skHQB7kzeg6DYvq@mail.gmail.com>
Subject: Re: [PATCH 0/2] Enlarge the storage of chars in virtual terminal
To: Tejun Heo <tj@kernel.org>
Cc: Alan Cox <alan@linux.intel.com>,
       Gerardo Exequiel Pozzi <vmlinuz386@yahoo.com.ar>,
       Kay Sievers <kay.sievers@vrfy.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Catalin Marinas <catalin.marinas@arm.com>,
       Daniel Mack <daniel@caiaq.de>,
       Christoph Lameter <cl@linux-foundation.org>,
       Jiri Slaby <jirislaby@gmail.com>, Jochen Hein <jochen@jochen.org>,
       Johannes Weiner <hannes@cmpxchg.org>, Dave Airlie <airlied@redhat.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings,

> That's only true for CJK.  There are other scripts which are more
> difficult to render properly.  e.g. In mixed English Arabic text,
> English needs to be rendered left-to-right as usual while Arabic needs
> to be rendered right-to-left.  Indic rendering is also known to be
> very tricky.  Even on full desktop environment, only Gnome + Pango and
> Visat/7 get everything right.

You are right, I've missed a big count of languages.
Nonetheless, the vt already identified several ranges in the unicode
space, and made them 2 times wide as ASCII chars.
My idea depends on this.

OTOH, I think nobody expect the console can render scripts so nice
as it written on a piece of paper. Compare with the console now,
people seeing their home language scripts is better than seeing question
marks(?). Although they may in wrong order, although the resolution
is not enough for part of scripts, but one can see the content of
a file, a web page, which is rendered into pages of question marks
now.

Yes, It's not so perfect, but it's much better than question marks.

> And then, if you think about multilingual terminal, output is only one
> half of the story.  You gotta be able to input something too and in
> many scripts, input handling needs to interact constantly with
> rendering, which means that the kernel will also need to supply input
> framework, at which point I start to wonder whether the whole thing is
> just too complicated.

Agree. Input method is much complex than a data structure expanding.

I don't know about other languages, but I bet the thing goes like:
one press one or more keys, (choose the char he/she really want to, )?
and commit an input.
We need not to implement the whole thing inside kernel, a user space
app can catch keyboard inputs and push unicode chars into the tty.
The only change should be done in kernel is reserve a space on screen
for the potential char choosing, which is really easy to do in any
console drivers(report a smaller height/width).

> What's the use case other than "I just want to use console"?

Many times I type startx is just for checking time of a meeting
(in a CJK web page, etc).
Many times I've found emails in mutt with question marks, I must
open a X and a terminal in X, and mutt in terminal in X.
Is there anything worse?

Thanks.

-- 
Frank Pan

Computer Science and Technology
Tsinghua University
