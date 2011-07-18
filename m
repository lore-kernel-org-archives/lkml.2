Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751153Ab1GRVFm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 17:05:42 -0400
Received: from void.printf.net ([89.145.121.20]:40406 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750954Ab1GRVFk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 17:05:40 -0400
From: Chris Ball <cjb@laptop.org>
To: Manoj Iyer <manoj.iyer@canonical.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        jbarnes@virtuousgeek.org, matsumur@nts.ricoh.co.jp,
        linux-pci@vger.kernel.org, linux-mmc@vger.kernel.org
Subject: Re: [PATCH] mmc: Added quirks for Ricoh 1180:e823 lower base clock frequency
References: <1310419715-13254-1-git-send-email-manoj.iyer@canonical.com>
	<m2sjqa2q93.fsf@bob.laptop.org>
	<alpine.DEB.2.02.1107131031360.3174@lazy>
	<201107131835.25217.arnd@arndb.de>
	<alpine.DEB.2.02.1107131144250.3174@lazy>
	<m21uxu2k96.fsf@bob.laptop.org>
	<alpine.DEB.2.02.1107131157440.3174@lazy>
	<m2wrfm1537.fsf@bob.laptop.org>
	<alpine.DEB.2.02.1107181535250.1677@lazy>
	<m2zkkbb9vn.fsf@bob.laptop.org>
	<alpine.DEB.2.02.1107181546100.1677@lazy>
Date: Mon, 18 Jul 2011 17:05:32 -0400
In-Reply-To: <alpine.DEB.2.02.1107181546100.1677@lazy> (Manoj Iyer's message
	of "Mon, 18 Jul 2011 15:47:33 -0500 (CDT)")
Message-ID: <m2d3h7b8pv.fsf@bob.laptop.org>
User-Agent: Gnus/5.110018 (No Gnus v0.18) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Manoj,

On Mon, Jul 18 2011, Manoj Iyer wrote:
> Right, without the patch I get..
>
> [   52.526665] mmc0: new SDHC card at address e624
> [   52.571228] mmcblk0: mmc0:e624 SD16G 14.8 GiB
> [   52.591071] mmcblk0: retrying using single block read
> [   52.593105] mmcblk0: error -84 transferring data, sector 0, nr 8,
> card status 0x900
> [   52.593109] end_request: I/O error, dev mmcblk0, sector 0
> [   52.594594] mmcblk0: error -84 transferring data, sector 1, nr 7,
> card status 0x900
> [   52.594604] end_request: I/O error, dev mmcblk0, sector 1
> [   52.602893] quiet_error: 24 callbacks suppressed
> [   52.602902] Buffer I/O error on device mmcblk0, logical block 0
> [   52.605349] ldm_validate_partition_table(): Disk read failed.
> [   52.605384] Dev mmcblk0: unable to read RDB block 0
> [   52.607729]  mmcblk0: unable to read partition table
> u@u:~$
>
> So, I cannot generate any comparison data with this SD card.

I see, thanks.  So we're lacking any data on what speed the card would
normally provide.  Perhaps you could try that card on a different
controller, just so we're able to see whether it's usually possible
to get closer to 45M/sec with it?

I think I'll take your patch as-is for 3.1 -- since if there is a
performance degradation, it's on cards that simply don't work at all
right now -- and if you're able to work on a followup patch that only
performs the clock-lowering after the first error, I think that'd be a
handy patch to have around.  Does that sound good?

Thanks!

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
