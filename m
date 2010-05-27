Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755491Ab0E0Gxl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 02:53:41 -0400
Received: from hera.kernel.org ([140.211.167.34]:52485 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753584Ab0E0Gxj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 02:53:39 -0400
Message-ID: <4BFE1695.5000206@kernel.org>
Date: Thu, 27 May 2010 08:52:05 +0200
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
References: <AANLkTikBrXROMvNKrhgxQ1jVh6aOsx3nIrNXTznXInV1@mail.gmail.com> 	<20100526151152.28deaa6c@linux.intel.com> <AANLkTikuzGazcBpSvqU73UAAIvcTgxTBsmWTr9bNCSjB@mail.gmail.com>
In-Reply-To: <AANLkTikuzGazcBpSvqU73UAAIvcTgxTBsmWTr9bNCSjB@mail.gmail.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 27 May 2010 06:52:09 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 05/27/2010 08:00 AM, Frank Pan wrote:
>> This has been suggested a couple of times but unfortunately it's not
>> enough to use bigger fonts. Rendering many non western languages is far
>> far more complex. In addition the text mode vt driver is limited to 512
>> symbols by the hardware.
>
> Why is it complex? IMHO Rendering non-western languages is nothing more than
> rendering 2 ASCII chars.

That's only true for CJK.  There are other scripts which are more
difficult to render properly.  e.g. In mixed English Arabic text,
English needs to be rendered left-to-right as usual while Arabic needs
to be rendered right-to-left.  Indic rendering is also known to be
very tricky.  Even on full desktop environment, only Gnome + Pango and
Visat/7 get everything right.

  http://en.wikipedia.org/wiki/Wikipedia%3AEnabling_complex_text_support_for_Indic_scripts

And then, if you think about multilingual terminal, output is only one
half of the story.  You gotta be able to input something too and in
many scripts, input handling needs to interact constantly with
rendering, which means that the kernel will also need to supply input
framework, at which point I start to wonder whether the whole thing is
just too complicated.

Why do we need a separate in-kernel implementation of unicode
rendering and multilingual input system at all?  What's the use case
other than "I just want to use console"?

Thanks.

-- 
tejun
