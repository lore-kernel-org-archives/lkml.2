Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756584Ab1IGUXi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 16:23:38 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:47328 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754420Ab1IGUXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 16:23:36 -0400
Subject: Re: [PATCH] random: add blocking facility to urandom
From: Sasha Levin <levinsasha928@gmail.com>
To: Steve Grubb <sgrubb@redhat.com>
Cc: "Ted Ts'o" <tytso@mit.edu>, Jarod Wilson <jarod@redhat.com>,
        linux-crypto@vger.kernel.org, Matt Mackall <mpm@selenic.com>,
        Neil Horman <nhorman@redhat.com>, Herbert Xu <herbert.xu@redhat.com>,
        Stephan Mueller <stephan.mueller@atsec.com>,
        lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <201109071602.24519.sgrubb@redhat.com>
References: <1314974248-1511-1-git-send-email-jarod@redhat.com>
	 <4E67B75B.8010500@redhat.com> <20110907192737.GD20571@thunk.org>
	 <201109071602.24519.sgrubb@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Date: Wed, 07 Sep 2011 23:23:13 +0300
Message-ID: <1315426993.3576.38.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-09-07 at 16:02 -0400, Steve Grubb wrote:
> On Wednesday, September 07, 2011 03:27:37 PM Ted Ts'o wrote:
> > On Wed, Sep 07, 2011 at 02:26:35PM -0400, Jarod Wilson wrote:
> > > We're looking for a generic solution here that doesn't require
> > > re-educating every single piece of userspace. And anything done in
> > > userspace is going to be full of possible holes -- there needs to be
> > > something in place that actually *enforces* the policy, and
> > > centralized accounting/tracking, lest you wind up with multiple
> > > processes racing to grab the entropy.
> > 
> > Yeah, but there are userspace programs that depend on urandom not
> > blocking... so your proposed change would break them.
> 
> The only time this kicks in is when a system is under attack. If you have set this and 
> the system is running as normal, you will never notice it even there. Almost all uses 
> of urandom grab 4 bytes and seed openssl or libgcrypt or nss. It then uses those 
> libraries. There are the odd cases where something uses urandom to generate a key or 
> otherwise grab a chunk of bytes, but these are still small reads in the scheme of 
> things. Can you think of any legitimate use of urandom that grabs 100K or 1M from 
> urandom? Even those numbers still won't hit the sysctl on a normally function system.
> 

As far as I remember, several wipe utilities are using /dev/urandom to
overwrite disks (possibly several times).

Something similar probably happens for getting junk on disks before
creating an encrypted filesystem on top of them.

-- 

Sasha.

