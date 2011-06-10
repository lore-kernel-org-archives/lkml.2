Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753606Ab1FJQlv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 12:41:51 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:55509 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751622Ab1FJQls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 12:41:48 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Chris Metcalf <cmetcalf@tilera.com>
Subject: Re: [PATCH v3] arch/tile: add hypervisor-based character driver for SPI flash ROM
Date: Fri, 10 Jun 2011 18:41:27 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Greg KH <gregkh@suse.de>,
        Eric Biederman <ebiederm@aristanetworks.com>,
        Chris Wright <chrisw@sous-sol.org>,
        Benjamin Thery <benjamin.thery@bull.net>,
        Phil Carmody <ext-phil.2.carmody@nokia.com>
References: <201105281516.p4SFGfHg024703@farm-0010.internal.tilera.com> <BANLkTim-d-8w1_idg4u302aB3MqTo7q4Sg@mail.gmail.com> <201106021510.p52FAlmb028120@farm-0023.internal.tilera.com>
In-Reply-To: <201106021510.p52FAlmb028120@farm-0023.internal.tilera.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201106101841.27771.arnd@arndb.de>
X-Provags-ID: V02:K0:xoAFqYx/on/G4RVqTPv8zjSfs0MXzOCeOnL8wwsM7e/
 xXJBLPphCrS2GqrM9FSFpX64vtYb7nGlrJPGKOTCnCAEA1DWUN
 WF1bD31BkHsJrnJIrcc6FIODTdIvdxjRiZdS11vSql+MRL84A+
 5+0uBLnBkcnt6xQ0wHDWOJX/c9FpQelS+69MAzh0VOARkDdbmy
 Iy58+/KgvKtllGBWN/sZw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 02 June 2011, Chris Metcalf wrote:
> The first version of this patch proposed an arch/tile/drivers/ directory,
> but the consensus was that this was probably a poor choice for a place to
> group Tilera-specific drivers, and that in any case grouping by platform
> was discouraged, and grouping by function was preferred.
> 
> This version of the patch addresses various issues raised in the
> community, primarily the absence of sysfs integration.  The sysfs
> integration now handles passing information on sector size, page size,
> and total partition size to userspace as well.  In addition, we now
> use a single "struct cdev" to manage all the partition minor devices,
> and dynamically discover the correct number of partitions from the
> hypervisor rather than using a module_param with a default value.
> 
> This driver has no particular "peer" drivers it can be grouped with.
> It is sort of like an MTD driver for SPI ROM, but it doesn't group well
> with the other MTD devices since it relies on hypervisor virtualization
> to handle many of the irritating aspects of flash ROM management: sector
> awareness, background read for sub-sector writes, bit examination to
> determine whether a sector erase needs to be issued, etc.  It is in fact
> more like an EEPROM driver, but the hypervisor virtualization does require
> a "flush" command if you wish to commit a sector write prior to writing
> to a different sector, and this is sufficiently different from generic
> I2C/SPI EEPROMs that as a result it doesn't group well with them either.
> 
> The simple character device is already in use by a range of Tilera
> SPI ROM management tools, as well as by customers.  In addition, using
> the simple character device actually simplifies the userspace tools,
> since they don't need to manage sector erase, background read, etc.
> This both simplifies the code (since we can uniformly manage plain files
> and the SPI ROM) as well as makes the user code portable to non-Linux
> platforms that don't offer the same MTD ioctls.
> 
> Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>

Reviewed-by: Arnd Bergmann <arnd@arndb.de>
