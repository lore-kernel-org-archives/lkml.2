Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756506Ab0FCRdA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 13:33:00 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44727 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755896Ab0FCRc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 13:32:59 -0400
Date: Thu, 3 Jun 2010 10:28:17 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Stephen Hemminger <shemminger@vyatta.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: floppy driver assumes INITIAL_JIFFIES == 0
In-Reply-To: <20100603101501.5e5d7148@nehalam>
Message-ID: <alpine.LFD.2.00.1006031013060.8175@i5.linux-foundation.org>
References: <20100603101501.5e5d7148@nehalam>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 3 Jun 2010, Stephen Hemminger wrote:
> 
> The driver is a complex mess of spaghetti state. Does one of the original
> authors have more background to fix this?

Doubtful. There are no "original authors" left really. Yes, I technically 
wrote the original driver, but it has gotten seriously rewritten a couple 
of times - sadly always just expanding on the cruftyness.

I do wonder a bit why you even care. You can't even buy non-USB floppy 
drives any more (and even the USB ones are really really hard to find), 
and judging by my experiences, they don't last long enough for there to be 
much of a legacy base.

But please post the oops. I don't think it should ever be valid to oops 
even if it gets confused about first_read_date or last_checked. Some 
hacking around for them being "in the future" would be trivial enough.

But most of them shouldn't matter. The whole 'first_read_date', for 
example, is purely used for some randomness - it tries to use the 
'revolutions per second' to decide when to stop the drive, but that's just 
some voodoo programming and has no real meaning, afaik.

The oops would be interesting just to see _which_ case it is that we care 
about the time so much (clearly _too_ much).

		Linus
