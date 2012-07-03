Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755242Ab2GCMf4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 08:35:56 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:46853 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752467Ab2GCMfz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 08:35:55 -0400
Date: Tue, 3 Jul 2012 13:35:52 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, arnd@arndb.de, sameo@linux.intel.com
Subject: Re: [PATCH 1/1] mfd: Fix runtime warning caused by duplicate
 device registration
Message-ID: <20120703123552.GC25995@sirena.org.uk>
References: <1341316788-12730-1-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1341316788-12730-1-git-send-email-lee.jones@linaro.org>
X-Cookie: No purchase necessary.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 03, 2012 at 12:59:48PM +0100, Lee Jones wrote:
> We register the ab8500 as an MFD device from db8500 code during Device Tree
> boot in order to solve some limitations of DT. However, when Device Tree is
> not enabled, we still want to allow platform code to register the ab8500 in
> the normal way. Here we force MFD device registration of the ab8500 only
> when booting with Device Tree enabled.
> 
> Solves this issue:
> WARNING: at fs/sysfs/dir.c:526 sysfs_add_one+0x88/0xb0()
> sysfs: cannot create duplicate filename '/bus/platform/devices/ab8500-core.0'

Do we really want to create MFD cells like this (which are really Linux
internal things and might vary if another OS or another version of Linux
changes its internal abstractions) from the device tree?
