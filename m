Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752787Ab0CRLRP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 07:17:15 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:37955 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752548Ab0CRLRN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 07:17:13 -0400
Date: Thu, 18 Mar 2010 12:17:24 +0100
From: Borislav Petkov <bp@amd64.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Michal Marek <mmarek@suse.cz>, linux-kbuild <linux-kbuild@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       LKML <linux-kernel@vger.kernel.org>, Jamie Lokier <jamie@shareable.org>,
       Roland Dreier <rdreier@cisco.com>, Al Viro <viro@ZenIV.linux.org.uk>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Brian Gerst <brgerst@gmail.com>
Subject: Re: [PATCH] x86: Add optimized popcnt variants
Message-ID: <20100318111724.GA11152@aftab>
References: <20100223155852.GF30382@aftab>
 <4B84118C.90203@zytor.com>
 <20100223175457.GA2401@aftab>
 <4B841BC3.1000908@zytor.com>
 <20100223190614.GB2401@aftab>
 <4B875BBD.4060104@zytor.com>
 <20100226074714.GA15310@aftab>
 <4B88097E.7010608@zytor.com>
 <20100227082807.GA21706@aftab>
 <4B8979DA.9000201@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B8979DA.9000201@zytor.com>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@zytor.com>
Date: Sat, Feb 27, 2010 at 12:00:26PM -0800

> On 02/27/2010 12:28 AM, Borislav Petkov wrote:
> > 
> >> I guess, on the other hand, if it ends up not getting merged until .35
> >> it's not a huge deal either.
> > 
> > Yeah, let's give it another round of testing and queue it for .35 -
> > AFAIR Ingo runs also a wide testing effort so it spending another cycle
> > in -tip and being hammered on by us could give us a bit more certainty.
> > 
> 
> Yes, if we can get into -tip then we'll get more test coverage, so I'll
> queue it up for .35 as soon as the merge window closes.  Please remind
> me if I forget.

Ok, I've been pretty busy lately and this got pushed back on the todo
list. I finally got around to do some build-testing with a bunch of
compilers and -fcall-saved* seem to get accepted. I haven't stared at
their asm output though, yet:


command:
make CC=gcc-<version> HOSTCC=gcc-<version> -j4

compile stats (64bit only):

not ok:
- gcc-3.3 (GCC) 3.3.5 (Debian 1:3.3.5-13):	OOM KILLER goes off, gcc-3.3 leak maybe

ok:
- gcc-3.4 (GCC) 3.4.4 20050314 (prerelease) (Debian 3.4.3-13sarge1)
- gcc-4.1 (GCC) 4.1.3 20080704 (prerelease) (Debian 4.1.2-27)
- gcc-4.3 (Debian 4.3.4-6) 4.3.4
- gcc (Debian 4.4.2-6) 4.4.2
- gcc (Debian 4.4.3-3) 4.4.3

- gcc-3.4.6 (GCC) 3.4.6 (Gentoo 3.4.6-r2 p1.6, ssp-3.4.6-1.0, pie-8.7.10)
- gcc-4.1.2 (GCC) 4.1.2 (Gentoo 4.1.2 p1.3)

I'm attaching the versions of the patches I'm using. The first one by
PeterZ touches a bunch of arches and Andrew hasn't picked it up yet so
the question of getting the second (popcnt) patch to see wider testing
in some tree is still unresolved. Suggestions, ideas?

Thanks.

-- 
Regards/Gruss,
Boris.

--
Advanced Micro Devices, Inc.
Operating Systems Research Center
