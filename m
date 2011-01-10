Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754791Ab1AJVLl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 16:11:41 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:52118 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753751Ab1AJVLj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 16:11:39 -0500
Subject: Re: [PATCH V8 02/13] ntp: add ADJ_SETOFFSET mode bit
From: john stultz <johnstul@us.ibm.com>
To: "Kuwahara,T." <6vvetjsrt26xsrzlh1z0zn4d2grdah@gmail.com>
Cc: Richard Cochran <richardcochran@gmail.com>, linux-kernel@vger.kernel.org,
        linux-api@vger.kernel.org, netdev@vger.kernel.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Christoph Lameter <cl@linux.com>, David Miller <davem@davemloft.net>,
        Krzysztof Halasa <khc@pm.waw.pl>,
        Peter Zijlstra <peterz@infradead.org>,
        Rodolfo Giometti <giometti@linux.it>,
        Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <AANLkTimS0-ih=WZ_GvPi9NFjbYMT4OctWV943ri4GuTD@mail.gmail.com>
References: <cover.1293820862.git.richard.cochran@omicron.at>
	 <fe2bec763bec155381d62721aa9da84aeca2785c.1293820862.git.richard.cochran@omicron.at>
	 <AANLkTini2WdT-1v4k9V3JOZYDkA59P+SyscTe8-fK2Wk@mail.gmail.com>
	 <20110108175028.GA22308@riccoc20.at.omicron.at>
	 <AANLkTikigXGSACF6R6kfNHyKZ7GFWrUrCMxygvL3fUC6@mail.gmail.com>
	 <20110110071759.GA4864@riccoc20.at.omicron.at>
	 <AANLkTimS0-ih=WZ_GvPi9NFjbYMT4OctWV943ri4GuTD@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 10 Jan 2011 13:11:32 -0800
Message-ID: <1294693892.3068.17.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-01-11 at 05:47 +0900, Kuwahara,T. wrote:
> On Mon, Jan 10, 2011 at 4:17 PM, Richard Cochran
> <richardcochran@gmail.com> wrote:
> > the PTP Hardware Clocks for which this whole patch
> > set was created in the first place will keep their time as TAI.
> 
> Are you sure of that?  I don't have the standard handy (it's non-free,
> right?) but it seems that the Annex B states differently.  But that's
> not the point anyway.  My concern is that your patch not only adds the
> useless (and broken) feature to the existing syscall but also makes a
> permanent change to the public interface for your own use.  That's
> what I'm against.  So if you stop touching the struct timex, I won't
> complain anymore.

You still haven't explained *why* you're so protective of the timex and
adjtimex interfaces.  While I do want to keep compatible the
functionality where possible, I don't see why Linux should be limited by
what other OSes do.

Injecting an offset to the system time seems like a reasonable thing for
adjtimex to do (rather then adding a new syscall). Further utilizing a
new mode bit for this functionality seems reasonable and cleaner then
your suggestions for utilizing existing mode bits in combined with other
magic bits. If there is a compelling reason why not to do this, do
please let us know! We might just agree with you after hearing it. :)

thanks
-john


