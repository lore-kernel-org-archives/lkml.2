Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755046Ab1KNPrH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 10:47:07 -0500
Received: from 95-31-19-74.broadband.corbina.ru ([95.31.19.74]:51087 "EHLO
	dnet.ilyx.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753181Ab1KNPrG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 10:47:06 -0500
Message-ID: <4EC137F6.1050509@ilyx.ru>
Date: Mon, 14 Nov 2011 19:47:02 +0400
From: Ilya Zykov <ilya@ilyx.ru>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20111108 Iceape/2.0.11
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Jiri Slaby <jslaby@suse.cz>, Alan Cox <alan@linux.intel.com>,
        linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [PATCH v3 2/2] TTY: tty flip buffer optimisation.
References: <4EC10DC6.8070807@ilyx.ru>	<4EC124EB.4050203@suse.cz> <20111114150523.2abdf7a1@lxorguk.ukuu.org.uk>
In-Reply-To: <20111114150523.2abdf7a1@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:

>> Hi, the results are indeed nice. However is there any *real* load other
>> than this tailor-made microbenchmark where the added code complexity is
>> worth it?
> 
> I'm wondering if we need the complexity in the first place. Certainly 256
> does seem a bit small for pty/tty traffic. A 'real world' benchmark would
> be an ls -lR / on a machine with a fast graphics card or in console mode
> 
> ie
> 
> ls -lR /		# prime cache
> time ls -lR /
> 
> and there are cases where people do a lot of traffic over a pty like this
> so I don't think it's entirely fake.
> 
> I don't like the complexity but we could certainly go from using 256 byte
> buffers to "tty->buf.bufsize" and make it configurable without
> that complexity.
> 
> Alan
> 


For avoid complexity we need remove free buffer at all.
And use kmalloc()-kfree() for every chunk. Don't need tty_buffer_find().
It will be fast and easy.
Ilya.

