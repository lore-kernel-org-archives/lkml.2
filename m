Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756685Ab1ISDKb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Sep 2011 23:10:31 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:48458 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753948Ab1ISDKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Sep 2011 23:10:30 -0400
MIME-Version: 1.0
Date: Mon, 19 Sep 2011 12:10:28 +0900
Message-ID: <CAKYAXd8xd3sCi0CCOH6Y3AR2J2iuDQispCnt0D2mksiAWr=rgw@mail.gmail.com>
Subject: RFC : mmc : boot partition is set as a read-write.
From: NamJae Jeon <linkinjeon@gmail.com>
To: Chris Ball <cjb@laptop.org>, Linus Walleij <linus.ml.walleij@gmail.com>,
        linux-mmc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mmc : boot partition is set as a read-write.

There is a case that user directly update boot partition through mmcblk0boot0,1.
However, the current boot partition is set as a read-only.
I suggest that boot partition is set as a read-write if there is no
reason that it should be read-only.

static int mmc_blk_alloc_parts(struct mmc_card *card, struct mmc_blk_data *md)
{
	int ret = 0;

	if (!mmc_card_mmc(card))
		return 0;

	if (card->ext_csd.boot_size) {
		ret = mmc_blk_alloc_part(card, md, EXT_CSD_PART_CONFIG_ACC_BOOT0,
					 card->ext_csd.boot_size >> 9,
					 false,
					 "boot0");
		if (ret)
			return ret;
		ret = mmc_blk_alloc_part(card, md, EXT_CSD_PART_CONFIG_ACC_BOOT1,
					 card->ext_csd.boot_size >> 9,
					 false,
					 "boot1");
		if (ret)
			return ret;
	}
}

Thanks.
