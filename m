Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754737Ab1AJVGw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 16:06:52 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:51003 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754605Ab1AJVGv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 16:06:51 -0500
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
In-Reply-To: <AANLkTikdg4Pb5c4wcCU3d3Eku=mpiW_TEkBz0A2VPdVp@mail.gmail.com>
References: <cover.1293820862.git.richard.cochran@omicron.at>
	 <fe2bec763bec155381d62721aa9da84aeca2785c.1293820862.git.richard.cochran@omicron.at>
	 <AANLkTini2WdT-1v4k9V3JOZYDkA59P+SyscTe8-fK2Wk@mail.gmail.com>
	 <20110108175028.GA22308@riccoc20.at.omicron.at>
	 <AANLkTikigXGSACF6R6kfNHyKZ7GFWrUrCMxygvL3fUC6@mail.gmail.com>
	 <1294678145.3068.6.camel@work-vm>
	 <AANLkTikdg4Pb5c4wcCU3d3Eku=mpiW_TEkBz0A2VPdVp@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 10 Jan 2011 13:06:37 -0800
Message-ID: <1294693597.3068.12.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-01-11 at 05:45 +0900, Kuwahara,T. wrote:
> On Tue, Jan 11, 2011 at 1:49 AM, john stultz <johnstul@us.ibm.com> wrote:
> > Leapsecond processing is done via an absolute hrtimer. Thus when the
> > time offset is set, the hrtimers that should have expired will fire
> > (just like with settimeofday) and the adjustment will then be made.
> 
> How do you convert relative time to absolute time?  It's not trivial
> because TAI offset is also a variable.

I don't believe I understand what you're getting at.

The proposed interface is almost identical in functionality to a
userland application doing the following:

	offset = my_calculate_offset();
	clock_gettime(CLOCK_REALTIME, &now);
	newtime = my_add_ts(now, offset);
	settimeofday(&newtime, 0);

The only difference is that you avoid the error from the delay between
the gettime call and the settime call. It just adds the offset directly
to the CLOCK_REALTIME.


thanks
-john



