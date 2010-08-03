Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756045Ab0HCNYL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 09:24:11 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:58146 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752952Ab0HCNYJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 09:24:09 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Edgardo Hames <ehames@gmail.com>
Subject: Re: [PATCH] Staging: wlan-ng: remove typedef in p80211ioctl.h
Date: Tue, 3 Aug 2010 15:24:04 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: greg@kroah.com, linux-kernel@vger.kernel.org
References: <1280593762-23120-1-git-send-email-ehames@gmail.com>
In-Reply-To: <1280593762-23120-1-git-send-email-ehames@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201008031524.04730.arnd@arndb.de>
X-Provags-ID: V02:K0:bPTTKnFMtrYf2mb/KDW8WqCn6eqZEIx0KbkjyAwjA5v
 DsopyyGGpv472nlBLQLprLD3eloxf899dSgGXJSmzojR5VODtR
 JfnaPeWrzyOl1Z6L2EleIfg7o0XjGiLj2sRFSVqEhOrshtaM2k
 NxZORdL2vSgRk8OOeSFxW+5Lm4IWSfFSynOf02X7HIbCI0OfJm
 VMa92/a4V6zhz1Hujs+rA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 31 July 2010, Edgardo Hames wrote:
> 
> -typedef struct p80211ioctl_req {
> +struct p80211ioctl_req {
>         char name[WLAN_DEVNAMELEN_MAX];
>         caddr_t data;
>         u32 magic;
>         u16 len;
>         u32 result;
> -} __attribute__ ((packed)) p80211ioctl_req_t;
> +} __attribute__ ((packed));

BTW, this data structure is broken and needs fixing.
Putting a pointer in there means that it's incompatible
between 32 and 64 bit user space, among other problems.

The TODO list for this driver already contains "move to
use the in-kernel wireless stack", which should consequently
imply getting rid of this p80211knetdev_do_ioctl function, but
it may be useful to list that as a separate item.

	Arnd
