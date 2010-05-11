Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754568Ab0EKLeI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 07:34:08 -0400
Received: from nessie.weebeastie.net ([220.233.7.36]:56641 "EHLO
	bunyip.billabong.weebeastie.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754287Ab0EKLeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 07:34:05 -0400
Date: Tue, 11 May 2010 21:33:50 +1000
From: CaT <cat@zip.com.au>
To: =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: Yong Zhang <yong.zhang@windriver.com>, lkml@zip.com.au,
       mtosatti@redhat.com, kvm@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Avi Kivity <avi@redhat.com>, Greg KH <gregkh@suse.de>
Subject: Re: 2.6.33.3: possible recursive locking detected
Message-ID: <20100511113350.GW2657@zip.com.au>
References: <20100504070334.GN2657@zip.com.au> <4BDFDCD1.70202@redhat.com> <20100505023220.GC20236@windriver.com> <h2p2375c9f91005041952k422e7701vf7e726fc5440e953@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <h2p2375c9f91005041952k422e7701vf7e726fc5440e953@mail.gmail.com>
Organisation: Furball Inc.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 05, 2010 at 10:52:50AM +0800, Américo Wang wrote:
> On Wed, May 5, 2010 at 10:32 AM, Yong Zhang <yong.zhang@windriver.com> wrote:
> > On Tue, May 04, 2010 at 11:37:37AM +0300, Avi Kivity wrote:
> >> On 05/04/2010 10:03 AM, CaT wrote:
> >> >I'm currently running 2.6.33.3 in a KVM instance emulating a core2duo
> >> >on 1 cpu with virtio HDs running on top of a core2duo host running 2.6.33.3.
> >> >qemu-kvm version 0.12.3.
> >
> > Can you try commit 6992f5334995af474c2b58d010d08bc597f0f2fe in the latest
> > kernel?
> >
> 
> Hmm, 2.6.33 -stable has commit 846f99749ab68bbc7f75c74fec305de675b1a1bf?
> 
> Actually, these 3 commits fixed it:
> 
> 6992f5334995af474c2b58d010d08bc597f0f2fe sysfs: Use one lockdep class
> per sysfs ttribute.
> a2db6842873c8e5a70652f278d469128cb52db70 sysfs: Only take active
> references on attributes.
> e72ceb8ccac5f770b3e696e09bb673dca7024b20 sysfs: Remove sysfs_get/put_active_two
> 
> However, there are many other patches needed to amend these, so I think
> it's not suitable for -stable to include, perhaps a revert of
> 846f99749ab68bbc7f75c74fec305de675b1a1bf is better.

Slightly at a loss as to what to do, now. It's a virt instance so I can
apply patches at will but, well, clarity is good. :)

-- 
  "A search of his car uncovered pornography, a homemade sex aid, women's 
  stockings and a Jack Russell terrier."
    - http://www.news.com.au/story/0%2C27574%2C24675808-421%2C00.html
