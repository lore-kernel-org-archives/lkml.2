Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754162Ab0H0Oe0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 10:34:26 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45441 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753357Ab0H0OeZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 10:34:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=E/GY29MApqipfb/No+b4hVAleGBOVwH1EpVq7eAk+LtY1/oi0znUCoDijd62fel1Cm
         oWYsScbw60jajDVw6TdWS91Sn+PehuqdF+DCXa8CDiYwlEyRXx4gczU/DAbEPm1b10F1
         DdE7dOGNXzV7yFOXi9XliErX0IQxUhPRzoUps=
Date: Fri, 27 Aug 2010 16:34:37 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: john stultz <johnstul@us.ibm.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, Krzysztof Halasa <khc@pm.waw.pl>,
        Rodolfo Giometti <giometti@linux.it>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 1/5] ptp: Added a brand new class driver for ptp clocks.
Message-ID: <20100827143437.GB3293@riccoc20.at.omicron.at>
References: <363bd749a38d0b785d8431e591bf54c38db4c2d7.1281956490.git.richard.cochran@omicron.at>
 <AANLkTik_2MKMhOuDGOmu8Kzyq-ipLe+Bxrb3FaD+Tv4U@mail.gmail.com>
 <20100817085324.GB3330@riccoc20.at.omicron.at>
 <1282090963.1734.97.camel@localhost>
 <20100818071942.GA4096@riccoc20.at.omicron.at>
 <1282176776.2865.100.camel@localhost.localdomain>
 <20100819055518.GA4084@riccoc20.at.omicron.at>
 <1282594125.3111.344.camel@localhost.localdomain>
 <20100827123849.GC11657@riccoc20.at.omicron.at>
 <20100827143844.646eccf6@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100827143844.646eccf6@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 27, 2010 at 02:38:44PM +0100, Alan Cox wrote:
> > 2007. If we can justify adding a clock id in this case, surely we can
> > add one for PTP as well!
> 
> But PTP isn't really a clock - its a time sync protocol. You can (and may
> need to) have multiple clocks of this form on the same host because it's
> master based and you may have to deal with multiple masters who disagree.

Okay, I really meant "for PTP hardware clocks". In general the
discussion is about supporting a kind of hardware and not about the
PTP network protocol. In fact, the hardware clocks and clock servo
loops are not at all part of the IEEE 1588 standard.

Sorry for causing confusion, but please understand "a hardware clock
with timestamping capabilities than can be used for PTP support"
whenever I wrote "PTP" or "PTP clock."

Well, what I just said is not entirely true.

In fact, most of the current crop of PTP hardware clocks operate by
recognizing PTP network frames and timestamping them. One clock I know
of can timestamp every frame, but that seems to be the exception
rather than the rule. So, in theory they are just clocks, but actually
most are bound to the PTP protocol. That may change in the future...

> > viable approach. After the lkml discussion, I think it is even cleaner
> > and nicer to just offer a new clock id.
> 
> PTP is not a clock, it's many clocks so a clock id doesn't really work.
> You could assume a single time domain and add a CLOCK_TAI plus then use
> PTP to track it I guess ?
> 
> The question then is who would consume it and how ?
> 
> Generic applications want POSIX time, which is managed by NTP but could
> in userspace also be slewed via the existing API to track a PTP source if
> someone wanted and if there is a GPS source around they can compute UTC
> from it.

Yes, and even without a GPS, the PTP protocol (this time I really do
mean the protocol!) does provide the UTC offset whenever it is known.

> Specialist applications will presumably need to know which time source or
> sources they are tracking and synchronizing too out of multiple potential
> PTP sources

Yes, the PTPd will have some special knowledge.

> Kernel stuff is more of a problem.
> 
> I'm not sure shoehorning a source of many clocks and time sync bases into
> a jump up and down and make it fit single time assumption is wise. Making
> system time bimble track a source makes sense just as with NTP but making
> it a new clock seems the wrong model extending a non-too-bright API when
> you can just put the time sources in a file tree.

Don't get your meaning here, what did you mean by "file tree?"

Thanks,
Richard
