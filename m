Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757099Ab2DFBb1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 21:31:27 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:50588 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756857Ab2DFBb0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 21:31:26 -0400
MIME-Version: 1.0
In-Reply-To: <1333674768.23520.123.camel@joe2Laptop>
References: <1333569554.864.3.camel@mop> <CA+55aFyMO=xx0xNvggR-1fs-jKi_zaayNfgCa3HCNkvH0yA16g@mail.gmail.com>
 <1333655231.725.27.camel@mop> <1333674768.23520.123.camel@joe2Laptop>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 5 Apr 2012 18:31:04 -0700
X-Google-Sender-Auth: r23aJlsDdosSpBlY10nKYFCR50s
Message-ID: <CA+55aFyE41U9OPr7mrAA2ZJKuQ2jvH-KmusUNyfYbH8tOm6yiQ@mail.gmail.com>
Subject: Re: [PATCH] printk: support structured and multi-facility log messages
To: Joe Perches <joe@perches.com>
Cc: Kay Sievers <kay@vrfy.org>, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartmann <greg@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 5, 2012 at 6:12 PM, Joe Perches <joe@perches.com> wrote:
>
> I still think this should be 3 patches not 1.

I do agree that that would be lovely. That patch is really hard to
read, and it would be helpful if some of it was split up a bit. For
example, separating out the "move log buffer to be packetized"
(without actually doing the new things) from for the "introduce new
interfaces" would be quite nice.

In fact, I think I could merge something that does the packetization
early, if it is fairly obvious that it doesn't do anything else. Just
making the dmesg ASCII timestamp be something that is a "read buffer"
time thing rather than "generate printk" time thing would be nice, and
I think the sequence numbers can be useful even with all the old
interfaces.

So if somebody wants to help with things like that, and try to turn
this into a more gradual thing, I think we could merge at least some
initial parts of this patch even for 3.4.

Anybody interested?

                  Linus

PS looking some more at the patch, it has some more obvious insanities
in it. Doing "SUBSYSTEM=(NULL subsystem)" is clearly just insane. If
you don't have a subsystem, you shouldn't have that key/value pair -
saying you have a NULL subsystem is just crazy. Details like this
would possibly stand out a bit more if it wasn't one big patch.
