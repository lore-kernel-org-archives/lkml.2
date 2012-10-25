Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936050Ab2JYUNE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 16:13:04 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:37704 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934218Ab2JYUNC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 16:13:02 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Borislav Petkov <bp@alien8.de>, Dave Hansen <dave@linux.vnet.ibm.com>,
        Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] add some drop_caches documentation and info messsge
Date: Thu, 25 Oct 2012 22:16:58 +0200
Message-ID: <1484035.7aMAWXqOf7@vostro.rjw.lan>
User-Agent: KMail/4.8.5 (Linux/3.6.3-8-desktop; KDE/4.8.5; x86_64; ; )
In-Reply-To: <20121024181752.de011615.akpm@linux-foundation.org>
References: <20121012125708.GJ10110@dhcp22.suse.cz> <1787395.7AzIesGUbB@vostro.rjw.lan> <20121024181752.de011615.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, October 24, 2012 06:17:52 PM Andrew Morton wrote:
> On Thu, 25 Oct 2012 00:04:46 +0200 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > On Wednesday 24 of October 2012 14:13:03 Andrew Morton wrote:
> > > On Wed, 24 Oct 2012 23:06:00 +0200
> > > Borislav Petkov <bp@alien8.de> wrote:
> > > 
> > > > On Wed, Oct 24, 2012 at 01:48:36PM -0700, Andrew Morton wrote:
> > > > > Well who knows. Could be that people's vm *does* suck. Or they have
> > > > > some particularly peculiar worklosd or requirement[*]. Or their VM
> > > > > *used* to suck, and the drop_caches is not really needed any more but
> > > > > it's there in vendor-provided code and they can't practically prevent
> > > > > it.
> > > > 
> > > > I have drop_caches in my suspend-to-disk script so that the hibernation
> > > > image is kept at minimum and suspend times are as small as possible.
> > > 
> > > hm, that sounds smart.
> > > 
> > > > Would that be a valid use-case?
> > > 
> > > I'd say so, unless we change the kernel to do that internally.  We do
> > > have the hibernation-specific shrink_all_memory() in the vmscan code. 
> > > We didn't see fit to document _why_ that exists, but IIRC it's there to
> > > create enough free memory for hibernation to be able to successfully
> > > complete, but no more.
> > 
> > That's correct.
> 
> Well, my point was: how about the idea of reclaiming clean pagecache
> (and inodes, dentries, etc) before hibernation so we read/write less
> disk data?

We may actually want to write more into the image to improve post-resume
responsiveness.

> Given that it's so easy to do from the hibernation script, I guess
> there's not much point...

Well, I'd say so. :-)

 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
