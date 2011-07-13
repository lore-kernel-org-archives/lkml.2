Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756412Ab1GMQfd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 12:35:33 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:51299 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756323Ab1GMQfb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 12:35:31 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Manoj Iyer <manoj.iyer@canonical.com>
Subject: Re: [PATCH] mmc: Added quirks for Ricoh 1180:e823 lower base clock frequency
Date: Wed, 13 Jul 2011 18:35:25 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Chris Ball <cjb@laptop.org>, linux-kernel@vger.kernel.org,
        jbarnes@virtuousgeek.org, matsumur@nts.ricoh.co.jp,
        linux-pci@vger.kernel.org, linux-mmc@vger.kernel.org
References: <1310419715-13254-1-git-send-email-manoj.iyer@canonical.com> <m2sjqa2q93.fsf@bob.laptop.org> <alpine.DEB.2.02.1107131031360.3174@lazy>
In-Reply-To: <alpine.DEB.2.02.1107131031360.3174@lazy>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201107131835.25217.arnd@arndb.de>
X-Provags-ID: V02:K0:S/9Mx7pSZ5f97Fe7dlHIJdo2c316N0TymH5Q0/d6AxU
 SvzZXE2e7MHJjAArY/oAhazBeIzkc8degc4wXS9RzUVr1gzuEf
 5cLNuXd00nRnNaqYTL80H6kamGde9IAZ00glVUbCbCrEVXcE55
 R5RGZzRL5OSmNQ+eXCSC/6iQcoUQIYHBHCeDyHUGsScLxuAZ29
 mbv4ROU5dWlxwtitXsL7g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 13 July 2011, Manoj Iyer wrote:
> 
> Chris/Arnd,
> 
> Here is a series of test I did with the patched kernel.

> == cold boot insert SD card ==
> u@u:~/flash/flashbench$ sudo ./flashbench -O --erasesize=$[4 * 1024 * 
> 1024] --blocksize=$[256 * 1024] /dev/mmcblk0  --open-au-nr=2
> 4MiB    4.96M/s
> 2MiB    6.3M/s
> 1MiB    6.23M/s
> 512KiB  6.23M/s
> 256KiB  6.26M/s

The very first one obviously triggers a garbage collection.
Everything after that is well within measuring accuracy around 6.25MB/s

> On Wed, 13 Jul 2011, Chris Ball wrote:

> >
> > That makes sense.  Do you think this explains Manoj getting a slower
> > first file copy speed (757ms vs. 480ms) after applying his patch?
> > (Manoj, perhaps you could retry your test without GC being needed?)

Yes. For a single sample, it can easily explain differences up to 500ms.
You have to average out file system benchmarks across a lot of files
to be sure.

> > What would we expect lowering the SD base clock frequency from 200MHz
> > to 50MHz to do to performance theoretically?

Not much. This card only has a 6MB/s write speed, which is well below
what a 50 MHz bus can do. It mgiht be different on a fast eMMC device
or a Sandisk Extreme Pro UHS-1 card.

	Arnd
