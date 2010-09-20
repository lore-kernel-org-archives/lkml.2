Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932133Ab0ITTfe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 15:35:34 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53693 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932067Ab0ITTfc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 15:35:32 -0400
Date: Mon, 20 Sep 2010 12:31:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: linux-kernel@vger.kernel.org,
        "Jean Delvare (PC drivers, core)" <khali@linux-fr.org>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        Roland Dreier <rolandd@cisco.com>, Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>,
        Steve Wise <swise@chelsio.com>, Neil Brown <neilb@suse.de>,
        Paul Mackerras <paulus@samba.org>, linux-i2c@vger.kernel.org,
        linux-rdma@vger.kernel.org, dm-devel@redhat.com,
        linux-raid@vger.kernel.org, linux-ppp@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: idr_get_new_exact ?
Message-Id: <20100920123140.f524de79.akpm@linux-foundation.org>
In-Reply-To: <AANLkTi=ZLupVyFR0e2v-TLpeNWdw1bVMZUAhgyxLJ7OV@mail.gmail.com>
References: <AANLkTi=ZLupVyFR0e2v-TLpeNWdw1bVMZUAhgyxLJ7OV@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Sep 2010 16:11:31 +0200
Ohad Ben-Cohen <ohad@wizery.com> wrote:

> Occasionally, drivers care about the value that idr associates with
> their pointers.
> 
> Today we have idr_get_new_above() which allocates a new idr entry
> above or equal to a given starting id, but sometimes drivers need to
> force an exact value.
> 
> To overcome this small API gap, drivers are wrapping idr_get_new_above
> and then either BUG_ON() or just call idr_remove() and returns -EBUSY
> when idr allocates them an id which is different than their requested
> value.
> 
> There are only a handful of users who need this (see below. especially
> note the i2c comment :), but it might be nice to have such an API (a
> bit less of code, and a bit less error prone).
> 
> Would something like the below be desirable/acceptable ?

It seems OK to me - it's an improvement over what we have now.

> (untested. and i just picked the simplest and straight-forward way to
> implement this; obviously it's not optimal since there's no reason to
> even allocate an id if we know it's not the id we're looking for. but
> it's enough to get the idea, it's not a hot path, and it's what
> drivers are doing today)

Sure, we can speed it up later if that appears to be necessary.

