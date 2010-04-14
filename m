Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752433Ab0DNE6G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 00:58:06 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:47671 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751097Ab0DNE6C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 00:58:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=U1VG32zv+xF15nhKJTpm/OwjR+TOWbQnnuYk8+uTjt90GL3t3+oeKmFojL9dA2pxPT
         qXhZ6M6iUMsbQhV5aC9W/3Sc5+Oa+UPs96yqPl4mlcjs37wlyd36BEFh8y3RXqGUT6Wf
         q8dAg5KQPbxgV8yfHKhOPVAqDRXIzojbUu7MU=
Subject: Re: [PATCH 1/2] MTD: cfi_cmdset_0002: Add reboot notifier for AMD
 flashes
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Kevin Cernekee <cernekee@gmail.com>
Cc: dwmw2@infradead.org, saeed.bishara@gmail.com,
       linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
In-Reply-To: <bb2e763d69a8cc1576fd58fbde424ff5f688c409@localhost.localdomain>
References: <4ccec90e21edfa387822b2cb71c886217c48b4e3@localhost.localdomain>
	 <bb2e763d69a8cc1576fd58fbde424ff5f688c409@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 14 Apr 2010 07:57:58 +0300
Message-Id: <1271221078.2532.5.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-04-13 at 13:30 -0700, Kevin Cernekee wrote:
> +static int cfi_amdstd_reset(struct mtd_info *mtd)
> +{
> +	struct map_info *map = mtd->priv;
> +	struct cfi_private *cfi = map->fldrv_priv;
> +	int i, ret;
> +	struct flchip *chip;
> +
> +	for (i = 0; i < cfi->numchips; i++) {
> +
> +		chip = &cfi->chips[i];
> +
> +		spin_lock(chip->mutex);
> +
> +		ret = get_chip(map, chip, chip->start, FL_SHUTDOWN);
> +		if (!ret) {
> +			map_write(map, CMD(0xF0), chip->start);
> +			chip->state = FL_SHUTDOWN;
> +			put_chip(map, chip, chip->start);
> +		}
> +
> +		spin_unlock(chip->mutex);
> +	}
> +
> +	return 0;
> +}

Kevin, I'd suggest to document why you do this in the code, just for the
next generation, or for the archaeologists who will dig MTD code in the
future. 

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

