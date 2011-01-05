Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751404Ab1AEPSL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 10:18:11 -0500
Received: from casper.infradead.org ([85.118.1.10]:37104 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231Ab1AEPSJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 10:18:09 -0500
Subject: Re: cgroup scheduling: Adding kthreadd to a non-RT cgroup can
 deadlock the kernel
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Nelson Elhage <nelhage@ksplice.com>
Cc: Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <AANLkTi=FC27TTngERgbS95Z29CYBqLGxR4Uuw9fSTVuO@mail.gmail.com>
References: <20110105045447.GN23414@ksplice.com>
	 <1294220650.2016.197.camel@laptop>
	 <AANLkTi=FC27TTngERgbS95Z29CYBqLGxR4Uuw9fSTVuO@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 05 Jan 2011 16:18:30 +0100
Message-ID: <1294240710.2016.264.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-01-05 at 10:02 -0500, Nelson Elhage wrote:
> Ok. I bothered reporting this here since the kernel /does/ try to prevent you
> from shooting yourself in the foot in related ways, by moving existing
> SCHED_FIFO tasks into a cgroup without any RT runtime, so I figured it might
> make sense to add a check here. libcgroup, for example, will try to move all
> processes into a default cgroup, ignoring errors, and relies on the kernel to
> prevent it from shooting itself in the foot.
> 
> It sounds like you consider that behavior a bug, though, so I'll go report this
> bug there.

Right, so we try to catch obvious cases, but its near impossible to
catch all cases.

And its not only the scheduler controller, I bet you can get into
trouble with some of the other controllers as well.
