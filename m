Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753489Ab2A3Pto (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 10:49:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:5956 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753196Ab2A3Ptn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 10:49:43 -0500
Date: Mon, 30 Jan 2012 10:49:35 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Phillip Susi <psusi@ubuntu.com>
Cc: Maxim Patlasov <maxim.patlasov@gmail.com>, joe@perches.com,
        kzak@redhat.com, linux-kernel@vger.kernel.org, jaxboe@fusionio.com
Subject: Re: [PATCH 1/2] Add partition resize function to BLKPG ioctl
Message-ID: <20120130154935.GC30245@redhat.com>
References: <CA+X1aCQRpJ_NwJBSBp+vDN37p+oipJNz=6T5LdJdqzxTiSWWWA@mail.gmail.com>
 <4EFD012D.7040602@cfl.rr.com>
 <20120126190114.GG1891@redhat.com>
 <4F21B91E.90106@ubuntu.com>
 <20120126210456.GC11297@redhat.com>
 <4F21CA16.3020002@ubuntu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F21CA16.3020002@ubuntu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 26, 2012 at 04:48:06PM -0500, Phillip Susi wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> On 1/26/2012 4:04 PM, Vivek Goyal wrote:
> >> Another idea that I had but have not yet checked to see if it is
> >>  actually feasible is to copy the struct genhd, change the size
> >> of the copy, and replace the existing one since updating the
> >> pointer will be atomic.
> > 
> > You will run into issues if somebody has a pointer stored to 
> > genhd.
> 
> They are already kept in an RCU list which has the same problem.

Yes, using rcu is one option.

> Doesn't that deal with it by using reference counters, so the reader
> can keep and use the pointer to the old structure just fine, and it
> will be cleaned up when they release the reference.

Then reader needs to take reference count before every read and that
makes it heavy weight solution for reader.

Sequence counter keeps it lightweight for reader in fast path.

> 
> > I think simpler thing would be to stick with sequence counter 
> > approach which keeps read side lockless. We can fix other writers 
> > of nr_sects over a period of time. If nobody has complained so
> > far, that means we don't run into issues frequently and it is not a
> > huge concern.
> 
> So you think the patch is fine the way it is?

If you can fix other use cases now, it would be good. Otherwise, I think
we can leave a big fat comment in the code and if somebody runs into
issues, we can go fix the individiual cases then.

As we are not introducing any new races, I will not be too concerned
about that.

Thanks
Vivek
