Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753244Ab0LUV74 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 16:59:56 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:41426 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751076Ab0LUV7z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 16:59:55 -0500
Subject: Re: [PATCH V7 1/8] ntp: add ADJ_SETOFFSET mode bit
From: john stultz <johnstul@us.ibm.com>
To: "Kuwahara,T." <6vvetjsrt26xsrzlh1z0zn4d2grdah@gmail.com>,
        Alexander Gordeev <lasaine@lvk.cs.msu.su>,
        Rodolfo Giometti <giometti@enneenne.com>
Cc: Richard Cochran <richardcochran@gmail.com>, linux-kernel@vger.kernel.org,
        linux-api@vger.kernel.org, netdev@vger.kernel.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Christoph Lameter <cl@linux.com>, David Miller <davem@davemloft.net>,
        Krzysztof Halasa <khc@pm.waw.pl>,
        Peter Zijlstra <peterz@infradead.org>,
        Rodolfo Giometti <giometti@linux.it>,
        Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <AANLkTikHV-qN73Zvvvxn76vtFFKG_VNTQhF3qpqTnOrE@mail.gmail.com>
References: <cover.1292512461.git.richard.cochran@omicron.at>
	 <880d82bb8120f73973db27e0c48e949014b1a106.1292512461.git.richard.cochran@omicron.at>
	 <AANLkTi=yGoFwYt4p_LeHtAQyYgmURspO-p57UdL0sUEZ@mail.gmail.com>
	 <1292960224.2618.4.camel@work-vm>
	 <AANLkTikHV-qN73Zvvvxn76vtFFKG_VNTQhF3qpqTnOrE@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 21 Dec 2010 13:59:44 -0800
Message-ID: <1292968784.2618.51.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-12-22 at 06:13 +0900, Kuwahara,T. wrote:
> On Wed, Dec 22, 2010 at 4:37 AM, john stultz <johnstul@us.ibm.com> wrote:
> > adjtimex is a linux specific interface, which is compatible but not
> > identical to the ntp specified interfaces. The ntp client code already
> > has Linux specific modifications, so I don't think we have to worry
> > about 0x40 specifically being reserved by the NTP client.
> 
> But struct timex is not linux-specific...

It is if you're compiling against linux's timex.h file. 

We already have a number of differences compared with BSD's timex mode
definitions:
We have ADJ_TICK: 0x4000, which is MOD_CLKB in FreeBSD.
We also have ADJ_OFFSET_SINGLESHOT and ADJ_OFFSET_SS_READ which allow
adjtimex act like the original ntp_adjtime.

The key bit is that we map the shared MOD_* definitions that the NTP
client uses to the linux specific ADJ_* values in the linux timex.h

However, your concern does bring up a good point: 0x40 is MOD_PPSMAX in
BSD, and we should at-least check to make sure that the PPS code that is
currently floating around on the lists and is in akpm's tree hasn't
already reserved that bit.

Rodolfo, Alexander: Any comments here?

thanks
-john


