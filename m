Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754258Ab2FMToj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 15:44:39 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:55846 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752005Ab2FMToi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 15:44:38 -0400
MIME-Version: 1.0
In-Reply-To: <1339535645.22704.293.camel@edumazet-glaptop>
References: <CAGh0HCDhF_nKP+YKQDyfuYKcx2YKBuAPkMHxa0x265Rgs0haMg@mail.gmail.com>
	<1339535645.22704.293.camel@edumazet-glaptop>
Date: Wed, 13 Jun 2012 21:44:37 +0200
X-Google-Sender-Auth: XQIOMWg6UX6pck05XCiBoE1iCDM
Message-ID: <CAGh0HCCK2pi6NtOaSc1zw_OurtpN9wskCdjT5FXo117vjKT0RQ@mail.gmail.com>
Subject: Re: PROBLEM: Keyboard/mouse freeze with high network usage (r8169/brcmsmac/broadcom-wl)
From: Guillaume Bouchard <guillaume.bouchard@liris.cnrs.fr>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Jun 12, 2012 at 11:14 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> If your script can trigger the freeze in less than 5 minutes, you could
> start a background job to check /proc/meminfo, it sounds there is a mem
> leak ?
>
> while :
> do
>  date
>  cat /proc/meminfo
>  cat /proc/slabinfo
>  sleep 10
> done

Today it tooks 55 minutes to freeze. Kind of an heisenbug.

I have the /proc/meminfo and slabinfo trace, but it is around 4Mo, so
I put them on a separate host

http://gobpower.free.fr/meminfo/

This directory contains the cat of meminfo/slabinfo
(dump_meminfo_slabinfo), and *commands* and *data.dat* files which are
gnuplot files to display the curve of meminfo values. (gnuplot > load
'commands' to display it).

I don't know what I'm supposed to look for, so I tried to get closer
look on different part of the graph but it does not really talk to me.

I included an image of the graph, the .png in the same directory.  X
axis is the time (in 10 seconds).

between 0 and 180 in x (0 to 1800 seconds), some curves are really
noisy, but it may coincide with the time I was using the computer and
tried to make it freeze.

The committed AS, inactive and inactive file are increasing through
time, and the so call "Mem Free" is decreasing.

Between 250 and 300 did the freeze happened. At approximately 300, I
noticed it and unload the psmouse module. We can notice some sharp cut
in some curves at this moment.

Sorry, I'm a bit lost to interpret those stuffs, all I can do for now
is following your advices, so if you find something in this log and
need more experimentations, I'll be happy to do them.

Thank you for your time.

-- 
Guillaume
