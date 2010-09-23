Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932072Ab0IWUc6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 16:32:58 -0400
Received: from smtp107.prem.mail.ac4.yahoo.com ([76.13.13.46]:25289 "HELO
	smtp107.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755689Ab0IWUc4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 16:32:56 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: EzUGkGoVM1nUa8.0SYTPO_mVN74hh1uQVWUNLiWGCW25eZg
 .calj1FmUtdssjkYZUb5_u.0lOi04YvJIilkgIHqxJHKQisetVQ6Zpd5Mw0R
 tA4qutQioRW0o5d6ny8dJlSnZjOCFQZoIKtkrABdXlWaz0l6U27gmESPTxic
 R2z7nhHvEgEhTkUs6fKr8_09p27tABDNdngXKdSAYik9X1cPFAlch7xMLMwC
 M
X-Yahoo-Newman-Property: ymail-3
Date: Thu, 23 Sep 2010 15:32:50 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Richard Cochran <richardcochran@gmail.com>, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-api@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
        netdev@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        David Miller <davem@davemloft.net>, John Stultz <johnstul@us.ibm.com>,
        Krzysztof Halasa <khc@pm.waw.pl>,
        Peter Zijlstra <peterz@infradead.org>,
        Rodolfo Giometti <giometti@linux.it>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 6/8] ptp: Added a clock that uses the eTSEC found on the
 MPC85xx.
In-Reply-To: <20100923214359.3f287b11@lxorguk.ukuu.org.uk>
Message-ID: <alpine.DEB.2.00.1009231527330.7522@router.home>
References: <cover.1285261533.git.richard.cochran@omicron.at> <57b64051c816dc9cb856bbb9f38fc901c9d3d651.1285261535.git.richard.cochran@omicron.at> <alpine.DEB.2.00.1009231348150.2962@router.home> <20100923214359.3f287b11@lxorguk.ukuu.org.uk>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Sep 2010, Alan Cox wrote:

> > Please do not introduce useless additional layers for clock sync. Load
> > these ptp clocks like the other regular clock modules and make them sync
> > system time like any other clock.
>
> I don't think you understand PTP. PTP has masters, a system can need to
> be honouring multiple conflicting masters at once.

The upshot of it all has to be some synchronized notion of time regardless
of how many other things are going on under the hood. And the spec here
suggests a hardware able to generate periodic accurate events that can be
used to sync system time.

> > Really guys: I want a PTP solution! Now! And not some idiotic additional
> > kernel layers that just pass bits around because its so much fun and
> > screws up clock accurary in due to the latency noise introduced while
> > having so much fun with the bits.
>
> There are some interesting complications in putting a PTP sync
> interface in kernel.

If the PTP logic internally has to juggle multiple clocks then that is a
complication for the driver ok. In any case the driver ultimately has to
provide *one* source of time for the system to sync to.
