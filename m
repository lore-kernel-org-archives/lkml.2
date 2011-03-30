Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755874Ab1C3Lwf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 07:52:35 -0400
Received: from casper.infradead.org ([85.118.1.10]:54312 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754852Ab1C3Lwe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 07:52:34 -0400
Subject: Re: [PATCH 2/2] mutex: Apply adaptive spinning on mutex_trylock()
From: Peter Zijlstra <peterz@infradead.org>
To: Chris Mason <chris.mason@oracle.com>
Cc: Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
In-Reply-To: <1301485262-sup-5247@think>
References: <20110323153727.GB12003@htj.dyndns.org>
	 <20110324094119.GD12038@htj.dyndns.org>
	 <20110324094151.GE12038@htj.dyndns.org>
	 <20110325101238.GC1409@htj.dyndns.org>
	 <20110329163702.GE29865@htj.dyndns.org>  <1301485262-sup-5247@think>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 30 Mar 2011 13:52:04 +0200
Message-ID: <1301485924.4859.181.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-03-30 at 07:46 -0400, Chris Mason wrote:
> 
> In this case, the only thing we're really missing is a way to mutex_lock
> without the cond_resched() 

So you're trying to explicitly avoid a voluntary preemption point? Seems
like a bad idea, normally people add those :-)
