Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116Ab2B0RbO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 12:31:14 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:54897 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753324Ab2B0RbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 12:31:13 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: Re: [GIT PULL] at91 first cleanup series for 3.4
Date: Mon, 27 Feb 2012 17:31:02 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: Olof Johansson <olof@lixom.net>,
        "Jean-Christophe PLAGNIOL-VILLARD" <plagnioj@jcrosoft.com>,
        "linux-arm-kernel" <linux-arm-kernel@lists.infradead.org>,
        Rob Herring <robherring2@gmail.com>,
        "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        Ryan Mallon <ryan@bluewatersys.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
References: <4F4674F2.8090603@atmel.com>
In-Reply-To: <4F4674F2.8090603@atmel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201202271731.03230.arnd@arndb.de>
X-Provags-ID: V02:K0:9KrIVYS7k28Ocben2BbN3KzReQQxZVmOVRxI63VePHJ
 VOCZv8seX5BJBuKb6OjeCpVQUTLF8xR012u1l6apCfq65vCMPz
 yu/qFSIzHXYDOYZYCY7d5Xk8qgEfovAS9iK1ynK1au2Tscz85R
 Z8L/HLwcRALCZqiYD3nzYL19lzjVkDa0KVHExFqIoBbvU7pKWY
 /YgAc5rlnyVpP5IfxeJCqlLqKk7O1WHBQJid+7asZUhz+cPpbs
 3P3OHzEMdAfV5+TZeoDnM1KUSX/EtCi20AnbveYGcj5V0/B0Zg
 Uj4T8s+dBGR5XqorfKkWWQXuseT1rvhM+nvREjSAhKbXlC2K4v
 +XxSv9XwEhP1UNIs3yNQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 23 February 2012, Nicolas Ferre wrote:
> This series removes the at91_sys_read/write() functions that where
> used for all System Controller devices. The static offsets that were
> used prevented us from compiling several AT91 SoC support in a single
> zImage.
> 
> The other cleanup is the move of some early console initialization. In
> addition, some Makefile.boot modifications have been performed to be
> able to make .dtb files.
> 
> All this goes on top of current material that is already in arm-soc
> git tree (merge of all at91/* branches. You can find it in the same git
> tree with at91-3.4-base2 branch name).
> 
> 
> The following changes since commit 11a25ea7e4f870a37093258f577e11cec703e37e:
> 
>   Merge remote-tracking branch 'armsoc/at91/9x5' into at91-3.4-base2 (2012-02-11 14:33:03 +0100)
> 
> are available in the git repository at:
> 
> 
>   git://github.com/at91linux/linux-at91.git at91-3.4-base2+cleanup

Hi Nicolas,

I cannot merge this into the next/cleanup branch because you have based it
on top of a non-cleanup branch. There are three ways out of this:

1. rebase the entire branch on a changeset that only contains upstream and
cleanup branches, and let me deal with merge conflicts against the at91/9x5
branch.

2. Split this series into two parts, with the simple cleanups going directly
in as in 1, but cleanups on top of the at91/9x5 branch get applied to that
branch only.

3. Create a new next/cleanup2 branch with this pull request that I submit
to Linus separately from the other cleanups.

Which one should it be?

I'm also still not entirely happy with the contents because the newly
introduced macros all still use __raw_readl() instead of readl_relaxed(),
and because the rtt setup appears unnecessarily complex while at the same
time still not sufficient for a combined at91 kernel. It would be nice
if those could be fixed, but I would still take the series without changing
the rtt code because we have not really come to a conclusion otherwise
and the series generally moves things into the right direction.

I've applied your series to the staging/cleanup branch for now, which
means it gets into linux-next but I won't send to Linus unless I get
an update.

	Arnd
