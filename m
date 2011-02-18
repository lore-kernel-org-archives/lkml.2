Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756657Ab1BRE4T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 23:56:19 -0500
Received: from mga14.intel.com ([143.182.124.37]:15416 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752475Ab1BRE4R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 23:56:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,184,1297065600"; 
   d="scan'208";a="390578084"
Message-ID: <4D5DFBE4.7090104@intel.com>
Date: Thu, 17 Feb 2011 20:56:04 -0800
From: "H. Peter Anvin" <h.peter.anvin@intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Matthieu Castet <castet.matthieu@free.fr>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [RFC] x86: Unify allocation of low memory trampolines
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset unifies all the allocation of low memory (a.k.a. realmode
memory, low megabyte) code (currently there are three users of low
memory: BIOS reboot, suspend, and of course the SMP trampoline -- there
is at least one additional one coming down the pipe in the near term)
and reserves and installs them as a single memory object very early
during initialization.  This means the original can be put in initrodata
and discarded after the allocation is done.

I consider this patchset to be a first step: the next step is to
actually link all the realmode code together into a single common
address space before encapsulation.  This will enable X/W separation as
well as provide an even more natural way to access symbols in the real
mode object.

	-hpa
