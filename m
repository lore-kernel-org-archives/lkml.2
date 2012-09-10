Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756741Ab2IJJPy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 05:15:54 -0400
Received: from mail.skyhub.de ([78.46.96.112]:46767 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752758Ab2IJJPv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 05:15:51 -0400
Date: Mon, 10 Sep 2012 11:15:46 +0200
From: Borislav Petkov <bp@alien8.de>
To: Adko Branil <adkobranil@yahoo.com>
Cc: Mikael Pettersson <mikpe@it.uu.se>, Jeff Garzik <jgarzik@pobox.com>,
        linux-ide <linux-ide@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Dan Merillat <dan.merillat@gmail.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: HDD problem, software bug, bios bug, or hardware ?
Message-ID: <20120910091546.GA4431@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Adko Branil <adkobranil@yahoo.com>,
	Mikael Pettersson <mikpe@it.uu.se>, Jeff Garzik <jgarzik@pobox.com>,
	linux-ide <linux-ide@vger.kernel.org>,
	lkml <linux-kernel@vger.kernel.org>,
	Dan Merillat <dan.merillat@gmail.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>
References: <1345901771.8871.YahooMailNeo@web124706.mail.ne1.yahoo.com>
 <20120826130152.GA20021@liondog.tnic>
 <1346086872.65665.YahooMailNeo@web124704.mail.ne1.yahoo.com>
 <20120827215952.GA18719@liondog.tnic>
 <1346259574.81504.YahooMailNeo@web124706.mail.ne1.yahoo.com>
 <20120830095808.GB24680@liondog.tnic>
 <1346325007.23643.YahooMailNeo@web124706.mail.ne1.yahoo.com>
 <20547.48101.900727.735398@pilspetsen.it.uu.se>
 <1347017576.44763.YahooMailNeo@web124703.mail.ne1.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1347017576.44763.YahooMailNeo@web124703.mail.ne1.yahoo.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 07, 2012 at 04:32:56AM -0700, Adko Branil wrote:
> After updating bios no more crashes happened, i tested it many times
> on heavy HDD IO loads, with many kernels (including CONFIG_PREEMPT
> kernels).

Alriiight, one of the most seldom times where a BIOS update actually
fixes things :-).

> But now if enable "Cool'n' Quiet" option in bios, 
> CONFIG_PREEMPT_VOLUNTARY kernel with passed "nosmp" at boot time,
> crashes during boot process with kernel panic, while  CONFIG_PREEMPT
> kernlel without "nosmp" works fine  - but it is another story i
> think, should not be related with the crashes when it was old bios,
> and i think it is probably "nosmp" the reason.

Hmm, Cool'n'Quiet enabled actually means that you have _PSS objects and
powernow-k8 should be detecting the P-states properly.

Can you catch dmesg from that machine twice?

* one with Cool'n'Quiet disabled
* one with the kernel panic

> (i have never changed cpu frequency of this cpu at all) When "Cool'n'
> Quiet" is disabled, the system works perfectly adequately with all
> kind of kernels i tried. Except that this warning message in dmesg
> still appears (if it is problem at all). I put here this message for
> "nosmp" case as well, kernel is 3.5.2:

Right, so AFAICU, you can run a CONFIG_PREEMPT kernel perfectly fine now
after the BIOS update, right?

If so and when you say that the oopses started happening after an
electrical instability, I'd venture a guess that something got damaged
in the BIOS EPROM and since you've flashed it anew, the corrupted data
got overwritten and so no more crashes. Correct?

-- 
Regards/Gruss,
    Boris.
