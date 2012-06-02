Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759264Ab2FBPvt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2012 11:51:49 -0400
Received: from zose-mta11.web4all.fr ([178.33.204.87]:43237 "EHLO
	zose-mta11.web4all.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758207Ab2FBPvs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2012 11:51:48 -0400
X-Greylist: delayed 347 seconds by postgrey-1.27 at vger.kernel.org; Sat, 02 Jun 2012 11:51:48 EDT
Date: Sat, 2 Jun 2012 17:50:13 +0200 (CEST)
From: =?utf-8?Q?Beno=C3=AEt_Th=C3=A9baudeau?= 
	<benoit.thebaudeau@advansee.com>
To: Pawel Moll <pawel.moll@arm.com>, Rusty Russell <rusty@rustcorp.com.au>,
        Artem Bityutskiy <dedekind1@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org,
        benoit thebaudeau <benoit.thebaudeau@advansee.com>
Message-ID: <1626541056.1882643.1338652213722.JavaMail.root@advansee.com>
In-Reply-To: <1170056063.1844670.1338571611538.JavaMail.root@advansee.com>
Subject: Re: init: multi param parsing regression since 3.4
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [88.172.188.148]
X-Mailer: Zimbra 7.2.0_GA_2669 (ZimbraWebClient - FF3.0 (Win)/7.2.0_GA_2669)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

On Fri, Jun 1, 2012 at 7:26:51PM +0200, Benoît Thébaudeau wrote:
> Hi Pawel, Rusty, all,
> 
> Since linux 3.4 (OK with 3.3.6), I get the following regression for
> UBI (built
> in kernel):
> [    1.327228] UBI: attaching mtd4 to ubi0
> [    1.331082] UBI: physical eraseblock size:   131072 bytes (128
> KiB)
> [    1.337388] UBI: logical eraseblock size:    129024 bytes
> [    1.342794] UBI: smallest flash I/O unit:    2048
> [    1.347518] UBI: sub-page size:              512
> [    1.352144] UBI: VID header offset:          512 (aligned 512)
> [    1.357996] UBI: data offset:                2048
> [    1.538686] UBI: max. sequence number:       456
> [    1.551271] UBI: attached mtd4 to ubi0
> [    1.555085] UBI: MTD device name:            "rootfs"
> [    1.560147] UBI: MTD device size:            123 MiB
> [    1.565133] UBI: number of good PEBs:        980
> [    1.569757] UBI: number of bad PEBs:         4
> [    1.574206] UBI: number of corrupted PEBs:   0
> [    1.578669] UBI: max. allowed volumes:       128
> [    1.583293] UBI: wear-leveling threshold:    4096
> [    1.588015] UBI: number of internal volumes: 1
> [    1.592465] UBI: number of user volumes:     1
> [    1.596927] UBI: available PEBs:             0
> [    1.601377] UBI: total number of reserved PEBs: 980
> [    1.606273] UBI: number of PEBs reserved for bad PEB handling: 9
> [    1.612288] UBI: max/mean erase counter: 3/1
> [    1.616576] UBI: image sequence number:  1970526931
> [    1.621483] UBI: background thread "ubi_bgt0d" started, PID 32
> [    1.627362] UBI error: ubi_init: cannot attach mtd4
> 
> After some debugging, I found that this is caused by "ubi.mtd=rootfs"
> in my
> kernel command line being parsed twice while appearing once in this
> line.
> 
> The root cause is "parse_args(initcall_level_names[level], ..." that
> you added
> to init/main.c in commit #026cee0086fe1df4cf74691cf273062cc769617d,
> because
> level 0 is shared by "Booting kernel" and "early parameters".
> 
> This may also cause issues for other modules.
> 
> Should "parse_args("Booting kernel", ..." have been removed with your
> commit?
> 
> OR
> 
> Should do_initcall_level() call parse_args() starting at level 1?
> 
> OR
> 
> Should the UBI module register to another level?
> 
> OR
> 
> It doesn't matter and it's up to the modules to be robust to multi
> param
> parsing?

I forgot to mention that the only consequence for UBI is a spurious error
message: The MTD device is correctly attached the 1st time, and the extra
attachment attempt is simply discarded with this message. This might be worse
for other modules.

Regards,
Benoît

(Please keep me Cc'ed: benoit dot thebaudeau at advansee dot com)
