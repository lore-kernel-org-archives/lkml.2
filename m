Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753551Ab0D0Bky (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 21:40:54 -0400
Received: from cpoproxy2-pub.bluehost.com ([67.222.39.38]:44483 "HELO
	outbound-mail-158.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753019Ab0D0Bkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 21:40:52 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=Y7BWDTQ6xaOkCUIbDMPNL4Lv2jn+GoJ4b+z9gK0gGsAiP2jNdkqLrXBvf9iTxQ3ADHsqI3cOAgPyry5guyb7Tpx3yvXUv0YnpePNln0+q3hgu4pXiU1l7VvzClALEwka;
Date: Mon, 26 Apr 2010 18:40:54 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Andy Isaacson <adi@hexapodia.org>,
       "R. Andrew Bailey" <bailey@akamai.com>, Yinghai <yinghai.lu@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       guenter.roeck@ericsson.com,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Thomas Renninger <trenn@suse.de>, yaneti@declera.com
Subject: Re: [PATCH] x86/PCI: never allocate PCI MMIO resources below   
 BIOS_END
Message-ID: <20100426184054.6f17a2b2@virtuousgeek.org>
In-Reply-To: <alpine.LFD.2.00.1004261824570.3739@i5.linux-foundation.org>
References: <2b1eecc3-75b8-4ab3-8932-fdf7cc1e181b@email.android.com>
	<20100426162517.4ad308ff@virtuousgeek.org>
	<a96459c7f3573eef81dd6d6c4e3dedd8.squirrel@www.zytor.com>
	<20100426170547.5d7daa47@virtuousgeek.org>
	<alpine.LFD.2.00.1004261824570.3739@i5.linux-foundation.org>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.110.194.140 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Apr 2010 18:27:27 -0700 (PDT)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Mon, 26 Apr 2010, Jesse Barnes wrote:
> > 
> > Glad we agree.  As I said (and echoing Bjorn), I think it would be best
> > to reserve this space in a way that doesn't just use IORESOURCE_BUSY.
> > We want and need to do allocations from the special region, so we
> > should mark it as such.
> 
> I think Bjorn's patch to pcibios_align_resource() is really good and 
> clever, and I think it should take care of the need for IORESOURCE_BUSY, 
> no? We do want to let devices that are _already_ allocated there insert 
> their resources, it's just that we never want to allocate new ones in the 
> low 1M region.
> 
> Do we actually have a regression left with Bjorn's patch?

No, I think we're covered.  But it sounded like Peter was also
concerned about making new allocations from the 1M space, which would
mean we'd need something other than the IORESOURCE_BUSY bit.  But maybe
Bjorn's patch plus simply removing the IORESOURCE_BUSY line is
sufficient for that.  The downside there is that it doesn't clearly
communicate the special nature of the 1M region.

-- 
Jesse Barnes, Intel Open Source Technology Center
