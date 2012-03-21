Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757168Ab2CUPO6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 11:14:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2056 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756172Ab2CUPO4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 11:14:56 -0400
Date: Wed, 21 Mar 2012 16:14:49 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Keith Packard <keithp@keithp.com>
Cc: dri-devel@lists.freedesktop.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Airlie <airlied@linux.ie>,
        rjw@sisk.pl, davej@redhat.com
Subject: Re: hibernate random memory corruption, workaround i915.modeset=0
Message-ID: <20120321151448.GA7924@redhat.com>
References: <20120227124243.GG4104@redhat.com>
 <20120319145349.GG6169@redhat.com>
 <86r4wobj6v.fsf@sumi.keithp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86r4wobj6v.fsf@sumi.keithp.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 19, 2012 at 10:21:28AM -0700, Keith Packard wrote:
> <#part sign=pgpmime>
> On Mon, 19 Mar 2012 15:53:54 +0100, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> 
> > Keith, is there a chance that this bug can be fixed by i915 team?
> 
> Yes, I'm working on figuring out how to actually reproduce this and then
> work on a few work-arounds.

This must be hardware dependent then, yesterday and today I tried to
reproduce on Lenovo T60 with:

00:02.0 VGA compatible controller [0300]: Intel Corporation Mobile 945GM/GMS, 943/940GML Express Integrated Graphics Controller [8086:27a2] (rev 03)

and there is no sign of corruption, I double checked if slab poisoning
is enabled.

> > If not, can we disable hibernate on i915 with modeset=1 and add
> > module option, which enable it for those who want to risk?
> 
> I'd love to know if disabling modeset on just the booting kernel helps;
> leaving the resuming kernel with modeset=1. I haven't been able to
> reproduce this locally yet to test this theory though.

On Lenovo T500 with:

00:02.1 Display controller [0380]: Intel Corporation Mobile 4 Series Chipset Integrated Graphics Controller [8086:2a43] (rev 07)

that is the case. Script attached on previous email trigger corruption
with modeset=1 (on various older and newer kernels) in less then 20
iterations. There is no corruption after 100 iterations if
i915.modeset=0 parameter is used. Some users on RH bugzilla confirmed
that workaround as well.

If you want list of more i915 adapters where the problem happens, I can
check in our bugzilla and provide it.

Thanks
Stanislaw 
