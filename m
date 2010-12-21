Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933372Ab0LUAND (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 19:13:03 -0500
Received: from tex.lwn.net ([70.33.254.29]:57271 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757394Ab0LUANB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 19:13:01 -0500
Date: Mon, 20 Dec 2010 17:12:59 -0700
From: Jonathan Corbet <corbet@lwn.net>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@au1.ibm.com>,
        Tim Pepper <lnxninja@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH 06/15] nohz_task: Keep the tick if rcu needs it
Message-ID: <20101220171259.1d3cb6ad@bike.lwn.net>
In-Reply-To: <20101220234934.GD1715@nowhere>
References: <1292858662-5650-1-git-send-email-fweisbec@gmail.com>
	<1292858662-5650-7-git-send-email-fweisbec@gmail.com>
	<1292860700.5021.14.camel@laptop>
	<20101220234934.GD1715@nowhere>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.23.2; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Dec 2010 00:49:38 +0100
Frederic Weisbecker <fweisbec@gmail.com> wrote:

> Nope, the new config can only be built after [RFC PATCH 11/15] x86: Nohz task support
> 
> I know I split up the patches in some unusual way but I did that on purpose:
> I wanted to have a finegrained patchset so that it's more reviewable than a big
> "core support" - "arch support" dual patch based style.
> 
> But I ensured the new config can not be enabled before it's entirely buildable
> and has no known bugs.

Which is a nice thought (it helped me to understand the patches - article
forthcoming), but there is a downside: if anybody tries to bisect a
problem, they'll end up at #11.  This stuff is sufficiently tricky that it
would be nice to be able to bisect a little closer to the patch which
actually introduced a bug.

jon
