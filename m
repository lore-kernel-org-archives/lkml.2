Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755019Ab1BXIF3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 03:05:29 -0500
Received: from webbox687.server-home.net ([195.149.74.151]:47916 "EHLO
	webbox687.server-home.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754695Ab1BXIF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 03:05:27 -0500
From: Alexander Stein <alexander.stein@systec-electronic.com>
To: Wim Van Sebroeck <wim@iguana.be>
Subject: Re: [RFC] [PATCH 8/10] Generic Watchdog Timer Driver
Date: Thu, 24 Feb 2011 09:05:24 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.36-gentoo-r5; KDE/4.4.5; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <20110223204436.GA7465@infomag.iguana.be>
In-Reply-To: <20110223204436.GA7465@infomag.iguana.be>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102240905.24855.alexander.stein@systec-electronic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 23 February 2011, 21:44:36 Wim Van Sebroeck wrote:
> commit 5752d34c58c9b654c2fa753b94acc67602836420
> Author: Wim Van Sebroeck <wim@iguana.be>
> Date:   Sun Jul 18 10:51:52 2010 +0000
> 
>     watchdog: WatchDog Timer Driver Core - Part 8
> 
>     Add support for the nowayout feature to the
>     WatchDog Timer Driver Core framework.
>     This feature prevents the watchdog timer from being
>     stopped.
> 
>     Signed-off-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
>     Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
> 
> [...]
> diff --git a/Documentation/watchdog/watchdog-kernel-api.txt
> b/Documentation/watchdog/watchdog-kernel-api.txt index 036c30f..91c4299
> 100644
> --- a/Documentation/watchdog/watchdog-kernel-api.txt
> +++ b/Documentation/watchdog/watchdog-kernel-api.txt
> @@ -57,8 +57,8 @@ It contains following fields:
>    WDIOF_* status bits).
>  * status: this field contains a number of status bits that give extra
>    information about the status of the device (Like: is the watchdog timer
> -  running/active, is the device opened via the /dev/watchdog interface or
> not, -  ...)
> +  running/active, is the nowayout bit set, is the device opened via
> +  the /dev/watchdog interface or not, ...)
> 
>  The list of watchdog operations is defined as:
> 
> @@ -123,6 +123,8 @@ bit-operations. The status bit's that are defined are:
>    is active or not. When the watchdog is active after booting, then you
> should set this status bit (Note: when you register the watchdog timer
> device with this bit set, then opening /dev/watchdog will skip the start
> operation) +* WDOG_NO_WAY_OUT: this bit stores the nowayout setting for
> the watchdog. +  If this bit is set then the watchdog timer will not be
> able to stop. * WDOG_DEV_OPEN: this status bit shows whether or not the
> watchdog device was opened via /dev/watchdog.
>    (This bit should only be used by the WatchDog Timer Driver Core).
> @@ -135,6 +137,6 @@ bit-operations. The status bit's that are defined are:
>    has been sent (so that we can support the magic close feature).
>    (This bit should only be used by the WatchDog Timer Driver Core).
> 
> -Note: The WatchDog Timer Driver Core supports the magic close feauture. To
> use -the magic close feauture you must set the WDIOF_MAGICCLOSE bit in the
> options -field of the watchdog's info structure.
> +Note: The WatchDog Timer Driver Core supports the nowayout feature and the
> +magic close feauture. To use the magic close feauture you must set the
                  ^                                 ^
small typos here

Alexander
