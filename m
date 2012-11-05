Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754689Ab2KES0O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 13:26:14 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:61929 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183Ab2KES0M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 13:26:12 -0500
Date: Mon, 5 Nov 2012 10:26:08 -0800
From: Tejun Heo <tj@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Ric Wheeler <rwheeler@redhat.com>, Petr Matousek <pmatouse@redhat.com>,
        Kay Sievers <kay@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        linux-kernel@vger.kernel.org,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: Re: setting up CDB filters in udev (was Re: [PATCH v2 0/3] block:
 add queue-private command filter, editable via sysfs)
Message-ID: <20121105182608.GF19354@mtj.dyndns.org>
References: <20121025180045.GL11442@htj.dyndns.org>
 <1657557410.1945557.1351190120407.JavaMail.root@redhat.com>
 <20121031212241.GZ2945@htj.dyndns.org>
 <5093DD5E.6030808@redhat.com>
 <20121102165123.GB3823@mtj.dyndns.org>
 <509407B7.3030904@redhat.com>
 <20121102175350.GB27843@mtj.dyndns.org>
 <50951A0E.9010103@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50951A0E.9010103@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, Paolo.

On Sat, Nov 03, 2012 at 02:20:14PM +0100, Paolo Bonzini wrote:
> As to implementing the ioctl, it's all but trivial.  For one thing, you
> have to make the block device ioctl op take a "struct file".  I have
> been asking Al Viro about it for 6 months and I haven't got any answer yet.

I don't think that really matters.  If necessary, just change it.

> Second, getting a security-sensitive ioctl right is hard, as you
> demonstrated yourself in this thread by proposing a gapingly insecure
> approach.  Adding a little bit of customization to the current solution
> may be but a local optimum, but you cannot really get it wrong.

Eh?  Sure, I was in "who cares about SG_IO?" area a bit but that has
nothing to do with the interface being an ioctl.  It's a binary switch
ioctl, it's not too difficult to get right.

> Because _this_ is the simplest possible.

I guess we'll have to agree to disagree.  This is way more complex.
You need to review what's going on with the userland tools and inspect
weird sysfs files to actually know what the system policy is.

> I proposed a way to implement the ultimately flexible solution (BPF) and
> you shot it down because it was too complex.  Alan is showing you with
> multiple examples of why the flexibility would be useful (perhaps nobody
> would use it, but the use cases _are_ there), and you are mostly
> ignoring them.

The only valid use case was using proprietary commands during CD
burning.  At this point, that's a really really minor use case IMHO.
I think adding full BPF filtering on SG_IO for that is rather silly.

Thanks.

-- 
tejun
