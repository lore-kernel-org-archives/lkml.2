Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935314Ab1ETSrC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 14:47:02 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:59781 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934921Ab1ETSrA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 14:47:00 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Chris Metcalf <cmetcalf@tilera.com>
Subject: Re: [PATCH] arch/tile: add arch/tile/drivers/ directory with SROM driver
Date: Fri, 20 May 2011 20:46:40 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.39-rc4+; KDE/4.5.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@aristanetworks.com>,
        Chris Wright <chrisw@sous-sol.org>,
        "Greg Kroah-Hartman" <gregkh@suse.de>,
        Benjamin Thery <benjamin.thery@bull.net>,
        Phil Carmody <ext-phil.2.carmody@nokia.com>
References: <201105042004.p44K4kZx011721@farm-0032.internal.tilera.com> <201105050841.40576.arnd@arndb.de> <4DD6AD51.7090900@tilera.com>
In-Reply-To: <4DD6AD51.7090900@tilera.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201105202046.40696.arnd@arndb.de>
X-Provags-ID: V02:K0:TNFghazH83GZdG0l9sJzSseOpbU66zTJ6CuNoa+E5aC
 fMFLkU5t8ejZzYhr2tpXCLRl5IThnbbNxP4AnYgA65fRCgA0eO
 beHe3Dog/DZxIe1EuKB3snIXGx0EYLsh3ARiWsxpWYktfs7WpY
 gg0elIL7/Yd3jNwv5ucVx8BnFXF78bVs7fTFDrpy4eOvEDtxS0
 Tnr5bU2OMCwenZAqNyjTA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 20 May 2011 20:05:05 Chris Metcalf wrote:
> This works well, except for the fact that we take advantage of the fact
> that the hypervisor driver internally buffers up writes to the current
> EEPROM sector, and flushes it to hardware only when explicitly told to do
> so, or when we start writing to another sector.  This avoids excessive wear
> on the EEPROM and also handles detection of whether we need to do a sector
> erase before the re-write.  However, it also means that we need to be able
> to issue the final explicit flush, or else the last write just sits in the
> hypervisor buffer indefinitely.  To make that happen I think I need to
> extend the bin_attribute structure, and the bin.c release() function, slightly:

Yes, that would work. Another option would be to add a flush() callback
to the bin_attribute. Since filp_close calls both fops->flush and
fops->release, that would also make it possible to flush the buffer
without closing it, if necessary.

	Arnd
