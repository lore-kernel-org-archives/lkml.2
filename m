Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753840Ab0H0OBz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 10:01:55 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:64583 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753628Ab0H0OBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 10:01:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=jLpRFm6AIoguhO4EhFLIBqpGfJeAq7JOA7FreMPtSCWbBse08BCeUp3YHnyNqwVu7o
         YSyHb5SCiKsgbdXBXpT4OGttA85mjK+Q2WZ0giKJrurjv1qdWma8UhAoudOSF7ec2Mit
         5X+xuxM3zCzss+sOFQ1o9Sv25jSwCRACqAb2o=
Date: Fri, 27 Aug 2010 16:02:05 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: john stultz <johnstul@us.ibm.com>,
        Christian Riesch <christian.riesch@omicron.at>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, Krzysztof Halasa <khc@pm.waw.pl>,
        Rodolfo Giometti <giometti@linux.it>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 1/5] ptp: Added a brand new class driver for ptp clocks.
Message-ID: <20100827140205.GA3293@riccoc20.at.omicron.at>
References: <20100817085324.GB3330@riccoc20.at.omicron.at>
 <1282090963.1734.97.camel@localhost>
 <20100818071942.GA4096@riccoc20.at.omicron.at>
 <1282176776.2865.100.camel@localhost.localdomain>
 <20100819055518.GA4084@riccoc20.at.omicron.at>
 <1282594125.3111.344.camel@localhost.localdomain>
 <AANLkTi=nKrRHH6+9mvny718gov8Q+u7DHFikdgNY8YdX@mail.gmail.com>
 <1282874269.4371.74.camel@localhost.localdomain>
 <20100827075727.GA3818@riccoc20.at.omicron.at>
 <20100827134154.50eef56c@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100827134154.50eef56c@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 27, 2010 at 01:41:54PM +0100, Alan Cox wrote:
> > The master node in a PTP network probably takes its time from a
> > precise external time source, like GPS. The GPS provides a 1 PPS
> > directly to the PTP clock hardware, which latches the PTP hardware
> > clock time on the PPS edge. This provides one sample as input to a
> > clock servo (in the PTPd) that, in turn, regulates the PTP clock
> > hardware.
> 
> A PTP clock is TAI, Unix time is UTC.

But TAI and UTC progress at the same rate, and UTC differs from TAI by
a constant offset. In fact, the needed conversion is provided by the
protocol, so it is not hard to take a 1 PPS from GPS and set the PTP
clock to TAI.

> > This is the core issue and source of misunderstanding, in my view. The
> > fact of the matter is, the current generation of computers has
> > multiple clocks, and these are usually unsynchronized. I think we
> > should not try too hard to cover up or work around this. It is a fact
> > of life.
> 
> In this case I don't think you can. Their divergence is rather difficult
> to handle unless you have a GPS to hand.
> 
> But all this talk of "PTP this" and "PTP that" is not helpful. Any
> interface for additional time sources should be generic with PTP being
> one use case.

To tell the truth, my original motivation for the patch set was to
support PTP clocks and applications. I don't think that is such a bad
idea. After all, the adjtimex interface was added just to support NTP.

At the same time, I can understand the desire to have a generic
hardware clock adjustment API. Let me see if I can understand and
summarize what people are asking for:

	  clock_adjtime(clockid_t id, struct timex *t);

and struct timex gets some new fields at the end.

Using the call, NTPd can call clock_adjtime(CLOCK_REALTIME) and PTPd
can call clock_realtime(CLOCK_PTP) and everyone is happy, no?

Thanks,
Richard
