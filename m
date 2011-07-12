Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754572Ab1GLRax (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 13:30:53 -0400
Received: from void.printf.net ([89.145.121.20]:36373 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754251Ab1GLRaw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 13:30:52 -0400
From: Chris Ball <cjb@laptop.org>
To: Manoj Iyer <manoj.iyer@canonical.com>
Cc: linux-kernel@vger.kernel.org, jbarnes@virtuousgeek.org,
        matsumur@nts.ricoh.co.jp, linux-pci@vger.kernel.org,
        linux-mmc@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] mmc: Added quirks for Ricoh 1180:e823 lower base clock frequency
References: <1310419715-13254-1-git-send-email-manoj.iyer@canonical.com>
	<1310419715-13254-2-git-send-email-manoj.iyer@canonical.com>
	<m2wrfofpro.fsf@bob.laptop.org>
	<alpine.DEB.2.02.1107121050480.1767@lazy>
	<m2ipr779oe.fsf@bob.laptop.org>
	<alpine.DEB.2.02.1107121123140.1767@lazy>
Date: Tue, 12 Jul 2011 13:30:42 -0400
In-Reply-To: <alpine.DEB.2.02.1107121123140.1767@lazy> (Manoj Iyer's message
	of "Tue, 12 Jul 2011 12:09:10 -0500 (CDT)")
Message-ID: <m2ei1v76f1.fsf@bob.laptop.org>
User-Agent: Gnus/5.110018 (No Gnus v0.18) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Jul 12 2011, Manoj Iyer wrote:
> btw only the 1st write was slower, subsequent writes looks ok.
> [..]
> I have attached the output of flashbench and the time test to
>
> http://launchpad.net/bugs/773524
> [..]
> == Finding the number of open erase blocks ==
> u@u:~/flash/flashbench$ sudo ./flashbench -O --erasesize=$[4 * 1024 *
> 1024] --blocksize=$[256 * 1024] /dev/mmcblk0  --open-au-nr=2
> 4MiB    6.36M/s
> 2MiB    6.24M/s
> 1MiB    6.17M/s
> 512KiB  6.19M/s
> 256KiB  6.22M/s
> u@u:~/flash/flashbench$
> [..]
> ====== AFTER PATCH ========
> [..]
> == Finding the number of open erase blocks ==
> u@u:~/flash/flashbench$ sudo ./flashbench -O --erasesize=$[4 * 1024 *
> 1024]         --blocksize=$[256 * 1024] /dev/mmcblk0  --open-au-nr=2
> [sudo] password for u:
> 4MiB    5.49M/s
> 2MiB    6.22M/s
> 1MiB    6.22M/s
> 512KiB  6.21M/s
> 256KiB  6.21M/s
> u@u:~/flash/flashbench$

That's interesting.  Arnd, any idea why only the first test of the
flashbench run would be slower after the patch?

Thanks,

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
