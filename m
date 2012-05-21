Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757701Ab2EUOIa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 10:08:30 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:52203 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757153Ab2EUOI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 10:08:28 -0400
Date: Mon, 21 May 2012 16:08:22 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Vlad Zolotarov <vlad@scalemp.com>
Cc: "Shai Fultheim (Shai@ScaleMP.com)" <Shai@scalemp.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ido Yariv <ido@wizery.com>
Subject: Re: [PATCH v3 0/2] Move x86_cpu_to_apicid to the __read_mostly
 section
Message-ID: <20120521140822.GA12976@gmail.com>
References: <1337527148.6093.14.camel@vlad>
 <9B14D1490DDECA4E974F6B9FC9EBAB317D295F4D11@VMBX108.ihostexchange.net>
 <20120521123246.GB17065@gmail.com>
 <1693911.sUneyHzERA@vlad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1693911.sUneyHzERA@vlad>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Vlad Zolotarov <vlad@scalemp.com> wrote:

> On Monday, May 21, 2012 02:32:46 PM Ingo Molnar wrote:
> > * Shai Fultheim (Shai@ScaleMP.com) <Shai@ScaleMP.com> wrote:
> > > Ingo,
> > > 
> > > The reason for this, as you pointed out, is the 'cache line'
> > > size (4096 bytes).  We see significant false sharing is we do
> > > not move this next to each other.
> > 
> > Which write-often variable caused the many cache flushes/fills?
> > cpu_to_apicid is read mostly.
> > 
> > I.e. it might make more sense to identify the frequenty 
> > *modified* percpu variables, and move them to a separate 
> > section. I *think* most percpu variables are read mostly, so 
> > it would be more maintainable in the long run to figure out 
> > the frequently modified ones, not the frequently not 
> > modified ones.
> 
> I tend to disagree about the general claim that most per-CPU 
> variables are read-mostly: consider the per-CPU data 
> structures used in lock-less algorithms like softnet_data used 
> in a NAPI. I'm not sure what is a more common - read- only or 
> not-read-only per-cpu data, but surely there are both...

Well, a quick tally of percpu variables on a 'make defconfig' 
kernel would tell us one way or another?

Here there's almost 200 percpu variables active in the 64-bit 
x86 defconfig, and a quick random sample suggests that most are 
read-mostly.

I have no fundamental prefer to either approach, but the 
direction taken should be justified explicitly, with numbers, 
arguments, etc. - also a short blurb somewhere in the headers 
that explains when they should be used, so that others can be 
aware of vSMP's special needs here.

Thanks,

	Ingo
