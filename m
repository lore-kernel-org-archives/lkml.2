Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754931Ab0I3LpU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 07:45:20 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:54355 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753970Ab0I3LpT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 07:45:19 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jonas Bonn <jonas@southpole.se>
Subject: Re: ioremap definition in generic io.h
Date: Thu, 30 Sep 2010 13:45:16 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: Jiri Slaby <jirislaby@gmail.com>, linux-kernel@vger.kernel.org
References: <1285747145.12259.3.camel@needafix> <4CA31AA6.7020003@gmail.com> <1285758446.12259.9.camel@needafix>
In-Reply-To: <1285758446.12259.9.camel@needafix>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201009301345.16817.arnd@arndb.de>
X-Provags-ID: V02:K0:qvHbpLij0OXa2RZZgnD+kKmQbKiUUWm0B2AX8BDrvtm
 VW/lJu48s4xDsHcoiSC3J0R544PvLGdfAdhW8V64DFrX5DLmr+
 61oq+PXbexalA0dShmrPTogtnxcN6buXnJ6oFyKIUXSHQMyXWP
 6GjfiWGRl47YpqeELmX2zsCL56zmoOve+/1xF+w1cEb1P3Q4JR
 4kTnQqf3rBURx2oHSrxzw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 29 September 2010, Jonas Bonn wrote:
> On another note, looking at the definitions of ioread32/iowrite32, they
> imply a little-endian bus.  Some architectures (e.g. Microblaze) define
> these to use host-native byte ordering instead.  Is there a correct
> way these functions should be defined?

ioread32/iowrite32 are accessor functions for PCI byte order which is
little endian. If microblaze does this differently, that is a microblaze
bug. Any code that needs big-endian I/O should use ioread32be/iowrite32be.

	Arnd
