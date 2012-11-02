Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762932Ab2KBRa3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 13:30:29 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:47451 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761470Ab2KBRa2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 13:30:28 -0400
Date: Fri, 2 Nov 2012 10:30:22 -0700
From: Tejun Heo <tj@kernel.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Ric Wheeler <rwheeler@redhat.com>,
        Petr Matousek <pmatouse@redhat.com>, Kay Sievers <kay@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: Re: setting up CDB filters in udev (was Re: [PATCH v2 0/3] block:
 add queue-private command filter, editable via sysfs)
Message-ID: <20121102173022.GA27843@mtj.dyndns.org>
References: <20121025180045.GL11442@htj.dyndns.org>
 <1657557410.1945557.1351190120407.JavaMail.root@redhat.com>
 <20121031212241.GZ2945@htj.dyndns.org>
 <5093DD5E.6030808@redhat.com>
 <20121102153530.483453c7@pyramind.ukuu.org.uk>
 <20121102164828.GA3823@mtj.dyndns.org>
 <20121102172145.184abfe3@pyramind.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121102172145.184abfe3@pyramind.ukuu.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, Alan.

On Fri, Nov 02, 2012 at 05:21:45PM +0000, Alan Cox wrote:
> That also means that a normal app running as superuser for some reason
> would set its user filter and any accidentally inherited descriptors will
> be less dangerous as the are today. It also means a CAP_SYS_RAWIO capable
> app can still use filters itself as good programming practise.
> 
> It effectively means you have to deliberately and intentionally set up an
> 'inherited' extra rights case.

The last part, I agree, but in general I think what you're describing
is way too elaborate for the problem at hand.  It's like adding
arbitrary range-filter for /dev/sdX which can be overridden by
userland.  You sure can find use case for such thing if you try hard
enough, but it's way over-engineered nonetheless.  I don't think we're
addressing huge range and number of use cases here and would much
prefer to keep it as simple as possible.

 * Devices are given standard filter matching the device class.  Any
   !CAP_SYS_RAWIO user can only issue commands allowed by the filter.

 * CAP_SYS_RAWIO can issue an ioctl to disable the filter all
   accessors of the fd and transfer it.

That should be enough, no?

Thanks.

-- 
tejun
