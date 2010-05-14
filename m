Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760035Ab0ENWsJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 18:48:09 -0400
Received: from cpoproxy2-pub.bluehost.com ([67.222.39.38]:53578 "HELO
	outbound-mail-158.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753825Ab0ENWsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 18:48:07 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=XgKGSwFLQ/mrBHePFbLPRwZ+1FbTWVwtziqpOWoEvEyIS7te1C1yU0kYigm6bdxPIUljT5fLuKeRuL9zKb3CSTcUaQ7u6QCbDkUxJBKJ5yS7XRIo610SOrSyogtOLc+7;
Date: Fri, 14 May 2010 15:47:06 -0700
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
Message-ID: <20100514154706.4f36f4ed@virtuousgeek.org>
In-Reply-To: <4BEDCFD9.7020202@sgi.com>
References: <4BEAF008.9030805@sgi.com>
	<201005131256.17997.bjorn.helgaas@hp.com>
	<4BEC5530.1000008@sgi.com>
	<201005131402.30759.bjorn.helgaas@hp.com>
	<20100514152509.3aeb37b4@virtuousgeek.org>
	<4BEDCFD9.7020202@sgi.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.110.194.140 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 May 2010 15:34:01 -0700
Mike Travis <travis@sgi.com> wrote:

> 
> 
> Jesse Barnes wrote:
> > On Thu, 13 May 2010 14:02:30 -0600
> > Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
> >>>> This issue is not specific to x86, so I don't really like having
> >>>> the implementation be x86-specific.
> >>> I agree this isn't a x86 specific issue but given the 'norom'
> >>> cmdline option is basically doing the same thing (but for pci
> >>> Expansion ROM BARs) this code was modeled after it.
> 
> >> IMHO, we should fix both.
> > 
> > Yeah, that would be good.  Mike, have you looked at this at all?
> > 
> > Also, to clarify, this isn't affecting users today, right?  Or do you
> > need all this I/O space for multiple IOHs and the drivers that bind to
> > them in current UV systems?
> 
> We have customers that want to install more than 16 PCI-e cards right
> now.  Our window of opportunity closes very soon (days), so either this
> patch makes it in as is (or something close), or we wait for another
> release cycle.  UV shipments start this month.
> 
> [I wouldn't mind working on an improvement for later.]

Wow and they're using cards that want to use I/O space?  Funky.  It's
too late to get this into 2.6.34, but that can't be what you were
expecting... I don't see a problem with getting something like this in
for 2.6.35.

> > Fundamentally, until we have real dynamic PCI resource management (i.e.
> > driver hooks for handling relocation, lazy allocation of resources at
> > driver bind time, etc.) we're going to continue to need hacks like
> > this.  However, we could make them slightly more automated by making
> > "nobar" and "norom" the default on systems that typically need them,
> > maybe with a DMI table.
> 
> It seems that BIOS changes are much more difficult.  The real solution
> to this problem is for Card Vendors to not request I/O Bars if they
> won't be using them.  But that's the hardest option of all to accomplish.

Right.

-- 
Jesse Barnes, Intel Open Source Technology Center
