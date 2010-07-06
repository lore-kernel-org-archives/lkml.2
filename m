Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754872Ab0GFP6j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 11:58:39 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:39680 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753912Ab0GFP6h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 11:58:37 -0400
Message-ID: <4C335291.8080401@oracle.com>
Date: Tue, 06 Jul 2010 08:58:09 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Masayuki Ohtak <masa-korg@dsn.okisemi.com>
CC: Arnd Bergmann <arnd@arndb.de>, "Wang, Yong Y" <yong.y.wang@intel.com>,
       qi.wang@intel.com, joel.clark@intel.com,
       andrew.chih.howe.khor@intel.com, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Packet hub driver of Topcliff PCH
References: <4C204B0D.2030201@dsn.okisemi.com> <4C3187A3.10407@dsn.okisemi.com>
In-Reply-To: <4C3187A3.10407@dsn.okisemi.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A0B0201.4C33529C.00EE:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/05/10 00:20, Masayuki Ohtak wrote:
> Hi Randy
> 
> I have modified for your comments.
> Please confirm below.

Agreed, thanks for the updates.

> Thanks, Ohtake.
> 
> ---
> 
> Packet hub driver of Topcliff PCH
> 
> Topcliff PCH is the platform controller hub that is going to be used in
> Intel's upcoming general embedded platform. All IO peripherals in
> Topcliff PCH are actually devices sitting on AMBA bus. Packet hub is
> a special converter device in Topcliff PCH that translate AMBA transactions
> to PCI Express transactions and vice versa. Thus packet hub helps present
> all IO peripherals in Topcliff PCH as PCIE devices to IA system.
> Topcliff PCH has MAC address and Option ROM data.
> These data are in SROM which is connected to PCIE bus.
> Packet hub driver of Topcliff PCH can access MAC address and Option ROM data in
> SROM.
> 
> Signed-off-by: Masayuki Ohtake <masa-korg@dsn.okisemi.com>
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> 
> ---
>  Documentation/ioctl/ioctl-number.txt |    1 +
>  drivers/char/Kconfig                 |    9 +
>  drivers/char/Makefile                |    2 +
>  drivers/char/pch_phub/Makefile       |    3 +
>  drivers/char/pch_phub/pch_phub.c     |  803 ++++++++++++++++++++++++++++++++++
>  drivers/char/pch_phub/pch_phub.h     |   48 ++
>  6 files changed, 866 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/char/pch_phub/Makefile
>  create mode 100755 drivers/char/pch_phub/pch_phub.c
>  create mode 100755 drivers/char/pch_phub/pch_phub.h
> 
> diff --git a/Documentation/ioctl/ioctl-number.txt b/Documentation/ioctl/ioctl-number.txt
> index 35cf64d..b700b17 100644
> --- a/Documentation/ioctl/ioctl-number.txt
> +++ b/Documentation/ioctl/ioctl-number.txt
> @@ -320,4 +320,5 @@ Code  Seq#(hex)	Include File		Comments
>  					<mailto:thomas@winischhofer.net>
>  0xF4	00-1F	video/mbxfb.h		mbxfb
>  					<mailto:raph@8d.com>
> +0xF7	00-0F	drivers/char/pch_phub/pch_phub.h	PCH Phub driver
>  0xFD	all	linux/dm-ioctl.h



-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
