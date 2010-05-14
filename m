Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755087Ab0ENW0M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 18:26:12 -0400
Received: from cpoproxy3-pub.bluehost.com ([67.222.54.6]:52684 "HELO
	outbound-mail-313.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754081Ab0ENW0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 18:26:09 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=UYI5HhaJkAvB21EC/UWHCtqCXUvXJbh9aQCzXRMMh7qWixS7m2zdlv9YODweSaAJVyUutDsT2IIQJwYll7sVzJOtzamYYcsQs64LbW8ClZy6IEeRgHxLslmskvcyyH+V;
Date: Fri, 14 May 2010 15:25:09 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Mike Habeck <habeck@sgi.com>, Mike Travis <travis@sgi.com>,
       Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
       Jacob Pan <jacob.jun.pan@intel.com>, Tejun Heo <tj@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Yinghai <yinghai.lu@oracle.com>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       Myron Stowe <myron.stowe@hp.com>
Subject: Re: [Patch 1/1] x86 pci: Add option to not assign BAR's if not
 already assigned
Message-ID: <20100514152509.3aeb37b4@virtuousgeek.org>
In-Reply-To: <201005131402.30759.bjorn.helgaas@hp.com>
References: <4BEAF008.9030805@sgi.com>
	<201005131256.17997.bjorn.helgaas@hp.com>
	<4BEC5530.1000008@sgi.com>
	<201005131402.30759.bjorn.helgaas@hp.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.110.194.140 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 May 2010 14:02:30 -0600
Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
> > > This issue is not specific to x86, so I don't really like having
> > > the implementation be x86-specific.
> > 
> > I agree this isn't a x86 specific issue but given the 'norom'
> > cmdline option is basically doing the same thing (but for pci
> > Expansion ROM BARs) this code was modeled after it.
> 
> IMHO, we should fix both.

Yeah, that would be good.  Mike, have you looked at this at all?

Also, to clarify, this isn't affecting users today, right?  Or do you
need all this I/O space for multiple IOHs and the drivers that bind to
them in current UV systems?

Fundamentally, until we have real dynamic PCI resource management (i.e.
driver hooks for handling relocation, lazy allocation of resources at
driver bind time, etc.) we're going to continue to need hacks like
this.  However, we could make them slightly more automated by making
"nobar" and "norom" the default on systems that typically need them,
maybe with a DMI table.

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
