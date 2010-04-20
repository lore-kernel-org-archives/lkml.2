Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753550Ab0DTXVl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 19:21:41 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52064 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752764Ab0DTXVj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 19:21:39 -0400
From: Alexander Graf <agraf@suse.de>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Subject: perf top broken on ppc64
Date: Wed, 21 Apr 2010 01:21:36 +0200
Message-Id: <594EC076-62C6-473D-9AF2-47AEE4B57ED3@suse.de>
Cc: LKML Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       ppc-dev <linuxppc-dev@lists.ozlabs.org>
To: Paul Mackerras <paulus@samba.org>
Mime-Version: 1.0 (Apple Message framework v1078)
X-Mailer: Apple Mail (2.1078)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

While trying to find out performance bottlenecks in KVM for PowerPC I figured I'd try and use "perf top" to see what's going on in the system. This works great on my G4, but doesn't on the Powerstation (970MP).

The only weird thing I can imagine about this setup is that I'm running 32 bit userland on a 64 bit kernel. So I went ahead and compiled perf for ppc64 - without any change:

# file `which perf`
/root/bin/perf: ELF 64-bit MSB executable, 64-bit PowerPC or cisco 7500, version 1 (SYSV), for GNU/Linux 2.6.4, dynamically linked (uses shared libs), not stripped

Whenever I call 'perf top' I get the following output:


-------------------------------------------------------------------------------------------------------
   PerfTop:   57159 irqs/sec  kernel:100.0% [1000Hz cycles],  (all, 4 CPUs)
-------------------------------------------------------------------------------------------------------

             samples  pcnt  DSO
             _______ _____  


Where there would usually be functions being listed I don't get anything.
The interesting part is that 'perf record -g' and 'perf report -g' work just fine. I get reasonable output. I also had 'perf top' with the exact same binaries working by accident too once. But then I rebooted and not it's all moot again.

So the question is: why doesn't the top function work for me?


Thanks,

Alex


