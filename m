Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753465Ab0EOADO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 20:03:14 -0400
Received: from cpoproxy2-pub.bluehost.com ([67.222.39.38]:53634 "HELO
	outbound-mail-158.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751250Ab0EOADM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 20:03:12 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=Txq3v8zXrRjswSSE+SCrRNKa/JrWT0+rOoJxZELgAT0Qtc47VJaoo0S0sETlotYSCx4dWMqSjZ3iNNmOnLWx8lILa+6Z1GGl3/pdmQBcCoWUSmNTff2sepauf/zLTD/8;
Date: Fri, 14 May 2010 17:02:15 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Mike Travis <travis@sgi.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Mike Habeck <habeck@sgi.com>, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
       Jacob Pan <jacob.jun.pan@intel.com>, Tejun Heo <tj@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Yinghai <yinghai.lu@oracle.com>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       Myron Stowe <myron.stowe@hp.com>
Subject: Re: [Patch 1/1] x86 pci: Add option to not assign BAR's if not
 already assigned
Message-ID: <20100514170215.363d5121@virtuousgeek.org>
In-Reply-To: <4BEDDF87.4040309@zytor.com>
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
	<20100514163347.52822fcb@virtuousgeek.org>
	<4BEDDF87.4040309@zytor.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.110.194.140 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 May 2010 16:40:55 -0700
"H. Peter Anvin" <hpa@zytor.com> wrote:

> On 05/14/2010 04:33 PM, Jesse Barnes wrote:
> > 
> > As for BIOS coordination for dynamic reallocation, yeah there'd be some
> > of that.  I think the basic principles would be:
> >   1) use BIOS allocations wherever possible
> >   2) get an accurate list of available resources from the BIOS for
> >      potential remapping later
> >   3) allocate resources for BARs and devices as late as possible (e.g.
> >      at driver bind time) to avoid allocating more than we need
> > 
> > But that's a good chunk of work, and as we've seen, PCs in particular
> > are really sensitive to having resources moved around too much, so step
> > (2) is probably the hardest part.
> > 
> 
> The real problem that I see, as outlined before, has nothing to do with
> the BIOS, but rather the interdependencies between resources.

I was using the term "BIOS" loosely to refer to safe ranges to allocate
resources.  Your topology example is a good one, there are definite
dependencies between devices, especially on large systems.  But in both
simple and complex cases, we still need to have resource ranges
available, or we'll have no where to put things at all.

-- 
Jesse Barnes, Intel Open Source Technology Center
