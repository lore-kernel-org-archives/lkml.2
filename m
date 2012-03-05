Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964927Ab2CEOlA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 09:41:00 -0500
Received: from cantor2.suse.de ([195.135.220.15]:55177 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932379Ab2CEOk7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 09:40:59 -0500
Message-ID: <4F54D078.9050608@suse.cz>
Date: Mon, 05 Mar 2012 15:40:56 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Nishanth Aravamudan <nacc@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-kbuild@vger.kernel.org
Subject: Re: `make dep' with clock skew detected loops forever
References: <20120229190138.GG5136@linux.vnet.ibm.com>
In-Reply-To: <20120229190138.GG5136@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29.2.2012 20:01, Nishanth Aravamudan wrote:
> Noticed something on a fresh FC16 based install on a test server in our
> lab.  Autotest by default runs `make dep` and it seems the clock is
> pretty badly skewed on this server, resulting in an infinite loop of:
> 
> 01:09:37 DEBUG| Running 'make dep'
> 01:09:38 DEBUG| [stderr] make: Warning: File `/usr/local/autotest/tmp/build/linux/arch/powerpc/Makefile' has modification time 112143 s in the future
> 01:09:38 DEBUG| [stderr] make[1]: Warning: File `/usr/local/autotest/tmp/build/linux/arch/powerpc/Makefile' has modification time 112143 s in the future
> 01:09:38 DEBUG| [stderr] make[2]: Warning: File `scripts/Makefile.host' has modification time 112143 s in the future
> 01:09:38 DEBUG| [stdout]   HOSTCC  scripts/basic/fixdep
> 01:09:38 DEBUG| [stderr] make[2]: warning:  Clock skew detected.  Your build may be incomplete.
> 01:09:38 DEBUG| [stderr] make[2]: Warning: File `scripts/Makefile.host' has modification time 112143 s in the future
[...]

> Anyone know why that happens?

Because the system time time is several hours, if not days, behind, so
generated files are older than source files and thus dependencies cannot
work. You need to fix the system time to be at least ahead of the mtime
of the sources.


> Obvious fixes are to either not run `make dep`

I don't think this is limited to make dep.

Michal
