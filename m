Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933781Ab0FRRFs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 13:05:48 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:15692 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933745Ab0FRRFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 13:05:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=qC1Id1DcCE8oc1zpMwFHKnMqrOfDK3JkQ2WBQYXnbhBr8IIAItMVK+XjLIIS8d8+pd
         sDrbpKjiV28ILHV1a2UolUYYQJL9aKGstYxbUBpENAd0ZRiWkOS0nPUcR3AFFPcwOC1m
         l3fYIqGBVXlXncW/8Vyf+BQfnYYFgHo7BtNzQ=
Subject: Re: [PATCH] pci: Don't enable aspm before drivers have had a
 chance to veto it
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Matthew Garrett <mjg@redhat.com>,
       Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
       "Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>,
       linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20100618091255.2db036ea@virtuousgeek.org>
References: <1276113907-22432-1-git-send-email-mjg@redhat.com>
	 <1276862811.19918.10.camel@maxim-laptop>
	 <20100618091255.2db036ea@virtuousgeek.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 18 Jun 2010 20:05:42 +0300
Message-ID: <1276880742.23783.7.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-06-18 at 09:12 -0700, Jesse Barnes wrote: 
> On Fri, 18 Jun 2010 15:06:51 +0300
> Maxim Levitsky <maximlevitsky@gmail.com> wrote:
> 
> > On Wed, 2010-06-09 at 16:05 -0400, Matthew Garrett wrote: 
> > > The aspm code will currently set the configured aspm policy before drivers
> > > have had an opportunity to indicate that their hardware doesn't support it.
> > > Unfortunately, putting some hardware in L0 or L1 can result in the hardware
> > > no longer responding to any requests, even after aspm is disabled. It makes
> > > more sense to leave aspm policy at the BIOS defaults at initial setup time,
> > > reconfiguring it after pci_enable_device() is called. This allows the
> > > driver to blacklist individual devices beforehand.
> > > 
> > > Signed-off-by: Matthew Garrett <mjg@redhat.com>
> > > ---
> > 
> > Hi,
> > 
> > I recently discovered that my aspire one wireless troubles (card just
> > dies after a while) are caused by ASPM L0S state.
> > The device (AR5001) seems to have a hardware bug, and it also disables
> > L0S in windows driver.
> > 
> > Unfortenuly BIOS (news at 11) enables L0S.
> > 
> > Its easy to disable ASPM from driver. It just a matter of calling
> > pci_disable_link_state.
> > 
> > However, that depends on CONFIG_PCIEASPM.
> > 
> > How about making pci_disable_link_state always available or even better,
> > just make CONFIG_PCIEASPM unconditional?
> 
> The former is ok with me.  Care to post a patch?
It not that simple at first glance.
This functions uses plenty of code from the aspm.c, therefore care
should be taken to do that properly.

Of course the easy solution is to compile all code in always, and just
disable it by runtime switch (it even exists, aspm_disabled)
Or, another easy solution is to make ath5k depend on CONFIG_PCIEASPM

What do you think?

Best regards,
Maxim Levitsky

