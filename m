Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755445Ab1GEPji (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 11:39:38 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:60892 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754771Ab1GEPjg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 11:39:36 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jonas Bonn <jonas@southpole.se>
Subject: Re: [PATCH v2 10/19] OpenRISC: System calls
Date: Tue, 5 Jul 2011 17:39:34 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
References: <1309641352-18714-1-git-send-email-jonas@southpole.se> <1309641352-18714-11-git-send-email-jonas@southpole.se>
In-Reply-To: <1309641352-18714-11-git-send-email-jonas@southpole.se>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201107051739.34242.arnd@arndb.de>
X-Provags-ID: V02:K0:WWYJBK+K/bChBJnNRWT1EaE6tW6QzpXJBaU0AkGoTmc
 u4CM426YfbDVilH+2R45l7fV+c/Jb7bBYmUxY4lTBw3nR/yqd6
 KGipKjODDcp3bqcx9tPOZt7Bgwv55DrHftirrFStl9bbo/YnPN
 PPvZ38AyG/5iTuHOQWl4xt8wTnJ481PeIVH7dmCjlVRCKguSgj
 mDQzW5x5fmCBkaq9jVZMw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 02 July 2011, Jonas Bonn wrote:
> +
> +asmlinkage long sys_mmap2(unsigned long addr, unsigned long len,
> +                         unsigned long prot, unsigned long flags,
> +                         unsigned long fd, unsigned long pgoff)
> +{
> +       return sys_mmap_pgoff(addr, len, prot, flags, fd, pgoff);
> +}
> +
> +asmlinkage long sys_mmap(unsigned long addr, unsigned long len,
> +                        unsigned long prot, unsigned long flags,
> +                        unsigned long fd, off_t pgoff)
> +{
> +       if (pgoff & ~PAGE_MASK)
> +               return -EINVAL;
> +
> +       return sys_mmap_pgoff(addr, len, prot, flags, fd, pgoff >> PAGE_SHIFT);
> +}

You shouldn't really need these two. Either provide just sys_mmap2,
or "#define sys_mmap2 sys_mmap_pgoff" and change your user implementation.

	Arnd
