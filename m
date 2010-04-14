Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753142Ab0DNFdb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 01:33:31 -0400
Received: from aa012msr.fastwebnet.it ([85.18.95.72]:55649 "EHLO
	aa012msr.fastwebnet.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751097Ab0DNFda convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 01:33:30 -0400
From: Fabio Giovagnini <fabio.giovagnini@aurion-tech.com>
Organization: Auiron s.r.l.
To: linux-mtd@lists.infradead.org, dedekind1@gmail.com
Subject: Re: [PATCH 1/2] MTD: cfi_cmdset_0002: Add reboot notifier for AMD flashes
Date: Wed, 14 Apr 2010 07:33:12 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-20-generic; KDE/4.3.2; i686; ; )
Cc: Kevin Cernekee <cernekee@gmail.com>, saeed.bishara@gmail.com,
       dwmw2@infradead.org, linux-kernel@vger.kernel.org
References: <4ccec90e21edfa387822b2cb71c886217c48b4e3@localhost.localdomain> <bb2e763d69a8cc1576fd58fbde424ff5f688c409@localhost.localdomain> <1271221078.2532.5.camel@localhost.localdomain>
In-Reply-To: <1271221078.2532.5.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201004140733.12708.fabio.giovagnini@aurion-tech.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Exactly!!!!
Why this is requested?
Is it necessary for the best proper woring mode?

Thanks a lot


In data mercoledì 14 aprile 2010 06:57:58, Artem Bityutskiy ha scritto:
: > On Tue, 2010-04-13 at 13:30 -0700, Kevin Cernekee wrote:
> > +static int cfi_amdstd_reset(struct mtd_info *mtd)
> > +{
> > +	struct map_info *map = mtd->priv;
> > +	struct cfi_private *cfi = map->fldrv_priv;
> > +	int i, ret;
> > +	struct flchip *chip;
> > +
> > +	for (i = 0; i < cfi->numchips; i++) {
> > +
> > +		chip = &cfi->chips[i];
> > +
> > +		spin_lock(chip->mutex);
> > +
> > +		ret = get_chip(map, chip, chip->start, FL_SHUTDOWN);
> > +		if (!ret) {
> > +			map_write(map, CMD(0xF0), chip->start);
> > +			chip->state = FL_SHUTDOWN;
> > +			put_chip(map, chip, chip->start);
> > +		}
> > +
> > +		spin_unlock(chip->mutex);
> > +	}
> > +
> > +	return 0;
> > +}
> 
> Kevin, I'd suggest to document why you do this in the code, just for the
> next generation, or for the archaeologists who will dig MTD code in the
> future.
> 

-- 
Fabio Giovagnini

Aurion s.r.l.
P.I e C.F.
00885711200
Tel. +39.051.594.78.24
Cell. +39.335.83.50.919
