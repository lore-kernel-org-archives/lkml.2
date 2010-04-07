Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932642Ab0DGOOe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 10:14:34 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:58376 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932604Ab0DGOOb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 10:14:31 -0400
Date: Wed, 7 Apr 2010 16:13:34 +0200
From: Borislav Petkov <bp@amd64.org>
To: Paulo Marques <pmarques@grupopie.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Borislav Petkov <bp@alien8.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>, Minchan Kim <minchan.kim@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, sgunderson@bigfoot.com
Subject: Re: Ugly rmap NULL ptr deref oopsie on hibernate (was Linux
 2.6.34-rc3)
Message-ID: <20100407141334.GF12052@aftab>
References: <4BBB69A9.5090906@redhat.com>
 <alpine.LFD.2.00.1004061053450.3487@i5.linux-foundation.org>
 <20100406120315.53ad7390.akpm@linux-foundation.org>
 <20100406194238.GB20357@a1.tnic>
 <alpine.LFD.2.00.1004061243240.3487@i5.linux-foundation.org>
 <20100406205123.GC20357@a1.tnic>
 <alpine.LFD.2.00.1004061403170.3487@i5.linux-foundation.org>
 <20100406225925.GA3446@liondog.tnic>
 <alpine.LFD.2.00.1004061609320.3487@i5.linux-foundation.org>
 <4BBC913E.5050703@grupopie.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BBC913E.5050703@grupopie.com>
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

From: Paulo Marques <pmarques@grupopie.com>
Date: Wed, Apr 07, 2010 at 03:05:50PM +0100

> Linus Torvalds wrote:
> > [...]
> > So it once more is 'anon_vma->head.next' that is crap, but now it's not 
> > NULL, it's that very odd 0x002e2e2e002e2e2e pattern (the %r13 has had 0x20 
> > subtracted from it, so that LSB of "0x0e" is actually _also_ a 0x2e).
> > 
> > What does '0x2e' mean? It's ASCII '.', but that doesn't really mean 
> > anything either.
> 
> Just a wild shot in the dark: it can be a couple of gray pixels with
> intensity 0x2e at some 32 bits per pixel mode. I say this because of the
> zero bytes there and someone mentioning seeing the problem when starting X.

I don't think those are related: the problem when X was starting happens
with Rik' newest patch and the funny %r13 value happened after enabling
SLUB debugging last night.

Thanks.

-- 
Regards/Gruss,
Boris.

--
Advanced Micro Devices, Inc.
Operating Systems Research Center
