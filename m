Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752593Ab0ENXer (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 19:34:47 -0400
Received: from cpoproxy3-pub.bluehost.com ([67.222.54.6]:42107 "HELO
	outbound-mail-313.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754626Ab0ENXep (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 19:34:45 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=idKgTqtLgsAVEIe+u5jtIq6IC2nSIO4Qs4opQGlVvAR9irqiSw51lOrkoTBvEqoIJBjzR4eED2YoNyOSiqf25h9jxlGibaBjP2hMXJ7iRg6OtKW31ONyxTSl4n6XRNNL;
Date: Fri, 14 May 2010 16:33:47 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Mike Travis <travis@sgi.com>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>, Mike Habeck <habeck@sgi.com>,
       Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
       Jacob Pan <jacob.jun.pan@intel.com>, Tejun Heo <tj@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Yinghai <yinghai.lu@oracle.com>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       Myron Stowe <myron.stowe@hp.com>
Subject: Re: [Patch 1/1] x86 pci: Add option to not assign BAR's if not
 already assigned
Message-ID: <20100514163347.52822fcb@virtuousgeek.org>
In-Reply-To: <4BEDDB88.6000608@sgi.com>
References: <4BEAF008.9030805@sgi.com>
	<201005131256.17997.bjorn.helgaas@hp.com>
	<4BEC5530.1000008@sgi.com>
	<201005131402.30759.bjorn.helgaas@hp.com>
	<20100514152509.3aeb37b4@virtuousgeek.org>
	<4BEDCFD9.7020202@sgi.com>
	<20100514154706.4f36f4ed@virtuousgeek.org>
	<4BEDD5BF.5030005@sgi.com>
	<20100514160651.2b4ee3d7@virtuousgeek.org>
	<4BEDDB88.6000608@sgi.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.110.194.140 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 May 2010 16:23:52 -0700
Mike Travis <travis@sgi.com> wrote:
> Thanks!  I was hoping you weren't going to say we need to remove the
> need for these options.

No, I won't force that on you just yet. :)

> I think the dynamic provisioning thing would be a great feature for the
> future, but it seems to me that it would entail quite a bit of coordinated
> effort between BIOS and the kernel?  Not to mention the final death of
> all POST related initialization (at least in the case where the device
> is not being used in Legacy mode)?  [Heck, can we kill POST too?!?] I
> haven't looked too closely at non-x86 arch's but unless they run an
> x86 emulator, then the POST initialization is pretty much superfluous,
> isn't it?  The drivers will initialize when the device comes online?
> I mean we do have more the 64k of memory now... ;-)]

Yeah, we can mostly ignore POST, though some BIOSes need it for their
boot time services.  Even complex graphics devices tend not to need it
these days as long as you have a fully capable driver.

As for BIOS coordination for dynamic reallocation, yeah there'd be some
of that.  I think the basic principles would be:
  1) use BIOS allocations wherever possible
  2) get an accurate list of available resources from the BIOS for
     potential remapping later
  3) allocate resources for BARs and devices as late as possible (e.g.
     at driver bind time) to avoid allocating more than we need

But that's a good chunk of work, and as we've seen, PCs in particular
are really sensitive to having resources moved around too much, so step
(2) is probably the hardest part.

-- 
Jesse Barnes, Intel Open Source Technology Center
