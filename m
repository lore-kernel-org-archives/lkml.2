Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757574Ab2KVU4d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 15:56:33 -0500
Received: from void.printf.net ([89.145.121.20]:43329 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756134Ab2KVS6a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:58:30 -0500
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
Date: Wed, 21 Nov 2012 19:29:46 -0500
In-Reply-To: <alpine.DEB.2.02.1107181546100.1677@lazy> (Manoj Iyer's message
	of "Mon, 18 Jul 2011 15:47:33 -0500 (CDT)")
Message-ID: <87obiqa39h.fsf@octavius.laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Manoj, Matsumuro-san,

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

I don't know if you remember this bug, but I have reports from two users
who see "error -84"s on :e823 controllers even with this patch active on
modern ThinkPads.

Maybe 50MHz isn't low enough sometimes?  Is it possible to lower the base
clock further?

I noticed that the frequency is encoded ine one of the PCI writes:
+        * 0x32  - 50Mhz new clock frequency

So if I get access to one of these systems, I might try lowering that
value (by half, say) and see what happens.  But at the moment I haven't
found someone who's willing to try kernel patches yet, and I don't have
one of these systems myself.

Thanks!

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
