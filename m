Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755240Ab0DZUh7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 16:37:59 -0400
Received: from cpoproxy3-pub.bluehost.com ([67.222.54.6]:47280 "HELO
	outbound-mail-313.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755197Ab0DZUh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 16:37:57 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=fEYTnSre6T/asB/yfyjTAzSobhmRhhOgd1NZ18VSADOh0A8GV2DUDqr1yvmc6EzCgiajHUOiVg/3+oEunlQ/d/+zHUZfAaB3FdPRYV9pXgE6holHAHLURjL+rj4UsY7X;
Date: Mon, 26 Apr 2010 13:37:57 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Andy Isaacson <adi@hexapodia.org>, "R. Andrew Bailey" <bailey@akamai.com>,
       Yinghai <yinghai.lu@oracle.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       guenter.roeck@ericsson.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Thomas Renninger <trenn@suse.de>, yaneti@declera.com
Subject: Re: [PATCH] x86/PCI: never allocate PCI MMIO resources below
 BIOS_END
Message-ID: <20100426133757.3e1d0a75@virtuousgeek.org>
In-Reply-To: <201004261427.57229.bjorn.helgaas@hp.com>
References: <4BC4E55B.7000103@oracle.com>
	<20100426183436.GV11130@hexapodia.org>
	<20100426123135.5d095d2f@virtuousgeek.org>
	<201004261427.57229.bjorn.helgaas@hp.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.110.194.140 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Apr 2010 14:27:56 -0600
Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
> I'm a little concerned that those patches are a sledgehammer approach.
> Previously, IORESOURCE_BUSY has basically been used for mutual exclusion
> between drivers that would otherwise claim the same resource.  It hasn't
> been used to guide resource assignment in the PCI/PNP/etc core.  Maybe
> it's a good idea to also use IORESOURCE_BUSY there, but I'm not sure.
> Right now it feels like undesirable overloading to me.

I guess that's true, removing those regions from the pool entirely
might be better?  Or some other, clear way of expressing that the
regions aren't available to drivers.  Maybe we need a new IO resource
type for platform ranges.

> I think it also leads to at least one problem: Guenter's machine has no
> VGA but has a PCI device that lives at 0xa0000.  The driver for that
> device won't be able to request that region if the arch code has marked
> it busy.

Ah good point, so we'll want another approach at any rate.  Yinghai?

-- 
Jesse Barnes, Intel Open Source Technology Center
