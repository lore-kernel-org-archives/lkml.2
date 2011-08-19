Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756251Ab1HSXaX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 19:30:23 -0400
Received: from mga02.intel.com ([134.134.136.20]:30989 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750851Ab1HSXaX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 19:30:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="39605555"
From: Andi Kleen <andi@firstfloor.org>
To: Ortwin =?utf-8?Q?Gl=C3=BCck?= <odi@odi.ch>
Cc: linux-kernel@vger.kernel.org
Subject: Re: contention on long-held spinlock
References: <4E4E2B2A.40100@odi.ch>
Date: Fri, 19 Aug 2011 16:30:22 -0700
In-Reply-To: <4E4E2B2A.40100@odi.ch> ("Ortwin =?utf-8?Q?Gl=C3=BCck=22's?=
 message of "Fri, 19 Aug
	2011 11:21:46 +0200")
Message-ID: <m27h69htdd.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ortwin Glück <odi@odi.ch> writes:
>
> I wonder if spinlocks could be made aware of such a situation and
> relax. Something like if spinning for more than 1000 times, perform a
> simple backoff and sleep. A spinlock should never spin busy for
> several seconds, right?

Spining for several seconds is always a bug. There's no way to make
this work. Please post backtraces (e.g. from perf record -g ; perf
report) and cc the driver maintainer, so that they can fix their
buggy code.

-Andi


-- 
ak@linux.intel.com -- Speaking for myself only
