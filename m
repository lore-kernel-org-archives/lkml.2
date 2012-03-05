Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752690Ab2CEPdi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 10:33:38 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:43761 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750789Ab2CEPdg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 10:33:36 -0500
Date: Mon, 5 Mar 2012 07:33:09 -0800
From: Nishanth Aravamudan <nacc@linux.vnet.ibm.com>
To: Michal Marek <mmarek@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-kbuild@vger.kernel.org
Subject: Re: `make dep' with clock skew detected loops forever
Message-ID: <20120305153309.GA31864@linux.vnet.ibm.com>
References: <20120229190138.GG5136@linux.vnet.ibm.com>
 <4F54D078.9050608@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F54D078.9050608@suse.cz>
X-Operating-System: Linux 3.0.0-16-generic (x86_64)
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12030515-5806-0000-0000-000013269E76
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05.03.2012 [15:40:56 +0100], Michal Marek wrote:
> On 29.2.2012 20:01, Nishanth Aravamudan wrote:
> > Noticed something on a fresh FC16 based install on a test server in our
> > lab.  Autotest by default runs `make dep` and it seems the clock is
> > pretty badly skewed on this server, resulting in an infinite loop of:
> > 
> > 01:09:37 DEBUG| Running 'make dep'
> > 01:09:38 DEBUG| [stderr] make: Warning: File `/usr/local/autotest/tmp/build/linux/arch/powerpc/Makefile' has modification time 112143 s in the future
> > 01:09:38 DEBUG| [stderr] make[1]: Warning: File `/usr/local/autotest/tmp/build/linux/arch/powerpc/Makefile' has modification time 112143 s in the future
> > 01:09:38 DEBUG| [stderr] make[2]: Warning: File `scripts/Makefile.host' has modification time 112143 s in the future
> > 01:09:38 DEBUG| [stdout]   HOSTCC  scripts/basic/fixdep
> > 01:09:38 DEBUG| [stderr] make[2]: warning:  Clock skew detected.  Your build may be incomplete.
> > 01:09:38 DEBUG| [stderr] make[2]: Warning: File `scripts/Makefile.host' has modification time 112143 s in the future
> [...]
> 
> > Anyone know why that happens?
> 
> Because the system time time is several hours, if not days, behind, so
> generated files are older than source files and thus dependencies cannot
> work. You need to fix the system time to be at least ahead of the mtime
> of the sources.

That makes sense.

> > Obvious fixes are to either not run `make dep`
> 
> I don't think this is limited to make dep.

Well, killing `make dep`, which was just looping, and executing `make
-j16 vmlinux` did seem to complete. But it was a while ago and maybe I'm
mis-remembering.

Ah well, I've fixed up my testing scripts to ensure an ntp run is
performed before trying to build.

Thanks,
Nish

-- 
Nishanth Aravamudan <nacc@us.ibm.com>
IBM Linux Technology Center

