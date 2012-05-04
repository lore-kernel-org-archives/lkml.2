Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760568Ab2EDWwB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 18:52:01 -0400
Received: from ozlabs.org ([203.10.76.45]:56551 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760555Ab2EDWv7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 18:51:59 -0400
From: Michael Neuling <mikey@neuling.org>
To: Diwakar Tundlam <dtundlam@nvidia.com>
cc: "'Peter Zijlstra'" <a.p.zijlstra@chello.nl>,
        "'Ingo Molnar'" <mingo@kernel.org>,
        "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'Christoph Lameter'" <cl@gentwo.org>,
        "'Stephen Rothwell'" <sfr@canb.auug.org.au>,
        "'Benjamin Herrenschmidt'" <benh@kernel.crashing.org>,
        "'David Rientjes'" <rientjes@google.com>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>
Subject: Re: [PATCH] sched: Enable arch-specific asym packing option in sched domain
In-reply-to: <1DD7BFEDD3147247B1355BEFEFE46652379C3DF102@HQMAIL04.nvidia.com>
References: <1DD7BFEDD3147247B1355BEFEFE46652379C3DF0FF@HQMAIL04.nvidia.com> <1DD7BFEDD3147247B1355BEFEFE46652379C3DF101@HQMAIL04.nvidia.com> <1336169422.16236.1.camel@twins> <1DD7BFEDD3147247B1355BEFEFE46652379C3DF102@HQMAIL04.nvidia.com>
Comments: In-reply-to Diwakar Tundlam <dtundlam@nvidia.com>
   message dated "Fri, 04 May 2012 15:18:04 -0700."
X-Mailer: MH-E 8.2; nmh 1.3; GNU Emacs 23.3.1
Date: Sat, 05 May 2012 08:51:58 +1000
Message-ID: <5722.1336171918@neuling.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> We need this for Tegra's slight asymmetry with core0.

This would seem to be to be a different problem.  I don't think the
packing mechanism is what you want.

Shouldn't you be increasing the CPU power of this core, so that all
tasks get a fair go on this core?  Otherwise you're breaking the
fundamental concept of a completely fair scheduler.

Using this packing mechanism you won't get this.  Any task that lands on
core 0 will get an unfair amount of computation power, compared to tasks
that landed on core 1.

Mikey
