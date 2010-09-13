Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754569Ab0IMSHO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 14:07:14 -0400
Received: from one.firstfloor.org ([213.235.205.2]:33277 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753512Ab0IMSHM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 14:07:12 -0400
Date: Mon, 13 Sep 2010 20:07:07 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Don Zickus <dzickus@redhat.com>
Cc: Huang Ying <ying.huang@intel.com>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC 5/6] x86, NMI, Add support to notify hardware error with
 unknown NMI
Message-ID: <20100913200707.3b31429e@basil.nowhere.org>
In-Reply-To: <20100913175346.GC26290@redhat.com>
References: <1284087065-32722-1-git-send-email-ying.huang@intel.com>
	<1284087065-32722-5-git-send-email-ying.huang@intel.com>
	<20100910160211.GH4879@redhat.com>
	<20100910181929.4f35ab7c@basil.nowhere.org>
	<20100910184039.GK4879@redhat.com>
	<1284344389.3269.82.camel@yhuang-dev.sh.intel.com>
	<20100913141140.GB27371@redhat.com>
	<20100913172438.37443bf7@basil.nowhere.org>
	<20100913154750.GA26290@redhat.com>
	<20100913185721.59ad9b4d@basil.nowhere.org>
	<20100913175346.GC26290@redhat.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> Honestly, I don't think you need much screen real estate.  It would be
> nice when an unknown NMI comes in, if the kernel just pokes around
> the hardware registers and display a summary of what it found.  For
> example,
> 
> The following devices had error bits set in the status registers:
> PCI device x:y.z - STATUS_BIT1 | STATUS_BIT2
> HW device xyz - STATUS_BIT3
> ...

You mean data from the generic PCI config space?

I don't think i would feel comfortable with arbitrary driver callbacks
(the risk of the driver breaking the panic would be high)

But if it's generic if not on the screen it should
be at least in the error serialization data and logged after boot.

At least on PCI-E it may be enough to simply dump all recent AER
data.

> 
> But I guess if we accept the fact that an unknown NMI will panic the
> box, then we can probably be a little more liberal in breaking
> spinlocks and poking around the hardware to display some userful info.

You have to be a bit careful with that, you may caused nested errors
(e.g. machine checks or more NMIs). I suppose this could be checked for
though.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
