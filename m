Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751906Ab1GRUku (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 16:40:50 -0400
Received: from void.printf.net ([89.145.121.20]:33340 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750752Ab1GRUks convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 16:40:48 -0400
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
Date: Mon, 18 Jul 2011 16:40:28 -0400
In-Reply-To: <alpine.DEB.2.02.1107181535250.1677@lazy> (Manoj Iyer's message
	of "Mon, 18 Jul 2011 15:36:38 -0500 (CDT)")
Message-ID: <m2zkkbb9vn.fsf@bob.laptop.org>
User-Agent: Gnus/5.110018 (No Gnus v0.18) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Manoj,

On Mon, Jul 18 2011, Manoj Iyer wrote:
> Here are the results with SanDisk SDSDXP1-016G-A75 16GB Extreme Pro
> SDHC Memory Card.
>
> u@u:~/flashbench$ sudo ./flashbench -a /dev/mmcblk0p1
> [sudo] password for u:
> align 4294967296        pre 1.16ms      on 1.15ms       post 1.15ms
> diff -2024ns
> align 2147483648        pre 1.2ms       on 1.2ms        post 1.2ms
> diff 522ns
> align 1073741824        pre 1.21ms      on 1.2ms        post 1.2ms
> diff 570ns
> align 536870912 pre 1.2ms       on 1.2ms        post 1.2ms      diff 662ns
> align 268435456 pre 1.2ms       on 1.2ms        post 1.2ms      diff 404ns
> align 134217728 pre 1.2ms       on 1.2ms        post 1.2ms      diff
> -1692ns
> align 67108864  pre 1.15ms      on 1.16ms       post 1.16ms     diff
> 1.37µs
> align 33554432  pre 1.18ms      on 1.19ms       post 1.15ms     diff
> 31.3µs
> align 16777216  pre 1.17ms      on 1.19ms       post 1.15ms     diff
> 31.5µs
> align 8388608   pre 1.17ms      on 1.21ms       post 1.18ms     diff
> 32.9µs
> align 4194304   pre 1.37ms      on 1.55ms       post 1.17ms     diff 274µs
> align 2097152   pre 1.37ms      on 1.37ms       post 1.39ms     diff
> -7992ns
> align 1048576   pre 1.33ms      on 1.33ms       post 1.34ms     diff
> -7793ns
> align 524288    pre 1.33ms      on 1.33ms       post 1.34ms     diff
> -6641ns
> align 262144    pre 1.34ms      on 1.38ms       post 1.35ms     diff
> 33.8µs
> align 131072    pre 1.35ms      on 1.37ms       post 1.34ms     diff
> 27.2µs
> align 65536     pre 1.34ms      on 1.37ms       post 1.34ms     diff
> 31.7µs
> align 32768     pre 1.33ms      on 1.37ms       post 1.34ms     diff
> 32.5µs
>
> u@u:~/flashbench$ sudo ./flashbench -O --erasesize=$[4 * 1024 * 1024]
> --blocksize=$[256 * 1024] /dev/mmcblk0p1 --open-au-nr=2
> 4MiB    23.2M/s
> 2MiB    23.6M/s
> 1MiB    23.5M/s
> 512KiB  23.2M/s
> 256KiB  23.2M/s
> u@u:~/flashbench$

I don't understand whether these measurements are before or after your
patch -- we're looking to see what the *difference* in performance is
with the patch applied, right?

Thanks,

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
