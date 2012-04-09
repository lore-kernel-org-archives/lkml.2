Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756400Ab2DINAl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 09:00:41 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:50818 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751701Ab2DINAj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 09:00:39 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Minchan Kim <minchan@kernel.org>
Subject: Re: swap on eMMC and other flash
Date: Mon, 9 Apr 2012 13:00:34 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: =?utf-8?q?=EC=A0=95=ED=9A=A8=EC=A7=84?= <syr.jeong@samsung.com>,
        "'Alex Lemberg'" <Alex.Lemberg@sandisk.com>,
        linaro-kernel@lists.linaro.org, "'Rik van Riel'" <riel@redhat.com>,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Luca Porzio (lporzio)'" <lporzio@micron.com>, linux-mm@kvack.org,
        kernel-team@android.com, "'Yejin Moon'" <yejin.moon@samsung.com>,
        "'Hugh Dickins'" <hughd@google.com>,
        "'Yaniv Iarovici'" <Yaniv.Iarovici@sandisk.com>, cpgs@samsung.com
References: <201203301744.16762.arnd@arndb.de> <006f01cd1623$ac4a2860$04de7920$%jeong@samsung.com> <4F8299B4.5090909@kernel.org>
In-Reply-To: <4F8299B4.5090909@kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201204091300.34304.arnd@arndb.de>
X-Provags-ID: V02:K0:FBIUlCRuscVa6pRcWvHAKSoTtg8rEP+WAXGqqgj5QL3
 qf8mSCcym4FRxGT87aoqSIEgH9k7vIOTO4DqaKSrFDxUSrHSw5
 5SxMiGrwl1PeJMLSHJCg90RENGx78cSyyizzU1T/rXilegfsNZ
 XefZJZqqGILEmqSV44lq0g29SA0wYgHvEQCLWa2TSmCPSGvIuf
 ZDnddYPnVdEZJiOXwjl+a6nhnVOKwIxfbFjSZRIkDQpWw61v5h
 IL8lydLL5pDoUfX0HMr3jJay/fY7eS/uzL6VnRV2tpxoqBrgIL
 TUVp4tT92y0CnFQg8E6Wa3h+ILxF1t64tF/lpKhWHupk/qq6di
 6VqX7jLAw44hlUu3LHmc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 09 April 2012, Minchan Kim wrote:
> > 
> > Regarding swap page size:
> > Actually, I can't guarantee the optimal size of different eMMC in the industry, because it depends on NAND page size an firmware implementation inside eMMC. In case of SAMSUNG eMMC, 8KB page size and 512KB block size(erase unit) is current implementation.
> > I think that the multiple of 8KB page size align with 512KB is good for SAMSUNG eMMC.
> > If swap system use 512KB page and issue Discard/Trim align with 512KB, eMMC make best performance as of today. However, large page size in swap partition may not best way in Linux system level.
> > I'm not sure that the best page size between Swap system and eMMC device.
> 
> 
> The variety is one of challenges for removing GC generally. ;-(.
> I don't like manual setting through /sys/block/xxx because it requires
> that user have to know nand page size and erase block size but it's not
> easy to know to normal user.
> Arnd. What's your plan to support various flash storages effectively?

My preference would be to build the logic to detect the sizes into mkfs
and mkswap and encode them in the superblock in new fields. I don't think
we can trust any data that a device reports right now because operating
systems have ignored it in the past and either someone has forgotten to
update the fields after moving to new technology (eMMC), or the data can
not be encoded correctly according to the spec (SD, USB).

System builders for embedded systems can then make sure that they get
it right for the hardware they use, and we can try our best to help
that process.

	Ard
