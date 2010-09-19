Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754799Ab0ISUXy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Sep 2010 16:23:54 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:35765 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752021Ab0ISUXx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Sep 2010 16:23:53 -0400
X-Authenticated: #57309416
X-Provags-ID: V01U2FsdGVkX1+bq6gRrXGbn4TiiQ/3bnh5TAuheVyrTsb0UHUEFo
	gtuwg8RqJbhUaz
Date: Sun, 19 Sep 2010 22:23:46 +0200
From: Lukas =?iso-8859-1?Q?Gr=E4sslin?= <lukasgraesslin@gmx.de>
To: Norbert Preining <preining@logic.at>
Cc: linux-kernel@vger.kernel.org
Subject: Re: changing the default cpufreq governor freezes laptop on suspend
Message-ID: <20100919202331.GA27077@home-server.graesslin.de>
References: <20100723011514.GD19985@gamma.logic.tuwien.ac.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100723011514.GD19985@gamma.logic.tuwien.ac.at>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Are there any news? I have exactly the same problem with stable 2.6.35.

It's not so a dramatic bug because the workaround (settings that
temporarily govenor in the pm-utils script to something that does not
exist, which means it is skipped) is ok and has actually no byeffects,
but it would still be nice to have that fixed :)

On Fri, Jul 23, 2010 at 10:15:14AM +0900, Norbert Preining wrote:
> Dear all,
> 
> (please Cc)
> 
> some time ago I switched from 2.6.35-rc1 to -rc2 and about the same time
> I regularly got problems with suspend to ram. I first thought that this
> is a graphics card issue 
> (see http://marc.info/?l=linux-kernel&m=127582534931581&w=2)
> but it turned out that using echo mem > /sys/power/state works very
> reliable.
> 
> I finally got around to check the scripts of pm-utils managing the
> suspend process here on Debian/sid, and I found that one of the
> scripts, before going to sleep, changes the default cpufreq governor
> to performance, doing in principle:
> 	cat /sys/devices/system/cpu/cpuN/cpufreq/scaling_governor > savedstate
> 	echo "performance" > /sys/.....
> Interestingly, as soon as I disabled these two line the suspend process
> became again as stable as before using pm-utils, and as stable as the
> echo mem method.
> 
> My laptop is intel core2:
> Intel(R) Core(TM)2 Duo CPU     P9500  @ 2.53GHz
> running Debian/sid, on self compiled git kernels pulled from Linus' repo.
> 
> Please let me know what further information I can provide, or how to help
> 
> Best wishes
> 
> Norbert
> ------------------------------------------------------------------------
> Norbert Preining            preining@{jaist.ac.jp, logic.at, debian.org}
> JAIST, Japan                                 TeX Live & Debian Developer
> DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
> ------------------------------------------------------------------------
> CLOVIS (q.v.)
> One who actually looks forward to putting up the Christmas decorations
> in the office.
> 			--- Douglas Adams, The Meaning of Liff
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 

-- 
Lukas Grässlin
GnuPG-Key: http://lg.ath.cx/lukasgraesslin@gmx.de.asc
