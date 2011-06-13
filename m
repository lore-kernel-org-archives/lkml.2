Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754790Ab1FMBOr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jun 2011 21:14:47 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:34616 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754286Ab1FMBOp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jun 2011 21:14:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=K1+os9pZQzAWA50XMANJFLHeskqx4GhdkPnVyOuFwf6LaBpx/zi9UEcQ3dZXuU2mtm
         /O9h2I4ibx796cHHGVr9SOX+Fg+5Dud7a1Ul7WLExSWPbThBQ03wXT9BHHO0H6mMKXLq
         5V8KmCg4m4Em4qvfn0FvlP1PxGtuqZM8t7zTw=
MIME-Version: 1.0
In-Reply-To: <kTLfM29CaqB.A.xtE.szS9NB@chimera>
References: <9NVbY1BZ_5D.A.2lE.jzS9NB@chimera>
	<kTLfM29CaqB.A.xtE.szS9NB@chimera>
Date: Mon, 13 Jun 2011 03:14:44 +0200
Message-ID: <BANLkTinhdxrttCpGBtCMOZDYJJhAR=1zQRnew3t2=SxUYCSiNA@mail.gmail.com>
Subject: Re: [Bug #36962] [Regression 2.6.39][nouveau][bisected?] leaving
 fullscreen XV "crashes" with KDE desktop effects enabled
From: Jan Seiffert <kaffeemonster@googlemail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/6/12 Rafael J. Wysocki <rjw@sisk.pl>:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.38 and 2.6.39.
>
> The following bug entry is on the current list of known regressions
> introduced between 2.6.38 and 2.6.39.  Please verify if it still should
> be listed and let the tracking team know (either way).
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=36962
> Subject         : [Regression 2.6.39][nouveau][bisected?] leaving fullscreen XV "crashes" with KDE desktop effects enabled
> Submitter       : Jan Seiffert <kaffeemonster@googlemail.com>
> Date            : 2011-05-25 2:32 (19 days old)
> Message-ID      : <BANLkTimd6nvXTbn2hM+cKDNKFpxzsQLHog@mail.gmail.com>
> References      : http://marc.info/?l=linux-kernel&m=130629073407685&w=2
>
>
>

Not resolved, so should still be listed.

Changes since last test:
KDE-Version += 0.0.1 == 4.6.3
Only changes color/form of visible corruption, does not change X11 hang

With 2.6.39.1, leaving fullscreen XV creates heavy corruption, closing
mplayer lets X11 hang. Machine still alive, can be remote rebooted,
this makes it to the logs:
[drm] nouveau 0000:01:00.0: PGRAPH - DATA_ERROR INVALID_VALUE
[drm] nouveau 0000:01:00.0: PGRAPH - DATA_ERROR
[drm] nouveau 0000:01:00.0: PGRAPH - ch 2 (0x0000aa0000) subc 3 class
0x5039 mthd 0x0224 data 0x21949000
[drm] nouveau 0000:01:00.0: VM: trapped read at 0x002000f000 on ch 2
[0x00000aa0] PFIFO/PFIFO_READ/SEMAPHORE reason: DMAOBJ_LIMIT
[drm] nouveau 0000:01:00.0: PGRAPH - ILLEGAL_MTHD
[drm] nouveau 0000:01:00.0: PGRAPH - ch 2 (0x0000aa0000) subc 3 class
0x5039 mthd 0x0800 data 0x00000000
... (and so on)

With 3.0.0-rc2+ (git from hour ago), leaving fullscreen XV creates
heavy corruption, closing mplayer lets X11 "half-hang" (unusable, but
could switch to console, this is new), any other draw (opening the
KDE.Menu) lets it totally hang, machine still alive, could be remote
rebooted, this makes it to the logs:
[drm] nouveau 0000:01:00.0: PGRAPH - DATA_ERROR BEGIN_END_ACTIVE
[drm] nouveau 0000:01:00.0: PGRAPH - DATA_ERROR
[drm] nouveau 0000:01:00.0: PGRAPH - ch 2 (0x0000aa0000) subc 5 class
0x8297 mthd 0x1360 data 0x00000001
[drm] nouveau 0000:01:00.0: VM: trapped write at 0x002000f004 on ch 2
[0x00000aa0] PFIFO/PFIFO_READ/SEMAPHORE reason: DMAOBJ_LIMIT
[drm] nouveau 0000:01:00.0: PGRAPH - DATA_ERROR BEGIN_END_ACTIVE
[drm] nouveau 0000:01:00.0: PGRAPH - DATA_ERROR
[drm] nouveau 0000:01:00.0: PGRAPH - ch 2 (0x0000aa0000) subc 5 class
0x8297 mthd 0x1340 data 0x00008006
[drm] nouveau 0000:01:00.0: PGRAPH - DATA_ERROR BEGIN_END_ACTIVE

Greetings
Jan
