Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758361Ab2ECTbe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 15:31:34 -0400
Received: from merlin.infradead.org ([205.233.59.134]:49382 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756011Ab2ECTbd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 15:31:33 -0400
Message-ID: <1336073474.6509.2.camel@twins>
Subject: Re: [PATCH 1/1] mlock: split the shmlock_user_lock spinlock into
 per user_struct spinlock
From: Peter Zijlstra <peterz@infradead.org>
To: rajman mekaco <rajman.mekaco@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Minchan Kim <minchan.kim@gmail.com>, Christoph Lameter <cl@gentwo.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Date: Thu, 03 May 2012 21:31:14 +0200
In-Reply-To: <1336066477-3964-1-git-send-email-rajman.mekaco@gmail.com>
References: <1336066477-3964-1-git-send-email-rajman.mekaco@gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-03 at 23:04 +0530, rajman mekaco wrote:
> The user_shm_lock and user_shm_unlock functions use a single global
> spinlock for protecting the user->locked_shm.

Are you very sure its only protecting user state? This changelog doesn't
convince me you've gone through everything and found it good.

> This is an overhead for multiple CPUs calling this code even if they
> are having different user_struct.
> 
> Remove the global shmlock_user_lock and introduce and use a new
> spinlock inside of the user_struct structure. 

While I don't immediately see anything wrong with it, I doubt its
useful. What workload run with enough users that this makes a difference
one way or another?


