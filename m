Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752312Ab1CJVbC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 16:31:02 -0500
Received: from ch-smtp03.sth.basefarm.net ([80.76.149.214]:50344 "EHLO
	ch-smtp03.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751252Ab1CJVbA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 16:31:00 -0500
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Thu, 10 Mar 2011 22:33:40 +0100
To: Wang Lei <f3d27b@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [BUG] Fans keep running, first found since v2.6.38-rc7
Message-ID: <20110310213340.GA1821@polaris.bitmath.org>
References: <4d774c85.20f98e0a.2695.73ed@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4d774c85.20f98e0a.2695.73ed@mx.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: 83.254.52.20
X-Scan-Result: No virus found in message 1PxnRX-0002mE-Ax.
X-Scan-Signature: ch-smtp03.sth.basefarm.net 1PxnRX-0002mE-Ax 57082b2e226cbad92705098cbb26758a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> [~]$ cat /sys/class/thermal/thermal_zone0/trip_point_*_temp
> 105000
> 15900
> 15900
> 15900
> 15900
> 15900
> [~]$ 
> 
> This is the output at v2.6.38-rc6+:
> 
> [~]$ cat /sys/class/thermal/thermal_zone0/trip_point_*_temp
> 105000
> 95000
> 75000
> 65000
> 55000
> 40000
> [~]$
> 
> Any help is appreciated.
> 
> Cheers,
> Lei

I wonder if this problem is related, present in latest git (35d34df71):

mainline>cat /sys/module/*/srcversion | sort | uniq -c
      1 03B88A441752AC2157DBD6A
      1 0C932B9F52535F81D3FFF93
      1 1BB88B035855B2AE7F47229
      1 2100DB8F374F0EE1AA607F2
      1 2BBC9DD51CFC881CF5F60AA
      1 3D4D8AFD09A0C71D9B19948
      1 3EF20C25CC62BD750F4C3F3
      1 41024DA8E830C7DAE171017
      1 47AD35AE180473EB06EED32
     19 533BB7E5866E52F63B9ACCB
      1 598C709DDDAB55EB331379A
      1 5AC5CB9DA8C242CBC76EEC0
      1 6961679677DB019310F9046
      1 6BBB3E29D835F5EC8C2FCF9
      1 78FBC4BE6E0D68CC70FBFEC
      1 97A6441C3D26B1B6A9B2B2B
      1 AAD974CC23F320629986F38
      2 AEBBDFD273E0316FD4E5D04
      1 CC2F5468F15E654BA13360D
      1 CD18C3E8FA6CD119EE11935
      1 EA10C238A334BB44445DC83
      1 EF2B1B70D28CB9290D97726

It shows that 19 modules exhibit the same module srcversion... This
behavior showed up late in -rc's, I am going to bisect now (unless
this is already done).

Henrik
