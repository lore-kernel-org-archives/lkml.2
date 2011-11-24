Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756023Ab1KXNWH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 08:22:07 -0500
Received: from he.sipsolutions.net ([78.46.109.217]:42038 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754801Ab1KXNWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 08:22:04 -0500
Subject: Re: [PATCH v2] printk: add console output tracing
From: Johannes Berg <johannes@sipsolutions.net>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Christoph Hellwig <hch@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>
In-Reply-To: <20111123131622.GA10669@somewhere.redhat.com> (sfid-20111123_141710_048738_F7FB6F6D)
References: <1321473443.4181.38.camel@frodo>
	 <1321478719.4502.20.camel@jlt3.sipsolutions.net>
	 <20111117145502.GA18437@somewhere>
	 <1321541877.3997.31.camel@jlt3.sipsolutions.net>
	 <20111117150040.GB18437@somewhere>
	 <1321543268.3997.40.camel@jlt3.sipsolutions.net>
	 <20111118184401.GA24787@somewhere.redhat.com>
	 <1321641975.10266.73.camel@jlt3.sipsolutions.net>
	 <20111118185449.GB24787@somewhere.redhat.com>
	 <1321642752.10266.75.camel@jlt3.sipsolutions.net>
	 <20111123131622.GA10669@somewhere.redhat.com>
	 (sfid-20111123_141710_048738_F7FB6F6D)
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 24 Nov 2011 14:21:59 +0100
Message-ID: <1322140919.5366.17.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-11-23 at 14:16 +0100, Frederic Weisbecker wrote:

> > Also, call_console_drivers() doesn't pass this start/end through to
> > _call_console_drivers(), it has loops and stuff there...
> 
> Yeah but looking at the loop there, start and end passed to
> __call_console_drivers() are bounded between start and end passed to
> call_console_drivers().

Looks like. Not that I have any idea why other code handles the wrap
then?

> > In any case -- feel free to clean it all up, I basically copied the
> > logic from _call_console_drivers assuming it was needed.
> 
> I'm just reviewing and suggesting a way to keep the patch more simple.
> Outside that, I don't really need that patch myself ;)

:-)

> > I don't really want to know about the printk details :-)
> 
> Well, it's like working out outside in winter. It may not sound
> very entertaining in the beginning but then it quickly becomes
> invigorating, toning and good for the mood...I think...

Heh....

I don't really feel comfortable modifying the _call_console_drivers()
function to not handle start > end (modulo log buf size of course), but
at the same time I don't feel comfortable putting code into it that
doesn't handle it.

johannes

