Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754665Ab0IMSYI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 14:24:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4550 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752515Ab0IMSYG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 14:24:06 -0400
Date: Mon, 13 Sep 2010 14:23:54 -0400
From: Don Zickus <dzickus@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Huang Ying <ying.huang@intel.com>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC 5/6] x86, NMI, Add support to notify hardware error with
 unknown NMI
Message-ID: <20100913182354.GE26290@redhat.com>
References: <20100910160211.GH4879@redhat.com>
 <20100910181929.4f35ab7c@basil.nowhere.org>
 <20100910184039.GK4879@redhat.com>
 <1284344389.3269.82.camel@yhuang-dev.sh.intel.com>
 <20100913141140.GB27371@redhat.com>
 <20100913172438.37443bf7@basil.nowhere.org>
 <20100913154750.GA26290@redhat.com>
 <20100913185721.59ad9b4d@basil.nowhere.org>
 <20100913175346.GC26290@redhat.com>
 <20100913200707.3b31429e@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100913200707.3b31429e@basil.nowhere.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 13, 2010 at 08:07:07PM +0200, Andi Kleen wrote:
> 
> > 
> > Honestly, I don't think you need much screen real estate.  It would be
> > nice when an unknown NMI comes in, if the kernel just pokes around
> > the hardware registers and display a summary of what it found.  For
> > example,
> > 
> > The following devices had error bits set in the status registers:
> > PCI device x:y.z - STATUS_BIT1 | STATUS_BIT2
> > HW device xyz - STATUS_BIT3
> > ...
> 
> You mean data from the generic PCI config space?

Yes. I normally just look at the Status register.  With PCI-e I'll look at
the other status registers in the capabilities field too.

> 
> I don't think i would feel comfortable with arbitrary driver callbacks
> (the risk of the driver breaking the panic would be high)

Neither would I.

> 
> But if it's generic if not on the screen it should
> be at least in the error serialization data and logged after boot.

I guess I don't know what that is, 'error serialization data'.  Is there
somewhere I can read more about it?

> 
> At least on PCI-E it may be enough to simply dump all recent AER
> data.

This assumes AER is supported on the bridge?  Which for newer chips is
probably true, but I wasn't sure about older ones.

How would I dump AER data from within the kernel?

> 
> > 
> > But I guess if we accept the fact that an unknown NMI will panic the
> > box, then we can probably be a little more liberal in breaking
> > spinlocks and poking around the hardware to display some userful info.
> 
> You have to be a bit careful with that, you may caused nested errors
> (e.g. machine checks or more NMIs). I suppose this could be checked for
> though.

Of course.

Cheers,
Don
