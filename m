Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754000Ab0LKBhy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 20:37:54 -0500
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:52948 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753132Ab0LKBhw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 20:37:52 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=nLhD2FPRQZQ2DsvZeLlw/NsDQfRS5jjv05osPDRXr+El/CbnJQXMtqgwlaH3BTWWAtfUvZMnruTKRwErkPEF5Ro4EEwnJVPUYEYYdskA6lkgYiTXrkIOZw506hIAPfPj;
Date: Fri, 10 Dec 2010 17:37:49 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Len Brown <lenb@kernel.org>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Adam Belay <abelay@mit.edu>,
        Matthew Garrett <mjg@redhat.com>, Dan Williams <dcbw@redhat.com>,
        rjw@sisk.pl
Subject: Re: [PATCH 1/5] resources: add arch hook for preventing allocation
 in reserved areas
Message-ID: <20101210173749.7ec3cc28@jbarnes-desktop>
In-Reply-To: <201012101407.24419.bjorn.helgaas@hp.com>
References: <20101208213606.13026.47657.stgit@bob.kio>
	<20101210123008.7fed582d@jbarnes-desktop>
	<20101210123609.73c12a23@jbarnes-desktop>
	<201012101407.24419.bjorn.helgaas@hp.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.174.193.198 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Dec 2010 14:07:24 -0700
Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:

> On Friday, December 10, 2010 01:36:09 pm Jesse Barnes wrote:
> > [Actually cc'ing Matthew this time]
> > 
> > On Fri, 10 Dec 2010 12:30:08 -0800
> > Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> > 
> > > On Wed, 08 Dec 2010 14:36:06 -0700
> > > Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
> > > 
> > > > 
> > > > This adds arch_remove_reservations(), which an arch can implement if it
> > > > needs to protect part of the address space from allocation.
> > > > 
> > > > Sometimes that can be done by just requesting a resource.  This hook is to
> > > > cover cases where protected area doesn't fit well in the hierarchical
> > > > resource tree.  For example, x86 BIOS E820 reservations are not related
> > > > to devices, so they may overlap part of, all of, or more than a device
> > > > resource.
> > > > 
> > > > Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
> > > > ---
> > > 
> > > Hm, this is bigger than the simple change of just avoiding the high 2M;
> > > Linus have you checked it out yet?  It's nicer than simply adjusting
> > > PCIBIOS_MAX_MEM since it will affect all resource callers rather than
> > > just PCI, but it's definitely bigger.
> 
> Dan Williams also reproduced the problem on a 2530p and tested this
> series (though I think he actually tested a backport in Fedora):
>   https://bugzilla.kernel.org/show_bug.cgi?id=23542#c7
>   https://bugzilla.kernel.org/show_bug.cgi?id=23542#c23
> 
> The simple PCIBIOS_MAX_MEM_32 change below will fix the 2530p problem,
> but it won't help fix the nx6325 problem Rafael reported; details at:
>   https://bugzilla.kernel.org/show_bug.cgi?id=23332#c20
> 
> Rafael did confirm on #acpi Wednesday that the full series fixed
> his nx6325.

Thanks, I'll add Dan and Rafael's tested-bys to the patches (they're
already in my for-linus tree).  Unless Linus has a problem with them
I'll send them over to him this weekend or Monday.

-- 
Jesse Barnes, Intel Open Source Technology Center
