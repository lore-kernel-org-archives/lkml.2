Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758108Ab1IHHVr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 03:21:47 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:41647 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758050Ab1IHHVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 03:21:45 -0400
Subject: Re: [PATCH] random: add blocking facility to urandom
From: Sasha Levin <levinsasha928@gmail.com>
To: Steve Grubb <sgrubb@redhat.com>
Cc: Jarod Wilson <jarod@redhat.com>, "Ted Ts'o" <tytso@mit.edu>,
        linux-crypto@vger.kernel.org, Matt Mackall <mpm@selenic.com>,
        Neil Horman <nhorman@redhat.com>, Herbert Xu <herbert.xu@redhat.com>,
        Stephan Mueller <stephan.mueller@atsec.com>,
        lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <201109071743.16811.sgrubb@redhat.com>
References: <1314974248-1511-1-git-send-email-jarod@redhat.com>
	 <1315429827.3576.61.camel@lappy> <4E67E396.702@redhat.com>
	 <201109071743.16811.sgrubb@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Date: Thu, 08 Sep 2011 10:21:23 +0300
Message-ID: <1315466483.3584.7.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-09-07 at 17:43 -0400, Steve Grubb wrote:
> On Wednesday, September 07, 2011 05:35:18 PM Jarod Wilson wrote:
> > Another proposal that has been kicked around: a 3rd random chardev, 
> > which implements this functionality, leaving urandom unscathed. Some 
> > udev magic or a driver param could move/disable/whatever urandom and put 
> > this alternate device in its place. Ultimately, identical behavior, but 
> > the true urandom doesn't get altered at all.
> 
> Right, and that's what I was trying to say is that if we do all that and switch out 
> urandom with something new that does what we need, what's the difference in just 
> patching the behavior into urandom and calling it a day? Its simpler, less fragile, 
> admins won't make mistakes setting up the wrong one in a chroot, already has the 
> FIPS-140 dressing, and is auditable.

Whats the difference between changing the behavior of a well defined
interface (/dev/urandom) which may cause userspace applications to fail,
in opposed to a non-intrusive usermode CUSE driver which can do exactly
what you need (and more - if more is required in the future)? None, none
at all...

CUSE supports kernel auditing, admins making mistakes is hardly the
kernels' problem (unless it makes it easy for them to do mistakes) and
code moved into the kernel doesn't suddenly become more stable and
simpler.

-- 

Sasha.

