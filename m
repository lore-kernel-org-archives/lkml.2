Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751289Ab0IISxP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 14:53:15 -0400
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:20895
	"EHLO VA3EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752711Ab0IISxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 14:53:13 -0400
X-SpamScore: -21
X-BigFish: VPS-21(zzbb2cK936eK1432N98dN4015Lzz1202hzz8275dh8275chz32i2a8h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L8HTKE-02-QJD-02
X-M-MSG: 
Date: Thu, 9 Sep 2010 20:48:12 +0200
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: "oprofile-list@lists.sf.net" <oprofile-list@lists.sf.net>,
        Andi Kleen <andi@firstfloor.org>,
        Patrick Simmons <linuxrocks123@netscape.net>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Add Support for Intel CPU Family 6 / Model 22 (Intel
 Celeron 540)
Message-ID: <20100909184812.GT13563@erda.amd.com>
References: <4C879EF4.90509@netscape.net>
 <20100909123102.GQ13563@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100909123102.GQ13563@erda.amd.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09.09.10 14:31:02, Robert Richter wrote:
> On 08.09.10 10:34:28, Patrick Simmons wrote:
> > This patch adds CPU type detection for the Intel Celeron 540, which is 
> > part of the Core 2 family according to Wikipedia; the family and ID pair 
> > is absent from the Volume 3B table referenced in the source code 
> > comments.  I have tested this patch on an Intel Celeron 540 machine 
> > reporting itself as Family 6 Model 22, and OProfile runs on the machine 
> > without issue.  The patch was made against Linux version 2.6.35.4 but is 
> > so trivial that it should apply cleanly to anything relevant.  Please CC 
> > me with any comments or questions as I am not subscribed to the list.
> > 
> > --Patrick
> > 
> > Signed-off-by: Patrick Simmons <linuxrocks123@netscape.net>
> 
> Applied to oprofile/urgent.

Ingo,

please pull this update for tip/perf/urgent from:

 git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git urgent

Thanks,

-Robert

> 
> > 
> > --- linux/arch/x86/oprofile/nmi_int.c.orig    2010-09-08 
> > 08:01:56.000000000 -0600
> > +++ linux/arch/x86/oprofile/nmi_int.c    2010-09-08 05:57:18.000000000 -0600
> > @@ -664,7 +664,7 @@ static int __init ppro_init(char **cpu_t
> >       case 14:
> >           *cpu_type = "i386/core";
> >           break;
> > -    case 15: case 23:
> > +    case 15: case 22: case 23:
> 
> I slightly modified the change:
> 
> -       case 15: case 23:
> +       case 0x0f:
> +       case 0x16:
> +       case 0x17:
> 
> Thanks Patrick.
> 
> -Robert
> 
> >           *cpu_type = "i386/core_2";
> >           break;
> >       case 0x1a:
> > 
> > 

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

