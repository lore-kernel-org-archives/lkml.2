Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753437Ab0HZKJV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 06:09:21 -0400
Received: from casper.infradead.org ([85.118.1.10]:47617 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752035Ab0HZKJS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 06:09:18 -0400
Subject: Re: [PATCH] lglock: make lg_lock_global() actually lock globally
From: Peter Zijlstra <peterz@infradead.org>
To: Tejun Heo <tj@kernel.org>
Cc: Nick Piggin <npiggin@kernel.dk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Al Viro <viro@zeniv.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4C7638B7.9060306@kernel.org>
References: <20100825132815.108d8217@bike.lwn.net>
	 <AANLkTimbiEMM+uyYtU41qdCuK7uRavtPYdQyx4d_g3xw@mail.gmail.com>
	 <4C762BF9.5010305@kernel.org> <20100826094613.GA6411@amd>
	 <4C7638B7.9060306@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 26 Aug 2010 12:08:49 +0200
Message-ID: <1282817329.1975.486.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-08-26 at 11:49 +0200, Tejun Heo wrote:
> If there's a pressing need, doing stop_machine for
> onlining too is definitely an option. 

I would argue against that.. we should try and rid ourselves of
stopmachine, not add more dependencies on it. If you want to sync
against preempt_disable thingies synchronize_sched() is your friend.
