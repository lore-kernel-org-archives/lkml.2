Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754756Ab1FSUMQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jun 2011 16:12:16 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:56428 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754686Ab1FSUMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jun 2011 16:12:14 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] USB: ehci: use packed,aligned(4) instead of removing the packed attribute
Date: Sun, 19 Jun 2011 22:11:00 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc1nosema+; KDE/4.6.3; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>, Nicolas Pitre <nico@fluxnic.net>,
        gregkh@suse.de, linux-usb@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>, Rabin Vincent <rabin@rab.in>,
        Alexander Holler <holler@ahsoftware.de>
References: <Pine.LNX.4.44L0.1106191453200.14586-100000@netrider.rowland.org> <201106192202.23989.arnd@arndb.de>
In-Reply-To: <201106192202.23989.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106192211.01076.arnd@arndb.de>
X-Provags-ID: V02:K0:zDFIAJGe3WBUFtJmTrFg+dXUKFxu/N4EEPprVBbzhpq
 G5pwViln91szGtefUvdeG1YqD4H0YvmXDPLmCx+eo1W/cN7T9n
 wgLTGnkpw4zpNE+D4qxNlJAruM93KEyDdvh+dSx/qBz8tUIpfG
 haTUmhw/Hbw38ghxc+h/VEr0qaAs8BPixRiy2vX4irvpF9Kc/x
 O5tvnRCooQjMWtrJq+AFA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 19 June 2011 22:02:23 Arnd Bergmann wrote:
> In this case, we would have to do
> 
> struct s {
>         char c[2];
> } __packed;
> 
> struct t {
>         struct s t1;
>         unsigned short t2[3] __aligned(2);
> } __packed;
> 
> To tell the compiler that t2 is indeed aligned, while struct t
> is packed to include no padding around t.
>  
> I actually recently stumbled over code that gets this wrong,
> see
> 
> http://git.kernel.org/?p=linux/kernel/git/arnd/playground.git;a=commit;h=284cef173aafd531a708f48e71a9cc7249fc8a98
> 

Just to be clear: none of the ehci structures fall into this category.
I would assume that we actually have a few more drivers with this
bug in the kernel, but the patch proposed by Alexander would not
help with this problem, and the EHCI driver is still correct without
__packed.

	Arnd
