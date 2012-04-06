Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753397Ab2DFDnh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 23:43:37 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:50414 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752930Ab2DFDng (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 23:43:36 -0400
Message-ID: <1333683815.23520.133.camel@joe2Laptop>
Subject: Re: [PATCH] printk: support structured and multi-facility log
 messages
From: Joe Perches <joe@perches.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Kay Sievers <kay@vrfy.org>, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartmann <greg@kroah.com>
Date: Thu, 05 Apr 2012 20:43:35 -0700
In-Reply-To: <CA+55aFyE41U9OPr7mrAA2ZJKuQ2jvH-KmusUNyfYbH8tOm6yiQ@mail.gmail.com>
References: <1333569554.864.3.camel@mop>
	 <CA+55aFyMO=xx0xNvggR-1fs-jKi_zaayNfgCa3HCNkvH0yA16g@mail.gmail.com>
	 <1333655231.725.27.camel@mop> <1333674768.23520.123.camel@joe2Laptop>
	 <CA+55aFyE41U9OPr7mrAA2ZJKuQ2jvH-KmusUNyfYbH8tOm6yiQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-04-05 at 18:31 -0700, Linus Torvalds wrote:
> On Thu, Apr 5, 2012 at 6:12 PM, Joe Perches <joe@perches.com> wrote:
> >
> > I still think this should be 3 patches not 1.
> 
> I do agree that that would be lovely. That patch is really hard to
> read, and it would be helpful if some of it was split up a bit. For
> example, separating out the "move log buffer to be packetized"
> (without actually doing the new things) from for the "introduce new
> interfaces" would be quite nice.
> 
> In fact, I think I could merge something that does the packetization
> early, if it is fairly obvious that it doesn't do anything else. Just
> making the dmesg ASCII timestamp be something that is a "read buffer"
> time thing rather than "generate printk" time thing would be nice, and
> I think the sequence numbers can be useful even with all the old
> interfaces.
> 
> So if somebody wants to help with things like that, and try to turn
> this into a more gradual thing, I think we could merge at least some
> initial parts of this patch even for 3.4.
> 
> Anybody interested?

I think it'll be a lot more sensible to
integrate this into a more granular printk
subsystem so I've just done a move and
split up of the printk bits.

kernel/printk.c -> kernel/printk/printk.c
and a breakup of printk.c into 4 parts

kernel/printk/log_buf.[ch]
kernel/printk/console.[ch]
kernel/printk/kmsg.[ch]
kernek/printk/printk.c

I think that's a lot more readable/extensible
and will make adding a new printk_emit and
devkmsg a bit simpler to understand as well.

Maybe it'd be useful to then add some compression
to the log_buf message string bits.

I'll submit that move/separate tomorrow but not
any compression after a few more compilation tests
w/ & w/o the appropriate CONFIG_ options.

Kay would have to respin though.

