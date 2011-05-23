Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756562Ab1EWSNU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 14:13:20 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:56479 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756215Ab1EWSNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 14:13:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=LE2Lsl5y1pfYdDLqCKyYuPh26MqFhYrrJ8sagDAyNA0qCcCRh/Hq/I5Zyx2C7+WJ+S
         uJH0Kk1kjGFnLXD7JfMcebgtKhDJXqBCl6Qw+WBlc+LVMOU4tmLhGJDMzDxbCGdkBdJL
         tAsLvjns55Q/Jj2tt8wJry+B/zx+d4TbK6BYU=
Date: Mon, 23 May 2011 11:13:12 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>, linux-input@vger.kernel.org
Subject: Re: select() on /dev/input/eventX not level-triggered?
Message-ID: <20110523181312.GA20438@core.coreip.homeip.net>
References: <20110519235051.GA9782@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110519235051.GA9782@elf.ucw.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 20, 2011 at 01:50:51AM +0200, Pavel Machek wrote:
> Hi!
> 
> I'm debugging strange behaviour on /dev/input/eventX ... it seems that
> select is not behaving level-triggered as it apparently should. I can
> reproduce it when hitting windows & alt keys.
> 
> Now, I really should rewrite it into C, first, but perhaps someone has
> an idea?

Is this with next or with mainline? In next we try not to signal that FD
is ready unless we have full packet in the buffer...

FWIW I see python indeed not reading the tail of events (btw the format
should be 'llhhi' and the size on 64 bit arches is 24, not 16) but when
I hacked evtest to use select and non-blockign read it all worked
properly.

Thanks.

-- 
Dmitry
