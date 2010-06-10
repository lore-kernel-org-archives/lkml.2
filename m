Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932332Ab0FJCed (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 22:34:33 -0400
Received: from ozlabs.org ([203.10.76.45]:41092 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752819Ab0FJCec (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 22:34:32 -0400
Date: Thu, 10 Jun 2010 12:30:33 +1000
From: Anton Blanchard <anton@samba.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: TAMUKI Shoichi <tamuki@linet.gr.jp>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <andi@firstfloor.org>, Andy Green <andy@warmcat.com>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] panic: keep blinking in spite of long spin timer
 mode
Message-ID: <20100610023033.GN28295@kryten>
References: <20100603153016.cbe6ff0c.akpm@linux-foundation.org>
 <201006061319.AA01345@tamuki.linet.gr.jp>
 <20100609151552.d1a8ca8d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100609151552.d1a8ca8d.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 
Hi,

> Morse code?  Kidding?
> 
> Sorry, no.  Nobody who uses this feature will know what what
> "words per minute" means.  It's nutty!
> 
> Please remind me why we're making this configurable at all.  Can't we
> just hardwire the thing to 1Hz or something?  Add an
> im_using_a_hypervisor boot option or something, if necessary?

I agree. The panic_blink() interface is quite painful and I have no idea
why someone would want to configure the blink frequency of their keyboard
LED when panicing. Maybe they want to match it to the beat of their techno
music.

Since the keyboard LED default is a transition every 0.5s, why don't we just
remove i8042.panicblink and change all users (all 2 of them) to expect a 2 HZ
call rate? The hypervisor case should be fine with 0.5s mdelays, so we end up
removing that special case.

I would have said 1 HZ, but it seems like the default was chosen to be
different to kdb:

	/*
         * We expect frequency to be about 1/2s. KDB uses about 1s.
         * Make sure they are different.
	 */

No idea if that comment is still valid.

Anton
