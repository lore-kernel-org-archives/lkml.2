Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753874Ab1AJQtN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 11:49:13 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:44959 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753623Ab1AJQtL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 11:49:11 -0500
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
In-Reply-To: <AANLkTikigXGSACF6R6kfNHyKZ7GFWrUrCMxygvL3fUC6@mail.gmail.com>
References: <cover.1293820862.git.richard.cochran@omicron.at>
	 <fe2bec763bec155381d62721aa9da84aeca2785c.1293820862.git.richard.cochran@omicron.at>
	 <AANLkTini2WdT-1v4k9V3JOZYDkA59P+SyscTe8-fK2Wk@mail.gmail.com>
	 <20110108175028.GA22308@riccoc20.at.omicron.at>
	 <AANLkTikigXGSACF6R6kfNHyKZ7GFWrUrCMxygvL3fUC6@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 10 Jan 2011 08:49:05 -0800
Message-ID: <1294678145.3068.6.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-01-10 at 06:07 +0900, Kuwahara,T. wrote:
> On Sun, Jan 9, 2011 at 2:50 AM, Richard Cochran
> <richardcochran@gmail.com> wrote:
> > we want to be able to jump the clock arbitrarily.
> 
> Another problem remains:  How do you deal with leap seconds?  I mean,
> given that 1 minute is not always 60 seconds, then what time was it
> XXXXX seconds ago?   Maybe some kind of lookup table is necessary, but
> in such case, isn't it a better choice just to use the
> clock_settime/settimeofday syscall?

Leapsecond processing is done via an absolute hrtimer. Thus when the
time offset is set, the hrtimers that should have expired will fire
(just like with settimeofday) and the adjustment will then be made.

thanks
-john







