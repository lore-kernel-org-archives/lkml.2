Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755771Ab1JYLWO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 07:22:14 -0400
Received: from 95-31-19-74.broadband.corbina.ru ([95.31.19.74]:43460 "EHLO
	dnet.ilyx.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754855Ab1JYLWN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 07:22:13 -0400
Message-ID: <4EA69BE2.3020703@ilyx.ru>
Date: Tue, 25 Oct 2011 15:22:10 +0400
From: Ilya Zykov <ilya@ilyx.ru>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110929 Iceape/2.0.11
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Greg Kroah-Hartman <gregkh@suse.de>, Alan Cox <alan@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] TTY: tty flip buffer change reserve memory strategy.
References: <4EA48474.4010101@ilyx.ru> <20111025084543.09432276@pyx>
In-Reply-To: <20111025084543.09432276@pyx>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you, for answer.

> 
> kmalloc is very fast anyway so I'd be interested in seeing the drivers
> suffering and the profile traces of a real example.
> 

Pty use chunk more 256 bytes very often. More program for communicate with
pppd use pty master - slave. If often kmalloc()-kfree() calls don't provoke
memory fragmentation and flush TLB, I agree it isn't important.


> I'm also not sure I agree with the maths - we chunk buffers to 256 byte
> boundaries to avoid getting lots of queued buffers of different sizes. We
> could in fact I think simplify the code from what we have learned using
> it and simply treat the 256 byte buffer case as special rather than 256
> and 512 as we do now. That would let us remove the more generic support
> for free buffer sizes which is overcomplex and mean we could simply count
> the number of 256 byte buffers we have to hand.

Now we can't accumulate buffer more than 256 byte. 
"if (b->size >= 512) kfree(b);" and our buffer can be only 256, 512 ... .
We can simplify tty_buffer_find() for don't look up buffer more 256 byte.

I think my patch very clear, because if stream from driver very slow we 
will be use only two 256 byte chunk, as before. But with pty, maybe, new drivers,
we could use flip buffer more effective.

Ilya.

