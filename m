Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754738Ab1CKAjL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 19:39:11 -0500
Received: from mail-pv0-f174.google.com ([74.125.83.174]:41033 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753926Ab1CKAjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 19:39:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=DGaJv39f/2Y2H+L8gN2Be1jjheTnlMF8pKgvA5nGhwBxDtMrnoaa2EuGpftin7MTgo
         FLANF2tdMudVwaXO5GnLjk88jJsUc+ZjuBshatUnT88dkQYYs0NvigKnJpNpDmAhnl8a
         H7DtUoj9TeP1bcM/TizhzoZxx/hVTHV+1BL9A=
From: Wang Lei <f3d27b@gmail.com>
To: "Henrik Rydberg" <rydberg@euromail.se>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [BUG] Fans keep running, first found since v2.6.38-rc7
References: <4d774c85.20f98e0a.2695.73ed@mx.google.com>
	<20110310213340.GA1821@polaris.bitmath.org>
Date: Fri, 11 Mar 2011 08:39:26 +0800
In-Reply-To: <20110310213340.GA1821@polaris.bitmath.org> (Henrik Rydberg's
	message of "Thu, 10 Mar 2011 22:33:40 +0100")
Message-ID: <4d796f2c.20f98e0a.3266.fffff4e2@mx.google.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi, Henrik Rydberg.

"Henrik Rydberg" <rydberg@euromail.se> writes:

> Hi,
>
>> [~]$ cat /sys/class/thermal/thermal_zone0/trip_point_*_temp
>> 105000
>> 15900
>> 15900
>> 15900
>> 15900
>> 15900
>> [~]$ 
>> 
>> This is the output at v2.6.38-rc6+:
>> 
>> [~]$ cat /sys/class/thermal/thermal_zone0/trip_point_*_temp
>> 105000
>> 95000
>> 75000
>> 65000
>> 55000
>> 40000
>> [~]$
>> 
>> Any help is appreciated.
>> 
>> Cheers,
>> Lei
>
> I wonder if this problem is related, present in latest git (35d34df71):
>
> mainline>cat /sys/module/*/srcversion | sort | uniq -c
>       1 03B88A441752AC2157DBD6A
>       1 0C932B9F52535F81D3FFF93
>       1 1BB88B035855B2AE7F47229
>       1 2100DB8F374F0EE1AA607F2
>       1 2BBC9DD51CFC881CF5F60AA
>       1 3D4D8AFD09A0C71D9B19948
>       1 3EF20C25CC62BD750F4C3F3
>       1 41024DA8E830C7DAE171017
>       1 47AD35AE180473EB06EED32
>      19 533BB7E5866E52F63B9ACCB
>       1 598C709DDDAB55EB331379A
>       1 5AC5CB9DA8C242CBC76EEC0
>       1 6961679677DB019310F9046
>       1 6BBB3E29D835F5EC8C2FCF9
>       1 78FBC4BE6E0D68CC70FBFEC
>       1 97A6441C3D26B1B6A9B2B2B
>       1 AAD974CC23F320629986F38
>       2 AEBBDFD273E0316FD4E5D04
>       1 CC2F5468F15E654BA13360D
>       1 CD18C3E8FA6CD119EE11935
>       1 EA10C238A334BB44445DC83
>       1 EF2B1B70D28CB9290D97726
>
> It shows that 19 modules exhibit the same module srcversion... This
> behavior showed up late in -rc's, I am going to bisect now (unless
> this is already done).
>
> Henrik

I've confirmed the commit that caused the problem and sent a mail.

I don't know if these two problem are related, because i ran your
command but there is no `/sys/module/*/srcversion' in my system. I think
this is because of some configs i didn't enable. But I'll wait to see if
I've provided enough information to help your hackers fix it.

Thanks!

-- 
Regards,
Lei
