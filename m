Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752707Ab1FCOsN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 10:48:13 -0400
Received: from casper.infradead.org ([85.118.1.10]:35470 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956Ab1FCOsL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 10:48:11 -0400
Subject: Re: [BUG] rebuild_sched_domains considered dangerous
From: Peter Zijlstra <peterz@infradead.org>
To: Jesse Larrew <jlarrew@linux.vnet.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, nfont@austin.ibm.com
In-Reply-To: <4DCAB6B0.8020904@linux.vnet.ibm.com>
References: <1299639487.22236.256.camel@pasglop>
	 <1299665998.2308.2753.camel@twins>  <1299675674.2308.2924.camel@twins>
	 <1299766211.2308.4468.camel@twins>  <1303294056.8345.122.camel@twins>
	 <1303336869.2513.26.camel@pasglop>  <4DC85BFE.7060900@linux.vnet.ibm.com>
	 <1305036563.2914.80.camel@laptop>  <4DCAB6B0.8020904@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 03 Jun 2011 16:47:49 +0200
Message-ID: <1307112469.2353.3402.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-05-11 at 11:17 -0500, Jesse Larrew wrote:
> > I would really like to see both patch-sets together. Also, I'm not
> at
> > all convinced its a sane thing to do. Pretty much all NUMA aware
> > software I know of assumes that CPU<->NODE relations are static,
> > breaking that in kernel renders all existing software broken.
> > 
> 
> I suspect that's true. Then again, shouldn't it be the capabilities of
> the hardware that dictates what the software does, rather than the
> other way around? 

Wish that were true, we wouldn't be all constrained by all this legacy
software.. ;-)

Anyway, there's plenty of CPU<->NODE assumptions in the kernel as well,
fixing those will be 'interesting' at best, as for userspace, since its
a user-driven tool revamping the topology the user gets to keep the
pieces when he runs that while some NUMA aware proglet is running.
