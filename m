Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750992Ab0ELEac (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 00:30:32 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:62679 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732Ab0ELEaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 00:30:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=umJJeSANgDwssstmAe8+AHoeT666lR2eaeUhHankNMY8A+IcSnSjEkloWLx34ppOax
         dDY0+D2zipPUCypcvfTLMF7sYhFBfIXuqGNyz9+mKinRnwi/7XZ/O962mxc1cal1DdPw
         kS6d02eZIYeS7cAZBtrgyxU7MOCKhRcNw3TA4=
Date: Wed, 12 May 2010 12:34:20 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Greg KH <gregkh@suse.de>
Cc: CaT <cat@zip.com.au>,
       =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>,
       Yong Zhang <yong.zhang@windriver.com>, lkml@zip.com.au,
       mtosatti@redhat.com, kvm@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Avi Kivity <avi@redhat.com>
Subject: Re: 2.6.33.3: possible recursive locking detected
Message-ID: <20100512043420.GC5358@cr0.nay.redhat.com>
References: <20100504070334.GN2657@zip.com.au>
 <4BDFDCD1.70202@redhat.com>
 <20100505023220.GC20236@windriver.com>
 <h2p2375c9f91005041952k422e7701vf7e726fc5440e953@mail.gmail.com>
 <20100511113350.GW2657@zip.com.au>
 <20100511150320.GB14895@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100511150320.GB14895@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 11, 2010 at 08:03:20AM -0700, Greg KH wrote:
>On Tue, May 11, 2010 at 09:33:50PM +1000, CaT wrote:
>> On Wed, May 05, 2010 at 10:52:50AM +0800, Américo Wang wrote:
>> > On Wed, May 5, 2010 at 10:32 AM, Yong Zhang <yong.zhang@windriver.com> wrote:
>> > > On Tue, May 04, 2010 at 11:37:37AM +0300, Avi Kivity wrote:
>> > >> On 05/04/2010 10:03 AM, CaT wrote:
>> > >> >I'm currently running 2.6.33.3 in a KVM instance emulating a core2duo
>> > >> >on 1 cpu with virtio HDs running on top of a core2duo host running 2.6.33.3.
>> > >> >qemu-kvm version 0.12.3.
>> > >
>> > > Can you try commit 6992f5334995af474c2b58d010d08bc597f0f2fe in the latest
>> > > kernel?
>> > >
>> > 
>> > Hmm, 2.6.33 -stable has commit 846f99749ab68bbc7f75c74fec305de675b1a1bf?
>> > 
>> > Actually, these 3 commits fixed it:
>> > 
>> > 6992f5334995af474c2b58d010d08bc597f0f2fe sysfs: Use one lockdep class
>> > per sysfs ttribute.
>> > a2db6842873c8e5a70652f278d469128cb52db70 sysfs: Only take active
>> > references on attributes.
>> > e72ceb8ccac5f770b3e696e09bb673dca7024b20 sysfs: Remove sysfs_get/put_active_two
>> > 
>> > However, there are many other patches needed to amend these, so I think
>> > it's not suitable for -stable to include, perhaps a revert of
>> > 846f99749ab68bbc7f75c74fec305de675b1a1bf is better.
>> 
>> Slightly at a loss as to what to do, now. It's a virt instance so I can
>> apply patches at will but, well, clarity is good. :)
>
>Just ignore the lockdep warnings as they are bogus, or turn them off, or
>use .34-rc7, as they are resolved there.
>

How about reverting that patch for 2.6.33 stable tree?

Thanks.
