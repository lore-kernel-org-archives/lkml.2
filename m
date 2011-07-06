Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754537Ab1GFJZx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 05:25:53 -0400
Received: from aaar.vm.bytemark.co.uk ([80.68.92.230]:41584 "EHLO
	aaar.vm.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754399Ab1GFJZv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 05:25:51 -0400
From: Ian Campbell <ijc@hellion.org.uk>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Brian Gerst <brgerst@gmail.com>, Jan Beulich <JBeulich@novell.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>
In-Reply-To: <4E134E1E.6040304@zytor.com>
References: <20110705104742.GO17941@sun>  <4E134E1E.6040304@zytor.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 06 Jul 2011 10:25:38 +0100
Message-ID: <1309944338.634.162.camel@zakaz.uk.xensource.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 62.200.22.2
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: Re: [Q x86-64] on kernel_eflags
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-07-05 at 10:47 -0700, H. Peter Anvin wrote:
> On 07/05/2011 03:47 AM, Cyrill Gorcunov wrote:
> > 
> > Should not every cpu has own copy of kernel_eflags? Just
> > to be consistent in style? Or this would be space waisting
> > and an optimization is done here?
> > 
> 
> Not specific to this particular case, but in general: a shared variable
> that used often but rarely written to will automatically replicate
> itself in the caches of multiple processors.  This is the purpose of the
> read_mostly segment (writes are permitted but expected to be rare),
> which exists to make sure that a frequently written variable doesn't
> randomly end up in the cache line next to a read-mostly variable.

FWIW the variable in this particular case isn't actually marked as
__read_mostly...

Ian.
-- 
Ian Campbell

* Simunye is on a oc3->oc12
 simmy: bite me. :)
 daemon: okay :)

