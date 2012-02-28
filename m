Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932626Ab2B1KDk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 05:03:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6378 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755104Ab2B1KDi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 05:03:38 -0500
Message-ID: <4F4CA66F.8090109@redhat.com>
Date: Tue, 28 Feb 2012 12:03:27 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>, mtosatti@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH 0/4] KVM: srcu-less dirty logging
References: <20120223203300.241510a6.yoshikawa.takuya@oss.ntt.co.jp> <1330003524.11248.11.camel@twins>
In-Reply-To: <1330003524.11248.11.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/23/2012 03:25 PM, Peter Zijlstra wrote:
> On Thu, 2012-02-23 at 20:33 +0900, Takuya Yoshikawa wrote:
> > - Stop allocating extra dirty bitmap buffer area
> > 
> >   According to Peter, mmu_notifier has become preemptible.  If we can
> >   change mmu_lock from spin_lock to mutex_lock, as Avi said before, this
> >   would be staightforward because we can use __put_user() right after
> >   xchg() with the mmu_lock held 
>
> So the 'only' thing to consider is running the end result with lockdep
> enabled since the mmu locks are rather deep in the nesting tree its very
> easy to accidentally cause inversions.

There will be an inversion for sure, if __put_user() faults and triggers
an mmu notifier (perhaps directly, perhaps through an allocation that
triggers a swap).

-- 
error compiling committee.c: too many arguments to function

