Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753720Ab0GLUcU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 16:32:20 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:58403 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751628Ab0GLUcS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 16:32:18 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Uwe =?iso-8859-1?q?Kleine-K=F6nig?=" 
	<u.kleine-koenig@pengutronix.de>
Subject: Re: ARM defconfig files
Date: Mon, 12 Jul 2010 22:31:16 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-rc4-next-20100709+; KDE/4.4.90; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        Daniel Walker <dwalker@codeaurora.org>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Eric Miao <eric.miao@canonical.com>, linux-omap@vger.kernel.org,
        Nicolas Pitre <nico@fluxnic.net>
References: <alpine.LFD.2.00.1006030725420.8175@i5.linux-foundation.org> <AANLkTinxUqzxClVDTyruJ6kzFTganXUGJJHJ5wRi9Iak@mail.gmail.com> <20100712185029.GB14425@pengutronix.de>
In-Reply-To: <20100712185029.GB14425@pengutronix.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Message-Id: <201007122231.16283.arnd@arndb.de>
X-Provags-ID: V02:K0:exad8tQRAMX239unxlg6c27dMeEW6C+rQjIzndAbJpM
 GthfzmJiSzreq8ZBpTEVGNoNseWRjh72Q8k83XWIIS93XQ7X9q
 C/Z6Hcuq8x3aAj6dy+VFEivRcs3UpBzxvpQmtJMzVT7IwPkOpG
 je8fF6DvgtgjxTVoF6GOQVaa1NsrIHHqVGgDH2WICuT+r1lz5I
 U6ReJScvDhkPftueiNwMg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 12 July 2010 20:50:29 Uwe Kleine-König wrote:
> 
> [1] The following changes since commit 67a3e12b05e055c0415c556a315a3d3eb637e29e:
> 
>   Linux 2.6.35-rc1 (2010-05-30 13:21:02 -0700)
> 
> are available in the git repository at:
>   git://git.pengutronix.de/git/ukl/linux-2.6.git arm/defconfig/reduced-v2.6.35-rc1

BTW, looking at the most common entries in there, I think we might at some
point want to change some of the defaults in the respective Kconfig files.
Right now an empty defconfig would result in a configuration without
file system, networking or modules:

sort arch/arm/configs/* | uniq -c | sort -n | tail -n 30
    114 CONFIG_BLK_DEV_RAM=y
    116 CONFIG_BLK_DEV_INITRD=y
    116 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
    117 CONFIG_NFS_FS=y
    118 CONFIG_MTD_CHAR=y
    119 CONFIG_INOTIFY=y
    122 # CONFIG_BLK_DEV_BSG is not set
    122 CONFIG_IP_PNP=y
    123 # CONFIG_IPV6 is not set
    123 CONFIG_MTD_BLOCK=y
    125 CONFIG_FPE_NWFPE=y
    127 CONFIG_NET_ETHERNET=y
    128 CONFIG_LOG_BUF_SHIFT=14
    128 CONFIG_MTD=y
    131 CONFIG_PACKET=y
    132 # CONFIG_INPUT_MOUSE is not set
    133 CONFIG_DEBUG_KERNEL=y
    134 CONFIG_EXT2_FS=y
    138 CONFIG_MODULE_UNLOAD=y
    139 CONFIG_TMPFS=y
    142 CONFIG_NETDEVICES=y
    147 CONFIG_ZBOOT_ROM_BSS=0x0
    147 CONFIG_ZBOOT_ROM_TEXT=0x0
    151 CONFIG_INET=y
    151 CONFIG_UNIX=y
    153 CONFIG_NET=y
    156 # CONFIG_VGA_CONSOLE is not set
    158 CONFIG_MODULES=y
    164 CONFIG_SYSVIPC=y
    174 CONFIG_EXPERIMENTAL=y

Also, some of the defconfigs contain stuff that arguably does not belong
into a defconfig and could be removed in the next merge window, e.g.

ezx_defconfig:CONFIG_LOCALVERSION="-ezx200910312315"
pnx4008_defconfig:CONFIG_DECNET=m
at572d940hfek_defconfig:CONFIG_SGI_PARTITION=y

	Arnd
