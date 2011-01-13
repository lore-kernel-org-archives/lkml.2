Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757439Ab1AMW0R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 17:26:17 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:26952 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752149Ab1AMW0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 17:26:10 -0500
Date: Thu, 13 Jan 2011 23:26:09 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Yinghai Lu <yinghai@kernel.org>, David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Bad array index in arch/x86/mm/numa_64.c::debug_cpumask_set_cpu()
Message-ID: <alpine.LNX.2.00.1101132318010.11347@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

In arch/x86/mm/numa_64.c::debug_cpumask_set_cpu() we call 
early_cpu_to_node() which may return NUMA_NO_NODE (which has the value 
-1). This value is subsequently used as an index into 
the 'node_to_cpumask_map' array and '-1' is not going to fly too wel as an 
array index here.

This code comes from commit d906f0eb2f0e6d1a24c479f69a9c39e7e45c5ae8
"x86, numa: Fix CONFIG_DEBUG_PER_CPU_MAPS without NUMA emulation".

I must admit I have no idea what the best way to deal with this is, so 
I'll just report it.

Happy bug fixing.

-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.

