Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754857Ab1AGWhq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 17:37:46 -0500
Received: from cpoproxy2-pub.bluehost.com ([67.222.39.38]:41568 "HELO
	cpoproxy2-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753656Ab1AGWho (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 17:37:44 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=m2ukGYMYaACZbyFUQN3N3+emmCWJEMLiFGArYOVqw5nZ6u3gGpbHC8l7foIHB8DpSDvMUpvidtUnsI7v9Sis4jWmXmGJ/XNuFVhRZv54DAB9TXDVhLstkwJJ6HAIESQm;
Date: Fri, 7 Jan 2011 14:37:41 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>, Jiri Slaby <jslaby@suse.cz>,
        linux-pci@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Thomas Renninger <trenn@suse.de>
Subject: Re: [PATCH 1/1] PCI: tune up ICH4 quirk for broken BIOSes
Message-ID: <20110107143741.7b2b2a8d@jbarnes-desktop>
In-Reply-To: <4D277B33.1000508@gmail.com>
References: <1294327066-23518-1-git-send-email-jslaby@suse.cz>
	<201101061224.40596.bjorn.helgaas@hp.com>
	<4D277B33.1000508@gmail.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.174.193.198 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 07 Jan 2011 21:44:35 +0100
Jiri Slaby <jirislaby@gmail.com> wrote:

> On 01/06/2011 08:24 PM, Bjorn Helgaas wrote:
> > Theoretically, ACPI tells us about the GPIO/TCO/etc. regions in a
> > generic way via namespace devices or something in the static tables.
> > Is that generic information missing, or is it there and Linux is
> > ignoring it?  If we're ignoring it, I'd rather fix that.
> 
> It works for most boxes I would say. Try to google for "claimed by ICH4
> ACPI/GPIO/TCO", it reports sane ranges like 0400-047f or 4000-407f.
> 
> > The main reason for claiming I/O regions is to keep us from placing
> > another device on top of them.  But we've had PCIBIOS_MIN_IO = 0x1000
> > forever, which should keep us from putting anything below that anyway
> > (at least for PCI devices).  So there must be some other reason for
> > claiming space in this quirk.
> 
> Anyway, this ACPI space may be below 0x1000 as can be seen above. From
> the ICH standard, it can be anywhere...

Is there some other resource we should be considering to avoid this
space?

And we know it won't work if we try to use the IDE controller in the
LPC allocated space?  Have you checked the ICH4 specs to see what the
decode rules are on this space?  I guess LPC has priority and doesn't
forward requests through to IDE?

Either way, it would be good to understand this issue a little better
before we start restricting the LPC space like this.

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
