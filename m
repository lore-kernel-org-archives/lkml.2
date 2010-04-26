Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755153Ab0DZTbk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 15:31:40 -0400
Received: from cpoproxy3-pub.bluehost.com ([67.222.54.6]:34989 "HELO
	outbound-mail-313.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754735Ab0DZTbf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 15:31:35 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=SvbODjmuSyQ9vWHsqZVp3OlIpdF1NJBdNBNjqmeICdhpCcjZfwS4h6jCG/1AUK/CG+d69WYYeZ5M+1GL47Aj79aKZ4xeqLfCDlbUqQ2bUv1U7Ta92Au+7BoSJoKIlJs1;
Date: Mon, 26 Apr 2010 12:31:35 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Andy Isaacson <adi@hexapodia.org>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>,
       "R. Andrew Bailey" <bailey@akamai.com>, Yinghai <yinghai.lu@oracle.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, guenter.roeck@ericsson.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Thomas Renninger <trenn@suse.de>, yaneti@declera.com
Subject: Re: [PATCH] x86/PCI: never allocate PCI MMIO resources below
 BIOS_END
Message-ID: <20100426123135.5d095d2f@virtuousgeek.org>
In-Reply-To: <20100426183436.GV11130@hexapodia.org>
References: <4BC4E55B.7000103@oracle.com>
	<4BCE8E3E.4030809@oracle.com>
	<20100421193120.GD11130@hexapodia.org>
	<201004231705.25659.bjorn.helgaas@hp.com>
	<20100426183436.GV11130@hexapodia.org>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.110.194.140 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Apr 2010 11:34:36 -0700
Andy Isaacson <adi@hexapodia.org> wrote:

> On Fri, Apr 23, 2010 at 05:05:24PM -0600, Bjorn Helgaas wrote:
> > On Wednesday 21 April 2010 01:31:20 pm Andy Isaacson wrote:
> > > On Tue, Apr 20, 2010 at 10:33:50PM -0700, Yinghai wrote:
> > > > Update e820 at first, and later put them resource tree.
> > > > Reserved that early, will not be allocated to unassigned PCI BAR
> > > > 
> > > > v3: remove probe_roms() that is not needed, because whole range is reserved
> > > > 	 already
> > > 
> > > Test booted this patch series on the problematic t3400, seems to work
> > > fine.  dmesg attached to bug 15744.
> > 
> > Thanks for testing (again).  I'm not confident that this series is
> > going to be successful, so I started looking for other approaches.
> > 
> > I can't reproduce the exact problem you're seeing, but in my
> > kludged-up attempt, the patch below is enough to keep us from
> > assigning the space below 1MB to a device.
> > 
> > Would you guys (Andy & Andy, what a coincidence :-)) mind giving
> > it a try?  This is intended to work on top of current upstream,
> > with no other patches required.
> > 
> > Bjorn
> > 
> > 
> > commit 7fb707eb97fdf6dc4fa4b127f127f8d00223afc7
> > Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
> > Date:   Fri Apr 23 15:22:10 2010 -0600
> > 
> > x86/PCI: never allocate PCI MMIO resources below BIOS_END
> >     
> > When we move a PCI device or assign resources to a device not configured
> > by the BIOS, we want to avoid the BIOS region below 1MB.  Note that if the
> > BIOS places devices below 1MB, we leave them there.
> 
> Works for me.  dmesg at
> https://bugzilla.kernel.org/attachment.cgi?id=26150

Great, thanks for testing.  Applied this one to my for-linus tree.  I
still thing Yinghai's patches should go in as well (marking regions as
busy seems like good housekeeping), but with this fixed they're a better
fit for -next.

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
