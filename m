Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754027Ab1CLEkd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 23:40:33 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:39367 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752705Ab1CLEk3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 23:40:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=IQDAfyXLm0HFUL2f4HWf9rKSm8X2fcNhIpau27f7H87pl3YoDOBILyaISWbb28O6GH
         fjs3Fc6l/1tlwkhA8Bk7/CVduF/cfD4HsGmgvgDqEA/l5SCg1Y+Q5CzASRdTY2Cnh44w
         jgGp1ccaWliSbmtqhNCxQ4+r9uciuvhZEzpBk=
Date: Sat, 12 Mar 2011 12:40:10 +0800
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
Message-ID: <20110312044010.GB3634@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <201103111247.00212.trenn@suse.de>
 <20110312043409.GA3634@zhy>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20110312043409.GA3634@zhy>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 12, 2011 at 12:34:09PM +0800, Yong Zhang wrote:
> On Fri, Mar 11, 2011 at 12:46:59PM +0100, Thomas Renninger wrote:
> > Happy testing..., if you have a recent machine, you'll like it!
> > 
> > After some testing phase it would be great to get this tool
> > merged into the kernel git repo under:
> > tools/power/cpupower
> > and replace the Intel HW only supporting tools in tools/power/x86.
> 
> I got below output on my laptop:
> 
>     |Mperf               || Idle_Stats                
> CPU | C0   | Cx   | Freq || POLL | C1   | C2   | C3   
>    0| 36.00| 64.00|   820||1843411670376227.2|1843411670376692.2|  0.00|  0.00
>    1| 44.69| 55.31|   920||  0.00|  0.00|  0.00|  0.00
> 
> Seems below patch fix it:

forget the declaration of value :)

---
--- utils/helpers/sysfs-orig.c	2011-03-12 12:32:06.179827929 +0800
+++ utils/helpers/sysfs.c	2011-03-12 12:35:21.512796546 +0800
@@ -111,7 +111,7 @@
 						     unsigned int idlestate,
 						     enum idlestate_value which)
 {
-	unsigned long value;
+	unsigned long long value;
 	unsigned int len;
 	char linebuf[MAX_LINE_LEN];
 	char *endp;
@@ -126,7 +126,7 @@
 		return 0;
 	}
 
-	value = strtoul(linebuf, &endp, 0);
+	value = strtoull(linebuf, &endp, 0);
 
 	if ( endp == linebuf || errno == ERANGE )
 		return 0;
