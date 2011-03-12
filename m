Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753802Ab1CLEeb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 23:34:31 -0500
Received: from mail-px0-f179.google.com ([209.85.212.179]:39177 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752705Ab1CLEe2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 23:34:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Pm4/gfd30EL2Vgy76KRZ1HaxF77sgTWatH8FppAbyg95P/uj/OCKfTaC6xA/ZV/9NK
         fdwDoESdw/j7pqj9Gb0/HOfY8B2oNF0Jl03Fzs9JJTmp7Ld+WainRmrKH3k7KWeZqGrM
         6vHu1lCZwzo6qGqioevE9CgFBxUS5lmdMdjOc=
Date: Sat, 12 Mar 2011 12:34:09 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: Thomas Renninger <trenn@suse.de>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-pm@lists.linux-foundation.org, discuss@lesswatts.org,
        power@bughost.org, cpufreq@vger.kernel.org, linux@dominikbrodowski.net,
        Mattia Dongili <malattia@linux.it>, Len Brown <lenb@kernel.org>,
        Ingo Molnar <mingo@elte.hu>, herrmann.der.user@googlemail.com,
        linux-omap@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [ANNOUNCE] cpupowerutils - cpufrequtils extended with quite
 some features
Message-ID: <20110312043409.GA3634@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <201103111247.00212.trenn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <201103111247.00212.trenn@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 11, 2011 at 12:46:59PM +0100, Thomas Renninger wrote:
> Happy testing..., if you have a recent machine, you'll like it!
> 
> After some testing phase it would be great to get this tool
> merged into the kernel git repo under:
> tools/power/cpupower
> and replace the Intel HW only supporting tools in tools/power/x86.

I got below output on my laptop:

    |Mperf               || Idle_Stats                
CPU | C0   | Cx   | Freq || POLL | C1   | C2   | C3   
   0| 36.00| 64.00|   820||1843411670376227.2|1843411670376692.2|  0.00|  0.00
   1| 44.69| 55.31|   920||  0.00|  0.00|  0.00|  0.00

Seems below patch fix it:

Thanks,
Yong

---
--- utils/helpers/sysfs-orig.c	2011-03-12 12:32:06.179827929 +0800
+++ utils/helpers/sysfs.c	2011-03-12 12:24:36.865599924 +0800
@@ -126,7 +126,7 @@
 		return 0;
 	}
 
-	value = strtoul(linebuf, &endp, 0);
+	value = strtoull(linebuf, &endp, 0);
 
 	if ( endp == linebuf || errno == ERANGE )
 		return 0;
