Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757399Ab1EWUtT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 16:49:19 -0400
Received: from mail-px0-f173.google.com ([209.85.212.173]:44712 "EHLO
	mail-px0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752824Ab1EWUtR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 16:49:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=jY5TXBZhlJ0LSE4VL+HQVuWTaQprJOm8s6A4bOPgbiho0ZpG0orK7YHd8Z6aJ8wdfx
         /afFwLInCMbCmMU2btugA+8nQ14yOz4HS+wIqWmpednPnSuhhl2qUSi2q17Hv39iqJZU
         XEOQpN4Katxmo1u1jMSqBHIzow6jBABmUxj8c=
Date: Mon, 23 May 2011 13:49:10 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>, linux-input@vger.kernel.org
Subject: Re: select() on /dev/input/eventX not level-triggered?
Message-ID: <20110523204910.GA20525@core.coreip.homeip.net>
References: <20110519235051.GA9782@elf.ucw.cz>
 <20110523181312.GA20438@core.coreip.homeip.net>
 <20110523200622.GA1590@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110523200622.GA1590@ucw.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 23, 2011 at 10:06:22PM +0200, Pavel Machek wrote:
> On Mon 2011-05-23 11:13:12, Dmitry Torokhov wrote:
> > On Fri, May 20, 2011 at 01:50:51AM +0200, Pavel Machek wrote:
> > > Hi!
> > > 
> > > I'm debugging strange behaviour on /dev/input/eventX ... it seems that
> > > select is not behaving level-triggered as it apparently should. I can
> > > reproduce it when hitting windows & alt keys.
> > > 
> > > Now, I really should rewrite it into C, first, but perhaps someone has
> > > an idea?
> 
> (Ok, so  we agree that select()  should mark descriptor as ready as
> long as data are available... right?)
> 
> > Is this with next or with mainline? In next we try not to signal that FD
> > is ready unless we have full packet in the buffer...
> 
> 2.6.39-rcX mainline.
> 
> > FWIW I see python indeed not reading the tail of events (btw the format
> > should be 'llhhi' and the size on 64 bit arches is 24, not 16) but when
> > I hacked evtest to use select and non-blockign read it all worked
> > properly.
> 
> It  was on x32, but I'll fix that, thanks.
> 
> Difference was I'm not using non-blocking read().

Does not matter.

> It is unusual but
> should work AFAICT. Just read one packet when select shows its ready;
> if there's more than one, don't loop around read, but rely on select
> returning immediately.
> 
> I did verify it on strace, so it should not  be python artefact.

It is artefact of your program, you buffering your input. Use:

	file = open("/dev/input/event3", "rb", 0)

Thanks.

-- 
Dmitry
