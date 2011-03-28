Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754641Ab1C1OpD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 10:45:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34019 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754561Ab1C1OpB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 10:45:01 -0400
Date: Mon, 28 Mar 2011 15:36:02 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: __lock_task_sighand() and RCU
Message-ID: <20110328133602.GA8612@redhat.com>
References: <20110328085654.26a75db6@mfleming-mobl1.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110328085654.26a75db6@mfleming-mobl1.ger.corp.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matt,

On 03/28, Matt Fleming wrote:
>
> I've been reading __lock_task_sighand() and I can't quite wrap my head
> around what the rcu_read_lock()/rcu_read_unlock() is protecting in
> there.

It protects ->sighand.

> Initially I assumed that it was protecting the 'tsk' argument,

No. the caller must have a reference.

> Then I wondered if it was protecting the sighand from being freed from
> under us while we're trying to lock it.

Yes,

> But sighands aren't freed via
> rcu,

it is ;)

> it's just a simple refcnt and kmem_cache_free()

Yes, but please note that sighand_cachep was created with
SLAB_DESTROY_BY_RCU.

Oleg.

