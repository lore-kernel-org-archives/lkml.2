Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761263Ab0FRQOe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 12:14:34 -0400
Received: from cpoproxy1-pub.bluehost.com ([69.89.21.11]:37800 "HELO
	cpoproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1761165Ab0FRQOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 12:14:32 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=HALbmtgPa72UgFuEYz4tfD6jOnbhu3Hpz8Utj5FgPnmfFnFWDMyiQc0yEcyGuS8PhM9dDn1Xc+g3hkJHTwHFY/bnlCfFWg794HYz3OK2ARRgHXU5yzAm+Qq1kUH1k5hC;
Date: Fri, 18 Jun 2010 09:12:55 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Matthew Garrett <mjg@redhat.com>,
       Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
       "Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>,
       linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pci: Don't enable aspm before drivers have had a chance
 to veto it
Message-ID: <20100618091255.2db036ea@virtuousgeek.org>
In-Reply-To: <1276862811.19918.10.camel@maxim-laptop>
References: <1276113907-22432-1-git-send-email-mjg@redhat.com>
	<1276862811.19918.10.camel@maxim-laptop>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.110.194.140 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Jun 2010 15:06:51 +0300
Maxim Levitsky <maximlevitsky@gmail.com> wrote:

> On Wed, 2010-06-09 at 16:05 -0400, Matthew Garrett wrote: 
> > The aspm code will currently set the configured aspm policy before drivers
> > have had an opportunity to indicate that their hardware doesn't support it.
> > Unfortunately, putting some hardware in L0 or L1 can result in the hardware
> > no longer responding to any requests, even after aspm is disabled. It makes
> > more sense to leave aspm policy at the BIOS defaults at initial setup time,
> > reconfiguring it after pci_enable_device() is called. This allows the
> > driver to blacklist individual devices beforehand.
> > 
> > Signed-off-by: Matthew Garrett <mjg@redhat.com>
> > ---
> 
> Hi,
> 
> I recently discovered that my aspire one wireless troubles (card just
> dies after a while) are caused by ASPM L0S state.
> The device (AR5001) seems to have a hardware bug, and it also disables
> L0S in windows driver.
> 
> Unfortenuly BIOS (news at 11) enables L0S.
> 
> Its easy to disable ASPM from driver. It just a matter of calling
> pci_disable_link_state.
> 
> However, that depends on CONFIG_PCIEASPM.
> 
> How about making pci_disable_link_state always available or even better,
> just make CONFIG_PCIEASPM unconditional?

The former is ok with me.  Care to post a patch?

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
