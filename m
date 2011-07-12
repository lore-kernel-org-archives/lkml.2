Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068Ab1GLQU3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 12:20:29 -0400
Received: from void.printf.net ([89.145.121.20]:49568 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753941Ab1GLQU1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 12:20:27 -0400
From: Chris Ball <cjb@laptop.org>
To: Manoj Iyer <manoj.iyer@canonical.com>
Cc: linux-kernel@vger.kernel.org, jbarnes@virtuousgeek.org,
        matsumur@nts.ricoh.co.jp, linux-pci@vger.kernel.org,
        linux-mmc@vger.kernel.org
Subject: Re: [PATCH] mmc: Added quirks for Ricoh 1180:e823 lower base clock frequency
References: <1310419715-13254-1-git-send-email-manoj.iyer@canonical.com>
	<1310419715-13254-2-git-send-email-manoj.iyer@canonical.com>
	<m2wrfofpro.fsf@bob.laptop.org>
	<alpine.DEB.2.02.1107121050480.1767@lazy>
Date: Tue, 12 Jul 2011 12:20:17 -0400
In-Reply-To: <alpine.DEB.2.02.1107121050480.1767@lazy> (Manoj Iyer's message
	of "Tue, 12 Jul 2011 11:01:15 -0500 (CDT)")
Message-ID: <m2ipr779oe.fsf@bob.laptop.org>
User-Agent: Gnus/5.110018 (No Gnus v0.18) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Manoj,

On Tue, Jul 12 2011, Manoj Iyer wrote:
> Test System: ThinkPad X220 Tablet, using Sandisk 2GB Class 2 SD, I did
> not see any considerable change in read/write times. Also, tested a
> Transcend MMCPlus 2GB card, before the patch was applied it would not
> mount the card, and would cause IO errors on read/write, but after the
> patch it mounts and works correctly.
> [..]
> ============ BEFORE THE PATCH ===============
> Sandisk 2GB Class2 SD
> =============================================
> === WRITE ===
> u@u:~$ ls -lh test.file
> -rw-r--r-- 1 u u 10M 2011-07-12 10:19 test.file
> u@u:~$ time cp test.file /media/E0FD-1813/copyto
>
> real    0m0.480s
> user    0m0.000s
> sys     0m0.024s
> [..]
> ============ AFTER THE PATCH =============
> Sandisk 2GB Class2 SD
> ==========================================
>
> === WRITE ===
> u@u:~$ time cp ./test.file /media/E0FD-1813/copyto1
>
> real    0m0.757s
> user    0m0.000s
> sys     0m0.044s

This suggests that there *was* a considerable difference in write speed, no?

It might be helpful to use Arnd's flashbench tool¹ for further benchmarking,
since it does the right thing with using direct I/O access without caches.

Thanks,

- Chris.

¹: http://git.linaro.org/gitweb?p=people/arnd/flashbench.git
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
