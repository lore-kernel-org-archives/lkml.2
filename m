Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758051Ab1EaH1N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 03:27:13 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:47303 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751324Ab1EaH1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 03:27:11 -0400
Date: Tue, 31 May 2011 08:26:50 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: David Rientjes <rientjes@google.com>
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Eric Miao <eric.y.miao@gmail.com>, Samuel Ortiz <samuel@sortiz.org>
Subject: Re: IrDA driver fails on PXA255
Message-ID: <20110531072650.GC21382@n2100.arm.linux.org.uk>
References: <20110528205701.GA1788@doriath.ww600.siemens.net> <alpine.DEB.2.00.1105281628480.9934@chino.kir.corp.google.com> <BANLkTim9YdhjY75CzMsSOCVKZWi-WKZ5wA@mail.gmail.com> <alpine.DEB.2.00.1105291410450.9658@chino.kir.corp.google.com> <20110529215656.GA5576@n2100.arm.linux.org.uk> <alpine.DEB.2.00.1105302202510.18793@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1105302202510.18793@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 30, 2011 at 10:05:38PM -0700, David Rientjes wrote:
> On Sun, 29 May 2011, Russell King - ARM Linux wrote:
> > Again, no.  This change has caused a load of previously working drivers
> > to suddenly start failing without _any_ explanation why or even warning
> > about the change.  It needs to start off as a WARN_ON() so that stuff
> > can be fixed, and then changed to a hard error.
> > 
> 
> I haven't seen a "load" of error reports where this is causing an issue, 
> maybe it is much more popular on arm?
> 
> This also isn't a hard error, admins should be able to enable 
> CONFIG_ZONE_DMA and rebuild so that the driver being loaded can get the 
> type of memory it is requesting.  Just putting a WARN_ON() doesn't provide 
> any incentive to ever get this stuff fixed.

I completely and violently disagree with your approach on this, and I'll
continue to state that I believe you are wrong until you change your
position.

Enabling CONFIG_ZONE_DMA is not a fix, it's making the problem vanish off
the radar.  It will mean that the drivers using GFP_DMA will never get
fixed up.

I don't care whether you say "it's easy enough to audit the source code" -
who's going to do that work?  If you make the problem go away the answer
to that will be NO ONE.

Change it to be a soft WARN_ON for one release.  Anything else will just
result in the problem being IGNORED.
