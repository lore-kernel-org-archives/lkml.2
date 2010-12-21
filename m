Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752879Ab0LUThU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 14:37:20 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:41056 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751493Ab0LUThS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 14:37:18 -0500
Subject: Re: [PATCH V7 1/8] ntp: add ADJ_SETOFFSET mode bit
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
In-Reply-To: <AANLkTi=yGoFwYt4p_LeHtAQyYgmURspO-p57UdL0sUEZ@mail.gmail.com>
References: <cover.1292512461.git.richard.cochran@omicron.at>
	 <880d82bb8120f73973db27e0c48e949014b1a106.1292512461.git.richard.cochran@omicron.at>
	 <AANLkTi=yGoFwYt4p_LeHtAQyYgmURspO-p57UdL0sUEZ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 21 Dec 2010 11:37:04 -0800
Message-ID: <1292960224.2618.4.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-12-18 at 05:16 +0900, Kuwahara,T. wrote:
> On 12/17/10, Richard Cochran <richardcochran@gmail.com> wrote:
> > This patch adds a new mode bit into the timex structure. When set, the bit
> > instructs the kernel to add the given time value to the current time.
> >
> 
> The proposed new control mode, ADJ_SETOFFSET, is logically the same as
> ADJ_OFFSET with timex.constant == -INFINITY. 

I'm not sure if this is correct. Its more like settimeofday, only giving
a relative offset to jump the clock, rather then an absolute time. It
does not slew the clock over time like ADJ_OFFSET does.

>  So it is possible to do
> the same thing without risking forward compatibility.  (I mean by "risking
> forward compatibility" that the mode bit 0x0040 may be defined differently
> by the upstream maintainer anytime in the future.)

adjtimex is a linux specific interface, which is compatible but not
identical to the ntp specified interfaces. The ntp client code already
has Linux specific modifications, so I don't think we have to worry
about 0x40 specifically being reserved by the NTP client.

thanks
-john


