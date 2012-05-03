Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754360Ab2ECM3a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 08:29:30 -0400
Received: from merlin.infradead.org ([205.233.59.134]:56892 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754148Ab2ECM32 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 08:29:28 -0400
Message-ID: <1336048150.22523.17.camel@twins>
Subject: Re: [RFC] sched: make callers check lock contention for
 cond_resched_lock()
From: Peter Zijlstra <peterz@infradead.org>
To: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        kvm@vger.kernel.org, avi@redhat.com, mtosatti@redhat.com,
        yoshikawa.takuya@oss.ntt.co.jp
Date: Thu, 03 May 2012 14:29:10 +0200
In-Reply-To: <20120503212244.6abbfa8bc3f46a7f7a932bb7@gmail.com>
References: <20120503171244.2debdd80931ccf35f387c5fe@gmail.com>
	 <1336034127.13683.197.camel@twins>
	 <20120503212244.6abbfa8bc3f46a7f7a932bb7@gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-03 at 21:22 +0900, Takuya Yoshikawa wrote:
> Although the real use case is out of this RFC patch, we are now discussing
> a case in which we may hold a spin_lock for long time, ms order, depending
> on workload;  and in that case, other threads -- VCPU threads -- should be
> given higher priority for that problematic lock. 

Firstly, if you can hold a lock that long, it shouldn't be a spinlock,
secondly why isn't TIF_RESCHED being set if its running that long? That
should still make cond_resched_lock() break.
