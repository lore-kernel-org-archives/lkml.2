Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755533Ab1EXPjA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 11:39:00 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:59503 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752297Ab1EXPjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 11:39:00 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: virtualization@lists.linux-foundation.org
Subject: Re: [PATCH] arch/tile: add /proc/tile, /proc/sys/tile, and a sysfs cpu attribute
Date: Tue, 24 May 2011 17:38:51 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: Chris Metcalf <cmetcalf@tilera.com>, linux-kernel@vger.kernel.org
References: <201105181807.p4II7C5g015224@farm-0002.internal.tilera.com> <4DD5334D.4060800@tilera.com> <201105191722.17685.arnd@arndb.de>
In-Reply-To: <201105191722.17685.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105241738.52146.arnd@arndb.de>
X-Provags-ID: V02:K0:ajJGKX/m9G6h4iihobvA4zRUEY1I0Ijm8J5AsnoiKKT
 Ac74tAQ0KfhygqLrgK7gbGBwy12koSmMTpTwvSfyyii7mZYleP
 qQDsctHQ6LZ+oNHIJ/hmxctKZ4lDBRRa+WcwDyYIjjzDc3GwOK
 L2AyeEKrpne0scZaKsv1phHcwZHDaU4OR+dj6ZZtPk6tzqkJnj
 1Oo1spRnKVr69ROzRhD3g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 19 May 2011, Arnd Bergmann wrote:
> > 
> > # cat /proc/tile/board
> > board_part: 402-00002-05
> > board_serial: NBS-5002-00012
> > chip_serial: P62338.01.110
> > chip_revision: A0
> > board_revision: 2.2
> > board_description: Tilera TILExpressPro-64, TILEPro64 processor (866 MHz-capable), 1 10GbE, 6 1GbE
> > # cat /proc/tile/switch
> > control: mdio gbe/0
> 
> I think it's ok to have it below /sys/hypervisor, because the information
> is provided through a hypervisor ABI, even though it describes something
> else. This is more like /sys/firmware, but the boundaries between that
> and /sys/hypervisor are not clearly defined when running virtualized anyway.

A minor point that I meant to bring up but had not gotten to:

When you do a /sys/hypervisor/ interface, put everything into a subdirectory
under /sys/hypervisor with the name of your hypervisor, to avoid naming
conflicts, e.g.

/sys/hypervisor/tilera-hv/board/board_serial

	Arnd
