Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753462Ab0HYUB5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 16:01:57 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35759 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752469Ab0HYUBz convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 16:01:55 -0400
MIME-Version: 1.0
In-Reply-To: <20100825132815.108d8217@bike.lwn.net>
References: <20100825132815.108d8217@bike.lwn.net>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 25 Aug 2010 13:00:59 -0700
Message-ID: <AANLkTimbiEMM+uyYtU41qdCuK7uRavtPYdQyx4d_g3xw@mail.gmail.com>
Subject: Re: [PATCH] lglock: make lg_lock_global() actually lock globally
To: Jonathan Corbet <corbet@lwn.net>, Tejun Heo <tj@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rusty Russell <rusty@rustcorp.com.au>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Nick Piggin <npiggin@kernel.dk>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 25, 2010 at 12:28 PM, Jonathan Corbet <corbet@lwn.net> wrote:
> lglock: make lg_lock_global() actually lock globally

Grrr. Same disease as Nick and others. Why do you repeat the subject
line in the body? Don't do that. We don't want the summary line twice
in the commit message, and we don't want it twice in the email.

We simply don't want it twice. Full stop.

> lg_lock_global() currently only acquires spinlocks for online CPUs, but
> it's meant to lock all possible CPUs.  At Nick's suggestion, change
> for_each_online_cpu() to for_each_possible_cpu() to get the expected
> behavior.

Can you say what this actually matters for? Don't we do stop-machine
for CPU hotplug anyway? And if we don't, shouldn't we? Exactly because
otherwise "for_each_online_cpu()" is always racy (and that has nothing
to do with the lglock).

                  Linus
