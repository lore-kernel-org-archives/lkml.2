Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751520Ab1GMUAY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 16:00:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15380 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751058Ab1GMUAW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 16:00:22 -0400
Date: Wed, 13 Jul 2011 16:00:04 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Michael Holzheu <holzheu@linux.vnet.ibm.com>, ebiederm@xmission.com,
        hbabu@us.ibm.com, mahesh@linux.vnet.ibm.com, oomichi@mxs.nes.nec.co.jp,
        horms@verge.net.au, heiko.carstens@de.ibm.com,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [patch 0/9] kdump: Patch series for s390 support
Message-ID: <20110713200004.GG4426@redhat.com>
References: <20110704170922.976299676@linux.vnet.ibm.com>
 <20110705202615.GJ24348@redhat.com>
 <1309944287.3937.39.camel@br98xy6r>
 <20110707193321.GE28850@redhat.com>
 <20110708110121.5acfc3c9@mschwide>
 <20110711144255.GE30674@redhat.com>
 <20110711175626.121dcc58@mschwide>
 <20110713160239.GE4426@redhat.com>
 <20110713184611.6dcb09b4@mschwide>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110713184611.6dcb09b4@mschwide>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 13, 2011 at 06:46:11PM +0200, Martin Schwidefsky wrote:

[..]
> > What I am suggesting is that stand alone dumper gets control only if
> > kdump kernel is corrupted.
> > 
> > So following sequence.
> > 
> > Kernel Crash ---> purgatory --> either kdump kenrel/IPL stand alone tools
> > 
> > Here only drawback seems to be that we assume that purgatory code and
> > pre-calculated checksum has not been corrupted. The big advantage is
> > that s390 kdump support looks very similar to other arches and
> > understaning and supporting kdump across architectures becomes easy.
> 
> My problem with that is the following: how do we get from the "Kernel Crash"
> step to the purgatory code? It does work for "normal" panics, but it fails
> miserably for a hard crash that does not even get as far as panic. That is
> why we insist on a possible second order of things:

What is hard crash? How does that happen and what does x86 and s390
do in that case?

Though I don't have details but your argument seems to be that in s390
we are always guranteed that we will jump to IPLing the stand alone
tools code irresepective of the system state hence it is relatively
safer to do checks in stand alone tools instead of purgatory where
code is in memory.

If due to hard hang, code can not even make to purgatory, where would
it go? Can't we do IPLing of stand alone tool then. 

So we first try to take purgatory path which does the checksum and is
consistent with other architectures. If that does not work in case
of hard hang, you always have the option of IPLing the stand alone tool
later manually.

This will also get rid of requirement passing all the segment and cheksum
info to stand alone tool with the help of meminfo (That's another sore
point). 

Bottom line, even if you can't make to purgatory reliably, you always
have the option of capturing dump manually using stand alone tools. We
don't have to mix up kdump and stand alone mechanism. If kdump fails, we
just need to have capability to still capture the dump using stand alone
tools manually. I think that will make things simpler even for stand alone
tools.

Thanks
Vivek
