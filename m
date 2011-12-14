Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757662Ab1LNQzr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 11:55:47 -0500
Received: from merlin.infradead.org ([205.233.59.134]:37986 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755044Ab1LNQzo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 11:55:44 -0500
Message-ID: <1323881470.28489.51.camel@twins>
Subject: Re: [PATCH] jump-label: initialize jump-label subsystem somewhat
 later
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: David Daney <ddaney.cavm@gmail.com>
Cc: ralf@linux-mips.org, Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mips@linux-mips.org,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        linux-kernel@vger.kernel.org, Jason Baron <jbaron@redhat.com>,
        David Daney <david.daney@cavium.com>
In-Reply-To: <1323881315-23245-1-git-send-email-ddaney.cavm@gmail.com>
References: <1323881315-23245-1-git-send-email-ddaney.cavm@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 14 Dec 2011 17:51:10 +0100
Mime-Version: 1.0
X-Mailer: Evolution 3.2.1- 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-12-14 at 08:48 -0800, David Daney wrote:
> From: David Daney <david.daney@cavium.com>
> 
> commit 97ce2c88f9ad42e3c60a9beb9fca87abf3639faa breaks MIPS.
> 
> The jump-lable initialization does I-Cache flushing after modifying
> code.  On MIPS this is done by calling through the function pointer
> flush_icache_range().  This function pointer is initialized mm_init().
> 
> As things stand, we cannot be calling jump_label_init() until after
> mm_init() completes, so we move the call down to satisfy this
> constraint.

I'm fine as long as it stays before sched_init(), which it does. Jeremy
is this still early enough for you?

