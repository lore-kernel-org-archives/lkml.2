Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754641Ab2LFX6w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 18:58:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2386 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751286Ab2LFX6v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 18:58:51 -0500
Date: Thu, 6 Dec 2012 21:58:48 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: kvm@vger.kernel.org, gleb@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 5/6] kvm: Re-introduce memslots->nmemslots
Message-ID: <20121206235848.GA30582@amt.cnet>
References: <20121203231912.3661.57179.stgit@bling.home>
 <20121203233936.3661.69261.stgit@bling.home>
 <20121205212629.GD20260@amt.cnet>
 <1354748573.3224.63.camel@bling.home>
 <20121206014507.GA9890@amt.cnet>
 <1354765897.3224.71.camel@bling.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354765897.3224.71.camel@bling.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 05, 2012 at 08:51:37PM -0700, Alex Williamson wrote:
> > > id_to_memslot seems like a good place to catch all the users since
> > > that's the only way to get a slot from a slot id after the array is
> > > sorted.  We need to check both is the slot in bounds (EINVAL), but also
> > > is it allocated (ENOENT).  id_to_memslot could both of these if we
> > > wanted to switch it to ERR_PTR.  Thanks,
> > > 
> > > Alex
> > 
> > There should never be a reference to a slot out of bounds by KVM itself
> > (BUG_ON). Only userspace can attempt a reference to such slot.
> 
> If I understand correctly, you're saying this last chunk is unique
> because kvm_get_dirty_log() is an internal interface and the test should
> be restricted to callers from userspace interfaces, namely
> kvm_vm_ioctl_get_dirty_log().  That sounds reasonable; book3s_pr seems
> to be the only caller that relies on kvm_get_dirty_log() validating the
> slot.  Thanks,
> 
> Alex

Yep - so you can move the check to such userspace interfaces, and bug on 
on WARN otherwise (in id_to_memslot).

Does that make sense??

