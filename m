Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753768Ab1LCRir (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Dec 2011 12:38:47 -0500
Received: from smp.if.uj.edu.pl ([149.156.82.206]:43268 "EHLO smp.if.uj.edu.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753329Ab1LCRio (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Dec 2011 12:38:44 -0500
Date: Sat, 3 Dec 2011 18:38:35 +0100
From: Witold Baryluk <baryluk@smp.if.uj.edu.pl>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Jerome Marchand <jmarchan@redhat.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        Nitin Gupta <ngupta@vflare.org>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] Staging: zram: Turn lockdep off during
 zram_init_device()
Message-ID: <20111203173834.GM9190@smp.if.uj.edu.pl>
References: <4ED62C38.1020106@redhat.com>
 <1322661544.2921.274.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1322661544.2921.274.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11-30 14:59, Peter Zijlstra wrote:
> On Wed, 2011-11-30 at 14:14 +0100, Jerome Marchand wrote:
> > zram->init_lock can be hold over an allocation that may try to reclaim
> > memory in zram_init_device(). The same lock can later be taken from a
> > reclaim context in zram_make_request(), thus triggering a lockdep
> > warning. However, memory can not be reclaimed to an uninitialized zram
> > device. Therefore, this warning is a false positive.
> > To prevent the warning to occur, we turn lockdep off during while the
> > device is initialized.
> 
> fuck no! why do you even remotely consider this a sane thing to do?
> 
> There's tons of lockdep annotations, try one of those. If you have, your
> changelog utterly fails to explain why non of those are suitable and how
> your problem is special.
> 

I must agree. Propsed patch is a hack, and actually can make more trouble
to other subsystems. It is better to live with warning than perform
temporary lockdep off/on.

-- 
Witold Baryluk
