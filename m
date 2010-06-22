Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757876Ab0FVR0S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 13:26:18 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:58084 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756012Ab0FVR0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 13:26:15 -0400
Date: Tue, 22 Jun 2010 18:25:45 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       David Quan <David.Quan@atheros.com>, Bob Copeland <me@bobcopeland.com>,
       "Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>,
       ath5k-devel@venema.h4ckr.net, linux-wireless@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [ath5k-devel] [PATCH v2] ath5k: disable ASPM
Message-ID: <20100622172545.GA22680@srcf.ucam.org>
References: <AANLkTimIjaxq7IDWwIl1vv93k9bNQ2i89Sb5R5TiJmmA@mail.gmail.com> <1277032723.9555.12.camel@maxim-laptop> <AANLkTim8iZmm8pEERJUsrQWOiLSjPUfCN-TFFzZZQWx2@mail.gmail.com> <1277151410.5409.33.camel@maxim-laptop> <20100621233333.21262abjfxl8j1xc@hayate.sektori.org> <AANLkTikkt4dqYWrwtTCJ8tJZLB1kZXgF1KvaPsIOO3Dl@mail.gmail.com> <20100622163138.GD20668@srcf.ucam.org> <AANLkTikQkLFdpusfcLVOpyZHFrxwB5akr-ggFB7Fjm08@mail.gmail.com> <20100622165213.GA21842@srcf.ucam.org> <AANLkTikHLBBWrhCP_1f5Jv7zE9RKPvdsl5nSyfkeMfLl@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikHLBBWrhCP_1f5Jv7zE9RKPvdsl5nSyfkeMfLl@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 22, 2010 at 10:17:11AM -0700, Luis R. Rodriguez wrote:
> On Tue, Jun 22, 2010 at 9:52 AM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> > Why would you only want to enable ASPM for one device?
> 
> ASPM doesn't always work for all devices even if they do advertise
> ASPM capability so turning it on selectively by device is what I
> recommend since otherwise you may get hangs and you will then have to
> do the selective enabling.

Right, which we have to deal with by having drivers disable ASPM on 
broken devices.

> Furthermore laptops tend to disable ASPM for cards not built-in to it, 
> an example is Cardbus slots or internal PCI-E slots. This is often 
> done because to enable ASPM for some cards you often need to tune the 
> host controller in addition to enabling ASPM for the endpoint, so this 
> will vary depending on vendor, chipset, and host controller 
> combination. This is documentation that the OEM / ODM typically end up 
> getting, but not end users.

Having looked into this, Windows will enable ASPM on external 
controllers unless there's some reason for it not to - where that may be 
either the appropriate bit in the FADT being set, the device not being 
PCIe 1.1 or later, there being no _OSC method on the appropriate root 
bridge or the _OSC method not giving it full control over PCIe, the 
driver disabling ASPM or the device not advertising it in the first 
place. Are you aware of any other cases where Windows will refuse to 
enable ASPM?
 
-- 
Matthew Garrett | mjg59@srcf.ucam.org
