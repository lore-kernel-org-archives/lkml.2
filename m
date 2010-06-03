Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755805Ab0FCOun (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 10:50:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56701 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755404Ab0FCOum (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 10:50:42 -0400
Date: Thu, 3 Jun 2010 16:48:10 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ben Blum <bblum@andrew.cmu.edu>
Cc: Paul Menage <menage@google.com>, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org, akpm@linux-foundation.org,
       ebiederm@xmission.com, lizf@cn.fujitsu.com, matthltc@us.ibm.com
Subject: Re: [RFC] [PATCH 2/2] cgroups: make procs file writable
Message-ID: <20100603144810.GB6284@redhat.com>
References: <20100530013303.GC762@ghc01.ghc.andrew.cmu.edu> <20100531175242.GA14691@redhat.com> <20100531180446.GA16249@redhat.com> <AANLkTimcrX0TjzDMNJdubR92pAO4IPATbVpyvvVt0qIV@mail.gmail.com> <20100602140659.GA5324@redhat.com> <AANLkTin-T6ij3xf0ceGoCamwcoayxyf0GdAKY6yXDMVl@mail.gmail.com> <20100602202048.GB28663@redhat.com> <AANLkTimrJFiidM8BlUNvmzfapUAv8369R9PYnTscasEf@mail.gmail.com> <20100602205855.GA30039@redhat.com> <20100603044001.GA21006@ghc02.ghc.andrew.cmu.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100603044001.GA21006@ghc02.ghc.andrew.cmu.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/03, Ben Blum wrote:
>
> On Wed, Jun 02, 2010 at 10:58:55PM +0200, Oleg Nesterov wrote:
> > Hmm. The usage of ->thread_group in ->can_attach() methods doesn't
> > look safe to me... but currently bool threadgroup is always false.
>
> I recall putting a rcu_read_lock() around that part and being assured
> that made it safe. But I don't remember the details. Maybe taking
> tasklist_lock is necessary?

rcu_read_lock() is not enough, see another email I sent.

Once again.

	rcu_read_lock()
	list_for_each_rcu(tsk->thread_group)

assumes that at least tsk->thread_group->next can't point to nowhere,
this is not true. This memory can go away _before_ we take rcu lock.

Oleg.

