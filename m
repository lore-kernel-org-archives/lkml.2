Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756745Ab1CHVGG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 16:06:06 -0500
Received: from www.tglx.de ([62.245.132.106]:48174 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756477Ab1CHVGE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 16:06:04 -0500
Date: Tue, 8 Mar 2011 22:05:11 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Micha Nelissen <micha@neli.hopto.org>
cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        "Venkatesh Pallipadi (Venki)" <venki@google.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] Add support for multiple MSI on x86
In-Reply-To: <4D714357.3010807@neli.hopto.org>
Message-ID: <alpine.LFD.2.00.1103082143460.2787@localhost6.localdomain6>
References: <4D583E31.4070507@neli.hopto.org> <20110304103634.4641ae36@jbarnes-desktop> <4D714357.3010807@neli.hopto.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Mar 2011, Micha Nelissen wrote:
> Jesse Barnes wrote:
> > On Sun, 13 Feb 2011 21:25:21 +0100
> > Micha Nelissen <micha@neli.hopto.org> wrote:
> > 
> > > Patch is based on earlier patch from Matthew Wilcox.
> > 
> > I like this before when Matthew was working on it too
> 
> If I understood Thomas' concerns well, it sounds like this feature is
> inherently incompatible with big SMP systems. Therefore it has no chance of
> ever being accepted into mainline in whatever form?

First of all MSI is replaced by MSI-X which does not have the
shortcomings of MSI vs. the vector allocation.

Though if we can come up with a scheme which does not create nested
loops over possibly hundreds of CPUs with interrupts disabled and
global locks held, I have no objections.

One possible solution would be to reserve a block of vectors on all
cpus at boot time via a command line option for MSI block
allocations. That would simply use a bitmap protected by a mutex to
lookup a free vector space. That would avoid the whole loop issue and
work for most of the systems which need to deal with such MSI multi
vector devices. Warning: Just an idea :)

Thanks,

	tglx
