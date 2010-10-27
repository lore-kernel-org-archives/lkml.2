Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932220Ab0J0VCR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 17:02:17 -0400
Received: from usmamail.tilera.com ([72.1.168.231]:48076 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757081Ab0J0VCP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 17:02:15 -0400
Message-ID: <4CC89352.7020808@tilera.com>
Date: Wed, 27 Oct 2010 17:02:10 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.11) Gecko/20101013 Thunderbird/3.1.5
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Al Viro <viro@zeniv.linux.org.uk>, <linux-arch@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: situation with signals
References: <20100923221141.GK19804@ZenIV.linux.org.uk> <9lYpY1#WLHA.1516@exchange1.tad.internal.tilera.com>
In-Reply-To: <9lYpY1#WLHA.1516@exchange1.tad.internal.tilera.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/24/2010 9:33 AM, Arnd Bergmann wrote:
> On Friday 24 September 2010, Al Viro wrote:
>>         There are several interesting issues in arch/*/*/*signal* (besides
>> shoggoths starting to show up when one reads that code) and I'd been crawling
>> through that area for the last few weeks.  Here are more or less common
>> issues; there are really arch-specific bugs (e.g. roothole on frv that
>> used to allow reading kernel memory by setting the right sa_handler), but
>> that's a separate story.
> 
> I still plan to make a counterpart to the asm-generic headers with an
> example architecture that new architectures can copy from. Signal handling
> is one of the areas that I have very limited understanding of. Did you
> encounter any architecture that basically gets signal handling right and that
> can serve as a positive example to others?
> 
> arch/tile/kernel/signal.c was the last one that got merged and I tried
> to direct the maintainer in the right direction as much as I could, but
> there are a lot of things I didn't know about.

(Sorry for the belated reply.)

I set aside this thread to look at when I had a minute, and I believe there
is just one of the signal issues present in the tile code.  The fix is to
reset regs->fault to something other than the "syscall" fault type when
exiting from do_signal(), so I'll submit that up for 2.6.37 shortly.

Otherwise I think tile is doing things right, though I admit, the signal
support is pretty deep magic generally.
-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com
