Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933939Ab0E0JfG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 05:35:06 -0400
Received: from hera.kernel.org ([140.211.167.34]:55647 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756883Ab0E0JfD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 05:35:03 -0400
Message-ID: <4BFE3BB8.1030503@kernel.org>
Date: Thu, 27 May 2010 11:30:32 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Frank Pan <frankpzh@gmail.com>
CC: Alan Cox <alan@linux.intel.com>,
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
Subject: Re: [PATCH 0/2] Enlarge the storage of chars in virtual terminal
References: <AANLkTikBrXROMvNKrhgxQ1jVh6aOsx3nIrNXTznXInV1@mail.gmail.com> 	<20100526151152.28deaa6c@linux.intel.com> <AANLkTikuzGazcBpSvqU73UAAIvcTgxTBsmWTr9bNCSjB@mail.gmail.com> 	<4BFE1695.5000206@kernel.org> <AANLkTik2MyWWogREK1DpXKeYrutr7skHQB7kzeg6DYvq@mail.gmail.com>
In-Reply-To: <AANLkTik2MyWWogREK1DpXKeYrutr7skHQB7kzeg6DYvq@mail.gmail.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 27 May 2010 09:30:35 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 05/27/2010 10:59 AM, Frank Pan wrote:
> You are right, I've missed a big count of languages.
> Nonetheless, the vt already identified several ranges in the unicode
> space, and made them 2 times wide as ASCII chars.
> My idea depends on this.

Hmmm... I see.

>> And then, if you think about multilingual terminal, output is only one
>> half of the story.  You gotta be able to input something too and in
>> many scripts, input handling needs to interact constantly with
>> rendering, which means that the kernel will also need to supply input
>> framework, at which point I start to wonder whether the whole thing is
>> just too complicated.
> 
> Agree. Input method is much complex than a data structure expanding.
> 
> I don't know about other languages, but I bet the thing goes like:
> one press one or more keys, (choose the char he/she really want to, )?
> and commit an input.
> We need not to implement the whole thing inside kernel, a user space
> app can catch keyboard inputs and push unicode chars into the tty.
> The only change should be done in kernel is reserve a space on screen
> for the potential char choosing, which is really easy to do in any
> console drivers(report a smaller height/width).

I'm not an export on the issue but if I'm not mistaken it gets more
complex than that.  It took quite some time to solve the problem
properly even on full desktop envs.

>> What's the use case other than "I just want to use console"?
> 
> Many times I type startx is just for checking time of a meeting
> (in a CJK web page, etc).
> Many times I've found emails in mutt with question marks, I must
> open a X and a terminal in X, and mutt in terminal in X.

And other than yourself, how many would such users be?  What's your
reason for not using X other than "console looks cooler"?  Even if you
have some valid reason to not use X and absolutely have to have
multilingual support, what prevents you from using fb based terminals
like jfbterm which already works with input and all without
introducing any i18n related complexities into kernel?  To me, it
seems like low activiy on jfbterm seems to show the low demand for
such feature.  So, just use X.

> Is there anything worse?

Sure, there are plenty of worse things.  :-)

Thanks.

-- 
tejun
