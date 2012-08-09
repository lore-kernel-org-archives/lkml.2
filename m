Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756086Ab2HIHeQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 03:34:16 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:60121 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752120Ab2HIHeO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 03:34:14 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Bryan Wu <bryan.wu@canonical.com>
Subject: Re: [PATCH 10/10] leds: renesas: fix error handling
Date: Thu, 9 Aug 2012 07:34:03 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, arm@kernel.org,
        linux-kernel@vger.kernel.org, Magnus Damm <damm@opensource.se>
References: <1344461278-28245-1-git-send-email-arnd@arndb.de> <1344461278-28245-11-git-send-email-arnd@arndb.de> <CAK5ve-LXaA1xi5NDWTUxeVnr6DpDFv4LMzx0knHvO=1bzJO9jQ@mail.gmail.com>
In-Reply-To: <CAK5ve-LXaA1xi5NDWTUxeVnr6DpDFv4LMzx0knHvO=1bzJO9jQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201208090734.04087.arnd@arndb.de>
X-Provags-ID: V02:K0:aJAJhw29ZZeN26sF5qTcghLp1mvDhBNZaFabqv0KWJp
 Mi77rh8/ORPS+u4pU0XyryfLgTGxskjf2z8fNWE3bU/3fJmMdx
 XL4AfVk+Ek8EkDRrd3c16LNS8/3mkzWuPDI4HeTvZVLqGRjhjK
 922nFXHdW77Fto8RdtwHXU7hSm9onFX1fcCKE5pgTO4ZPM8n23
 ODAJG1jNQkyhpUoVYQEX3z5scGO0FtG1VLzOd9tNV0flkbRu2G
 rKAcOZeIe/K0YSxo76JiK8iFC8imVPmg7+Fg1WLB0gBJyE+PMW
 TahB+zk3Yy7C7Hvjo50VxefE1ictLVE/34EqFPvDXlNwtrTL+F
 ndzMiQnFdgwhHtV30UG0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 09 August 2012, Bryan Wu wrote:
> 
> On Thu, Aug 9, 2012 at 5:27 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> > bfe4c041 "leds: convert Renesas TPU LED driver to devm_kzalloc() and
> > cleanup error exit path" introduced a possible case in which r_tpu_probe
> > calls iounmap on a wild pointer. This changes the one case that was
> > missed in the same way as the other error paths.
> >
> > Without this patch, building kota2_defconfig results in:
> >
> > drivers/leds/leds-renesas-tpu.c: In function 'r_tpu_probe':
> > drivers/leds/leds-renesas-tpu.c:246:6: warning: 'ret' may be used uninitialized in this function [-Wuninitialized]
> > drivers/leds/leds-renesas-tpu.c:308:17: warning: 'p' may be used uninitialized in this function [-Wuninitialized]
> >
> 
> Thanks, Arnd. If you don't mind, I will apply this fixing through my led tree.
> 

Ok, excellent. One less patch for me to worry about. Dropped from my tree now.

	Arnd
