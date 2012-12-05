Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754119Ab2LEVpK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 16:45:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39636 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752609Ab2LEVn6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 16:43:58 -0500
Date: Wed, 5 Dec 2012 19:32:03 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: kvm@vger.kernel.org, gleb@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/6] kvm: Growable memory slot array
Message-ID: <20121205213203.GE20260@amt.cnet>
References: <20121203231912.3661.57179.stgit@bling.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121203231912.3661.57179.stgit@bling.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 03, 2012 at 04:39:05PM -0700, Alex Williamson wrote:
> Memory slots are currently a fixed resource with a relatively small
> limit.  When using PCI device assignment in a qemu guest it's fairly
> easy to exhaust the number of available slots.  I posted patches
> exploring growing the number of memory slots a while ago, but it was
> prior to caching memory slot array misses and thefore had potentially
> poor performance.  Now that we do that, Avi seemed receptive to
> increasing the memory slot array to arbitrary lengths.  I think we
> still don't want to impose unnecessary kernel memory consumptions on
> guests not making use of this, so I present again a growable memory
> slot array.
> 
> A couple notes/questions; in the previous version we had a
> kvm_arch_flush_shadow() call when we increased the number of slots.
> I'm not sure if this is still necessary.  I had also made the x86
> specific slot_bitmap dynamically grow as well and switch between a
> direct bitmap and indirect pointer to a bitmap.  That may have
> contributed to needing the flush.  

I don't remember. Do you recall what was the argument back then?
(there must have been some).

> I haven't done that yet here
> because it seems like an unnecessary complication if we have a max
> on the order of 512 or 1024 entries.  A bit per slot isn't a lot of
> overhead.  If we want to go more, maybe we should make it switch.
> That leads to the final question, we need an upper bound since this
> does allow consumption of extra kernel memory, what should it be?  A
> PCI bus filled with assigned devices can theorically use up to 2048
> slots (32 devices * 8 functions * (6 BARs + ROM + possibly split
> MSI-X BAR)).  For this RFC, I don't change the max, just make it
> grow up to 32 user slots.  Untested on anything but x86 so far.
> Thanks,

Not sure. Some reasonable number based on current usage expectations?
(can be increased later if necessary).

