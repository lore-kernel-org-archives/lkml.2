Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933268Ab2JYBSG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 21:18:06 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43325 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933171Ab2JYBSE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 21:18:04 -0400
Date: Wed, 24 Oct 2012 18:17:52 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Borislav Petkov <bp@alien8.de>, Dave Hansen <dave@linux.vnet.ibm.com>,
        Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] add some drop_caches documentation and info messsge
Message-Id: <20121024181752.de011615.akpm@linux-foundation.org>
In-Reply-To: <1787395.7AzIesGUbB@vostro.rjw.lan>
References: <20121012125708.GJ10110@dhcp22.suse.cz>
	<20121024210600.GA17037@liondog.tnic>
	<20121024141303.0797d6a1.akpm@linux-foundation.org>
	<1787395.7AzIesGUbB@vostro.rjw.lan>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Oct 2012 00:04:46 +0200 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> On Wednesday 24 of October 2012 14:13:03 Andrew Morton wrote:
> > On Wed, 24 Oct 2012 23:06:00 +0200
> > Borislav Petkov <bp@alien8.de> wrote:
> > 
> > > On Wed, Oct 24, 2012 at 01:48:36PM -0700, Andrew Morton wrote:
> > > > Well who knows. Could be that people's vm *does* suck. Or they have
> > > > some particularly peculiar worklosd or requirement[*]. Or their VM
> > > > *used* to suck, and the drop_caches is not really needed any more but
> > > > it's there in vendor-provided code and they can't practically prevent
> > > > it.
> > > 
> > > I have drop_caches in my suspend-to-disk script so that the hibernation
> > > image is kept at minimum and suspend times are as small as possible.
> > 
> > hm, that sounds smart.
> > 
> > > Would that be a valid use-case?
> > 
> > I'd say so, unless we change the kernel to do that internally.  We do
> > have the hibernation-specific shrink_all_memory() in the vmscan code. 
> > We didn't see fit to document _why_ that exists, but IIRC it's there to
> > create enough free memory for hibernation to be able to successfully
> > complete, but no more.
> 
> That's correct.

Well, my point was: how about the idea of reclaiming clean pagecache
(and inodes, dentries, etc) before hibernation so we read/write less
disk data?

Given that it's so easy to do from the hibernation script, I guess
there's not much point...


