Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756923Ab0FVRvx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 13:51:53 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:34577 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751240Ab0FVRvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 13:51:52 -0400
Date: Tue, 22 Jun 2010 18:50:58 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       David Quan <David.Quan@atheros.com>, Bob Copeland <me@bobcopeland.com>,
       "Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>,
       ath5k-devel@venema.h4ckr.net, linux-wireless@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jonathan May <jonathan.may@atheros.com>
Subject: Re: [ath5k-devel] [PATCH v2] ath5k: disable ASPM
Message-ID: <20100622175058.GA23499@srcf.ucam.org>
References: <AANLkTim8iZmm8pEERJUsrQWOiLSjPUfCN-TFFzZZQWx2@mail.gmail.com> <1277151410.5409.33.camel@maxim-laptop> <20100621233333.21262abjfxl8j1xc@hayate.sektori.org> <AANLkTikkt4dqYWrwtTCJ8tJZLB1kZXgF1KvaPsIOO3Dl@mail.gmail.com> <20100622163138.GD20668@srcf.ucam.org> <AANLkTikQkLFdpusfcLVOpyZHFrxwB5akr-ggFB7Fjm08@mail.gmail.com> <20100622165213.GA21842@srcf.ucam.org> <AANLkTikHLBBWrhCP_1f5Jv7zE9RKPvdsl5nSyfkeMfLl@mail.gmail.com> <20100622172545.GA22680@srcf.ucam.org> <AANLkTilEHJ5qRD8ov0gIK0Zc4o-gJUPYkvHdyD1uZUon@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTilEHJ5qRD8ov0gIK0Zc4o-gJUPYkvHdyD1uZUon@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 22, 2010 at 10:40:15AM -0700, Luis R. Rodriguez wrote:
> On Tue, Jun 22, 2010 at 10:25 AM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> > Right, which we have to deal with by having drivers disable ASPM on
> > broken devices.
> 
> Agreed, but then the assumption would be drivers are ASPM bug free
> which is expect to be false with Video and 802.11 given that only a
> handful of vendors do actually get involved with their drivers
> upstream. Safe thing of course is to just disable it, of course, but
> if you are going to use pcie_aspm=force good luck!

People who use "force" deserve whatever they get, but "powersave" really 
ought to work. Fedora's defaulted to that for a while now - we've hit 
issues with aacraid, but that's pretty much it in terms of cases where 
the heuristics don't work. Maxim's problems wouldn't be triggered 
because CONFIG_PCIE_ASPM disables it on pre-1.1 devices regardless of 
the BIOS setup.

> > Having looked into this, Windows will enable ASPM on external
> > controllers unless there's some reason for it not to - where that may be
> > either the appropriate bit in the FADT being set, the device not being
> > PCIe 1.1 or later, there being no _OSC method on the appropriate root
> > bridge or the _OSC method not giving it full control over PCIe, the
> > driver disabling ASPM or the device not advertising it in the first
> > place.
> 
> I was unaware of all this root complex sanity checks on Windows,
> thanks for sharing.

With the patch I've just sent, they should also all be used for Linux as 
well.

> I suspect these tweaks will go away as the industry produces cards
> with both L1 and L0s enabled all the time (devices being produced
> today), but for devices caught in that middle of time between whether
> or not L0s would be *required*  (last 2 years) I suspect we'll run
> into these issues.

If the same problems would appear under Windows then it's not a problem 
that I'm hugely concerned about as yet - we'll wait a bit longer and 
then change the ASPM defaults to be more aggressive under Linux, and if 
it turns out to be a significant problem in the real world we'll have to 
reconsider it. But I don't think we should be depending on userspace 
bashing hardware registers in order to be able to enable power 
management.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
