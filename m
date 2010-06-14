Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756570Ab0FNVPt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 17:15:49 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47403 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756468Ab0FNVPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 17:15:48 -0400
Date: Mon, 14 Jun 2010 14:14:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: TAMUKI Shoichi <tamuki@linet.gr.jp>
Cc: Ingo Molnar <mingo@elte.hu>, Anton Blanchard <anton@samba.org>,
       Andi Kleen <andi@firstfloor.org>, Andy Green <andy@warmcat.com>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] panic: keep blinking in spite of long spin timer
 mode
Message-Id: <20100614141447.d11c5dac.akpm@linux-foundation.org>
In-Reply-To: <201006102231.AA00429@tamuki.linet.gr.jp>
References: <20100609151552.d1a8ca8d.akpm@linux-foundation.org>
	<201006102231.AA00429@tamuki.linet.gr.jp>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Jun 2010 07:31:13 +0900
TAMUKI Shoichi <tamuki@linet.gr.jp> wrote:

> Hello,
> 
> On Wed, 9 Jun 2010 15:15:52 -0700 Andrew Morton wrote:
> 
> > Morse code?  Kidding?
> 
> I'm sorry, I'm confusing you.
> 
> > Sorry, no.  Nobody who uses this feature will know what what
> > "words per minute" means.  It's nutty!
> 
> That is just a strained interpretation where the measure of the
> blinking speed comes from.  The description of "words per minute"
> has already disappeared in the latest patch.
> 
> > Please remind me why we're making this configurable at all.  Can't we
> > just hardwire the thing to 1Hz or something?  Add an
> > im_using_a_hypervisor boot option or something, if necessary?
> 
> For now, gta02_panic_blink(), one of panic_blink() users, expects a
> 10Hz call rate.  IOW, it blinks at 5Hz (i.e. panicblink=36).  I think
> that the desirable blinking speed is different according to devices.
> 

gta02_panic_blink() simply toggles a gpio output.  It's trivial to
convert that function to implement whatever behaviour we decide upon. 
Err, in fact your patch already does that.

I still don't think we should have a kernel boot option for this - it
just doesn't seem useful enough.  Can we please just hard-wire the
blinking frequency?  And once we've done that, we don't have to jump
through hoops with this "wpm" thing.  We can use Hz.

