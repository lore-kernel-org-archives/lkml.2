Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754003Ab2JOREM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 13:04:12 -0400
Received: from casper.infradead.org ([85.118.1.10]:41139 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753912Ab2JOREK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 13:04:10 -0400
Subject: Re: [RFC PATCH] posix timers: allocate timer id per task
From: Peter Zijlstra <peterz@infradead.org>
To: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: mingo@redhat.com, tglx@linutronix.de, linux-kernel@vger.kernel.org,
        devel@openvz.org
In-Reply-To: <20121015161559.7806.72762.stgit@localhost.localdomain>
References: <20121015161559.7806.72762.stgit@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 15 Oct 2012 19:04:05 +0200
Message-ID: <1350320645.2336.38.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-10-15 at 20:17 +0400, Stanislav Kinsbursky wrote:
> This patch is required CRIU project (www.criu.org).
> To migrate processes with posix timers we have to make sure, that we can
> restore posix timer with proper id.
> Currently, this is not true, because timer ids are allocated globally.
> So, this is precursor patch and it's purpose is make posix timer id to be
> allocated per task.
> 
> Patch replaces global idr with global hash table for posix timers and
> makes timer ids unique not globally, but per task. Next free timer id is type
> of integer and stored on signal struct (posix_timer_id). If free timer id
> reaches negative value on timer creation, it will be dropped to zero and
> -EAGAIN will be returned to user.
> Hash table is size of page (4KB).
> Key is constructed as follows:
> key = hash_ptr(current->signal) ^ hash_32(posix_timer_id); 

but but but.. isn't this what namespaces were invented for to solve? Why
not use the regular namespace infrastructure?

