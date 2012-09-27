Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754221Ab2I0SNC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 14:13:02 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:35127 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753276Ab2I0SNA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 14:13:00 -0400
Message-ID: <50649715.1090507@ahsoftware.de>
Date: Thu, 27 Sep 2012 20:12:37 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>
CC: Dan Carpenter <dan.carpenter@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: kernel BUG at fs/buffer.c:3205 (stable 3.5.3)
References: <50531629.9020107@ahsoftware.de> <20120925110206.GD28937@mwanda> <50643C4A.9010202@ahsoftware.de> <20120927151232.GA12210@quack.suse.cz> <506474E8.3030300@ahsoftware.de> <50647CCC.7010407@ahsoftware.de> <5064945C.4020403@ahsoftware.de>
In-Reply-To: <5064945C.4020403@ahsoftware.de>
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 27.09.2012 20:01, schrieb Alexander Holler:

> After 2 successful tries in sequence, the third failed (sorry, LANG=de):
>
> ---------------------------------------------------------------
> [root@krabat bind]# tar cp . | mbuffer | bzip2smp
>  >/mnt/usb3/Krabat.Fedora17.sdb2.27.09.12.tar.bz2
> in @ 33.1 MiB/s, out @ 38.3 MiB/s,  888 MiB total, buffer  95% fulltar:
> ./tmp/.X11-unix/X0: Socket ignoriert
> in @  0.0 KiB/s, out @ 20.8 MiB/s, 24.9 GiB total, buffer  22% full
> summary: 24.9 GiByte in 19 min 53.0 sec - average of 21.4 MiB/s
> [root@krabat bind]# tar djf /mnt/usb3/Krabat.Fedora17.sdb2.27.09.12.tar.bz2
> ./var/log/messages: Änderungszeit ist unterschiedlich
> ./var/log/messages: Größe ist unterschiedlich
> ./var/tmp/kdecache-aholler/icon-cache.kcache: Änderungszeit ist
> unterschiedlich
> ./var/tmp/kdecache-aholler/icon-cache.kcache: Unterschiedliche Inhalte
> ./var/tmp/kdecache-aholler/plasma_theme_oxygen.kcache: Änderungszeit ist
> unterschiedlich
> ./var/tmp/kdecache-aholler/plasma_theme_oxygen.kcache: Unterschiedliche
> Inhalte
> ./var/lib/chrony/drift: Änderungszeit ist unterschiedlich
> ./var/lib/chrony/drift: Unterschiedliche Inhalte
> ./home/aholler/.kde/share/apps/konqueror/autosave/_1.77: Änderungszeit
> ist unterschiedlich
> ./home/aholler/.kde/share/apps/konqueror/autosave/_1.77: Größe ist
> unterschiedlich
> ./home/aholler/.kde/share/apps/konqueror/konq_history: Änderungszeit ist
> unterschiedlich
> ./home/aholler/.kde/share/apps/konqueror/konq_history: Größe ist
> unterschiedlich
> ./home/aholler/.kde/share/apps/kcookiejar/cookies: Änderungszeit ist
> unterschiedlich
> ./home/aholler/thinstation_src-2.0beta2.tar.bz2: Unterschiedliche Inhalte
>
> bzip2: Data integrity error when decompressing.
>          Input file = (stdin), output file = (stdout)
>
> It is possible that the compressed file(s) have become corrupted.
> You can use the -tvv option to test integrity of such files.
>
> You can use the `bzip2recover' program to attempt to recover
> data from undamaged sections of corrupted files.
>
> tar: Unerwartetes Dateiende im Archiv.
> tar: Child returned status 2
> tar: Error is not recoverable: exiting now
> [root@krabat bind]#
> ---------------------------------------------------------------
>
> This time without any oops, dmesg just shows some
>
> ---------------------------------------------------------------
> [  111.087356] EXT4-fs (sdc1): mounted filesystem with ordered data
> mode. Opts: (null)
> [  672.868948] CPU4: Core temperature above threshold, cpu clock
> throttled (total events = 1)
> [  672.868949] CPU0: Core temperature above threshold, cpu clock
> throttled (total events = 1)
> [  672.869970] CPU0: Core temperature/speed normal
> [  672.869971] CPU4: Core temperature/speed normal
> [  688.285419] CPU6: Core temperature above threshold, cpu clock
> throttled (total events = 1)
> [  688.285421] CPU2: Core temperature above threshold, cpu clock
> throttled (total events = 1)
> [  688.286442] CPU2: Core temperature/speed normal
> [  688.286443] CPU6: Core temperature/speed normal
> [  698.822614] CPU3: Core temperature above threshold, cpu clock
> throttled (total events = 1)
> [  698.822615] CPU7: Core temperature above threshold, cpu clock
> throttled (total events = 1)
> [  698.824674] CPU3: Core temperature/speed normal
> [  698.824675] CPU7: Core temperature/speed normal
> [  706.979633] CPU1: Core temperature above threshold, cpu clock
> throttled (total events = 1)
> [  706.979635] CPU5: Core temperature above threshold, cpu clock
> throttled (total events = 1)
> [  706.980648] CPU1: Core temperature/speed normal
> [  706.980649] CPU5: Core temperature/speed normal
> [  899.540485] [Hardware Error]: Machine check events logged
> ---------------------------------------------------------------
>
> Nothing else. Kernel is 3.5.4 userland now F17.

Maybe it's really a heating problem and the stock fan (or throttling by 
the kernel) isn't enough if the processor (or the chipset) is used like 
that for about 60 minutes. I will checkout if one or more additional 
fans will help.

Regards,

Alexander

