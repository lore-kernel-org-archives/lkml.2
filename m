Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751605Ab1GTKps (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 06:45:48 -0400
Received: from casper.infradead.org ([85.118.1.10]:54376 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751536Ab1GTKpr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 06:45:47 -0400
Subject: Re: [regression] 3.0-rc boot failure -- bisected to cd4ea6ae3982
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Anton Blanchard <anton@samba.org>
Cc: mahesh@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, mingo@elte.hu, benh@kernel.crashing.org,
        torvalds@linux-foundation.org
In-Reply-To: <20110720201436.19e9689a@kryten>
References: <20110707102107.GA16666@in.ibm.com>
	 <1310036375.3282.509.camel@twins> <20110714103418.7ef25b68@kryten>
	 <20110714143521.5fe4fab6@kryten> <1310649379.2586.273.camel@twins>
	 <20110715104547.29c3c509@kryten> <1311024956.2309.22.camel@laptop>
	 <20110719144451.79bc69ab@kryten> <1311070894.13765.180.camel@twins>
	 <20110720201436.19e9689a@kryten>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 20 Jul 2011 12:45:08 +0200
Message-ID: <1311158708.5345.12.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-07-20 at 20:14 +1000, Anton Blanchard wrote:

> > That looks very strange indeed.. up to node 23 there is the normal
> > symmetric matrix with all the trace elements on 10 (as we would expect
> > for local access), and some 4x4 sub-matrix stacked around the trace
> > with 20, suggesting a single hop distance, and the rest on 40 being
> > out-there.
> 
> I retested with the latest version of numactl, and get correct results.

One less thing to worry about ;-)

> I worked out why the patches don't boot, we weren't allocating any
> space for the cpumask and ran off the end of the allocation.

Gah! that's not the first time I made that particular mistake :/

> Should we also use cpumask_copy instead of open coding it? I added that
> too.

Probably, I looked for cpumask_assign() and on failing to find that used
the direct assignment.

So with that fix the patch makes the machine happy again?

Thanks!
