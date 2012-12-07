Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932512Ab2LGAHK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 19:07:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50824 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932263Ab2LGAHI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 19:07:08 -0500
Message-ID: <1354838827.3124.1.camel@ul30vt.home>
Subject: Re: [RFC PATCH 5/6] kvm: Re-introduce memslots->nmemslots
From: Alex Williamson <alex.williamson@redhat.com>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: kvm@vger.kernel.org, gleb@redhat.com, linux-kernel@vger.kernel.org
Date: Thu, 06 Dec 2012 17:07:07 -0700
In-Reply-To: <20121206235949.GA30775@amt.cnet>
References: <20121203231912.3661.57179.stgit@bling.home>
	 <20121203233936.3661.69261.stgit@bling.home>
	 <20121205212629.GD20260@amt.cnet> <1354748573.3224.63.camel@bling.home>
	 <20121206014507.GA9890@amt.cnet> <1354765897.3224.71.camel@bling.home>
	 <20121206235848.GA30582@amt.cnet> <20121206235949.GA30775@amt.cnet>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-12-06 at 21:59 -0200, Marcelo Tosatti wrote:
> On Thu, Dec 06, 2012 at 09:58:48PM -0200, Marcelo Tosatti wrote:
> > On Wed, Dec 05, 2012 at 08:51:37PM -0700, Alex Williamson wrote:
> > > > > id_to_memslot seems like a good place to catch all the users since
> > > > > that's the only way to get a slot from a slot id after the array is
> > > > > sorted.  We need to check both is the slot in bounds (EINVAL), but also
> > > > > is it allocated (ENOENT).  id_to_memslot could both of these if we
> > > > > wanted to switch it to ERR_PTR.  Thanks,
> > > > > 
> > > > > Alex
> > > > 
> > > > There should never be a reference to a slot out of bounds by KVM itself
> > > > (BUG_ON). Only userspace can attempt a reference to such slot.
> > > 
> > > If I understand correctly, you're saying this last chunk is unique
> > > because kvm_get_dirty_log() is an internal interface and the test should
> > > be restricted to callers from userspace interfaces, namely
> > > kvm_vm_ioctl_get_dirty_log().  That sounds reasonable; book3s_pr seems
> > > to be the only caller that relies on kvm_get_dirty_log() validating the
> > > slot.  Thanks,
> > > 
> > > Alex
> > 
> > Yep - so you can move the check to such userspace interfaces, and bug on 
> > on WARN otherwise (in id_to_memslot).
> 
> WARN_ON. The point is, if its not a valid condition, it should be
> explicitly so.
> 
> > Does that make sense??

Yep, I'll add that if we decide to go that route.  This patch isn't
necessary with the series I just posted since the array is still static.
Thanks,

Alex


