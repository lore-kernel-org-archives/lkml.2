Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759424Ab0I1GrT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 02:47:19 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:38107 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753329Ab0I1GrS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 02:47:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=fxDXVxp/hoYBquiWtTWCN88jLdoHtO+1Ghu/Q19nJ4VpiN1wIiLw0MpKtG8jZQ+Dhq
         hu43kjpT4j2qtgWVjuib1LM70F48ez0jdMcI620D2mUZqxReLH64I1jZ2fxqS5INih1a
         Twleiiv41a6/zok5A2K/+vfNy1MNrOuuNqIs8=
Date: Tue, 28 Sep 2010 08:47:10 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Christoph Lameter <cl@linux.com>, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-api@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
        netdev@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        David Miller <davem@davemloft.net>, John Stultz <johnstul@us.ibm.com>,
        Krzysztof Halasa <khc@pm.waw.pl>,
        Peter Zijlstra <peterz@infradead.org>,
        Rodolfo Giometti <giometti@linux.it>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v6 0/8] ptp: IEEE 1588 hardware clock support
Message-ID: <20100928064710.GB7224@riccoc20.at.omicron.at>
References: <cover.1285261533.git.richard.cochran@omicron.at>
 <20100923213654.0c64b047@lxorguk.ukuu.org.uk>
 <20100924131407.GA3113@riccoc20.at.omicron.at>
 <20100924150246.0e6064b6@lxorguk.ukuu.org.uk>
 <alpine.DEB.2.00.1009271054320.9258@router.home>
 <20100927180558.52817d5f@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100927180558.52817d5f@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 27, 2010 at 06:05:58PM +0100, Alan Cox wrote:
> On Mon, 27 Sep 2010 10:56:09 -0500 (CDT)
> Christoph Lameter <cl@linux.com> wrote:
> 
> > 
> > On Fri, 24 Sep 2010, Alan Cox wrote:
> > 
> > > Whether you add new syscalls or do the fd passing using flags and hide
> > > the ugly bits in glibc is another question.
> > 
> > Use device specific ioctls instead of syscalls?
> 
> Some of the ioctls are probably not device specific, the job of the OS in
> part is to present a unified interface. We already have a mess of HPET
> and RTC driver ioctls.

Yes, and the whole point of introducing a PTP hardare clock API was to
avoid each new clock driver introducing yet another ioctl interface.

I had proposed a standard ioctl interface for PTP hardware clocks, but
that interface was rightly criticized for duplicating the posix clock
API. It does not make sense to have multiple interfaces with the exact
same functionality.

It is impossible to support every last feature of every possible
hardware clock with a generic interface, so there will always need to
be special ioctls for such features.

However, some clock functions *are* completely generic and apply to
every clock:

- set time
- get time
- adjust the frequency by N ppb
- shift the time by a given offset

The first two are provided by the posix clock interface, the third by
the NTP adjtimex call, which also can support (by a single mode
extension) the last item.

Richard
