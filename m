Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753999Ab2EEI3Y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 04:29:24 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:37149 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753823Ab2EEI3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 04:29:18 -0400
Date: Sat, 5 May 2012 10:29:17 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Michal Marek <mmarek@suse.cz>
Cc: linux arch <linux-arch@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        Richard Weinberger <richard@nod.at>,
        "David S. Miller" <davem@davemloft.net>,
        Arnaud Lacombe <lacombar@gmail.com>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 3/4] kbuild: link of vmlinux moved to a script
Message-ID: <20120505082916.GA14006@merkur.ravnborg.org>
References: <20120428205651.GA7426@merkur.ravnborg.org> <20120428205919.GC7442@merkur.ravnborg.org> <4FA460AB.6060309@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FA460AB.6060309@suse.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 05, 2012 at 01:05:15AM +0200, Michal Marek wrote:
> Hi Sam,
> 
> Thanks a lot for this work and sorry for the delay.
> 
> Dne 28.4.2012 22:59, Sam Ravnborg napsal(a):
> > +kallsymso=""
> > +kallsyms_vmlinux=""
> > +if [ -n "${CONFIG_KALLSYMS}" ]; then
> > +
> [...]
> > +
> > +	kallsymso=.tmp_kallsyms2.o
> > +	kallsyms_vmlinux=.tmp_vmlinux2
> > +
> > +	# step 1
> > +	vmlinux_link "" .tmp_vmlinux1
> > +	kallsyms .tmp_vmlinux1 .tmp_kallsyms1.o
> > +
> > +	# step 2
> > +	vmlinux_link .tmp_kallsyms1.o .tmp_vmlinux2
> > +	kallsyms .tmp_vmlinux2 .tmp_kallsyms2.o
> > +
> > +	# step 2a
> > +	if [ -n "${KALLSYMS_EXTRA_PASS}" ]; then
> > +		kallsymso=.tmp_kallsyms3.o
> > +		kallsyms_vmlinux=.tmp_vmlinux2
> 
> This should read ".tmp_vmlinux3".
Well spotted!

> Also, how about storing these two
> variables in the kallsyms() function instead? That way, you have the
> assignment in one place only and this block becomes a little simpler.
I kep them as is - as the current version is more explicit.
Hiding this inside kallsyms() is fewer lines but less obvious.

And part of this was to increase readability.

Updated patch-set sent out.

Thanks,
	Sam
