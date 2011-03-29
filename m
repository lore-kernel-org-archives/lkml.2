Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751634Ab1C2Ht5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 03:49:57 -0400
Received: from mga09.intel.com ([134.134.136.24]:17501 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750977Ab1C2Ht4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 03:49:56 -0400
Message-Id: <b9dded$ififhr@orsmga002.jf.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,260,1299484800"; 
   d="scan'208";a="620314171"
Date: Tue, 29 Mar 2011 08:49:52 +0100
To: Pekka Enberg <penberg@kernel.org>
Subject: Re: [git pull] drm fixes for -rc1
Cc: Dave Airlie <airlied@linux.ie>, torvalds@linux-foundation.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
References: <alpine.DEB.2.00.1103241132001.12023@skynet.skynet.ie> <AANLkTi=g27c3_Meu-YymXNPSD+isonN7CuWg78F9ZA+j@mail.gmail.com> <AANLkTimAwNytQaykaMf33DUXcKOyGVWUetOAb_nf236t@mail.gmail.com> <849307$c6tdto@azsmga001.ch.intel.com> <AANLkTi=VqkYjdiDLJvM-OfmBSGx-EkRkt=4XCDEnvZsU@mail.gmail.com>
From: Chris Wilson <chris@chris-wilson.co.uk>
In-Reply-To: <AANLkTi=VqkYjdiDLJvM-OfmBSGx-EkRkt=4XCDEnvZsU@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Mar 2011 10:11:21 +0300, Pekka Enberg <penberg@kernel.org> wrote:
> On Mon, Mar 28, 2011 at 10:09 PM, Chris Wilson <chris@chris-wilson.co.uk> wrote:
> Let me know if there's a patch/git tree to test. The flicker is
> extremely annoying and I boot the machine often because it's my main
> kernel development laptop.

I will let you know as soon as I have something ready for testing.
 
> > That's an old userspace bug, which so far no one has been able to
> > reproduce on the upstream ddx.
> 
> Is it harmless? Why is the kernel complaining about it?

Being pragmatic, so that I can tell one EINVAL apart from another. And
it's only mostly harmless. Userspace is attempting to write to/read from
a buffer it has marked as being no longer required, so some rendering is
going amiss. And it does not rule out the possibility that at some point
it will catch the error later and result in a SIGBUS being sent to the
application (probably X).

However since it is not a kernel error nor is it fatal, that and a lot of
similar messages can be demoted to debug.
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
