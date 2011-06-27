Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753716Ab1F0T0U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 15:26:20 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:41661 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753922Ab1F0T0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 15:26:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:date:in-reply-to:references
         :content-type:x-mailer:content-transfer-encoding:message-id
         :mime-version;
        b=G57jhVJJlLbK1sOGtyhaIjh8r6JEA1w5pkRmTRnP+9nX3FC2Fp9gkaeh3g+7F83haq
         YkJ2hziufxfm3HRkH8dhPsJNilLPgNyGjKD7bRgac/jLZuFKe7dBbjbFWYSoi0FF8Zui
         vQwQ/PtRzpeuO9/UdvtLj5uT9Kq2O2y9ovwYM=
Subject: Re: [PATCH] UBI: new module ubiblk: block layer on top of UBI
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: david.wagner@free-electrons.com
Cc: linux-mtd@lists.infradead.org, dwmw2@infradead.org,
        linux-kernel@vger.kernel.org
Date: Mon, 27 Jun 2011 22:26:08 +0300
In-Reply-To: <1308922482-14967-2-git-send-email-david.wagner@free-electrons.com>
References: <1308922482-14967-1-git-send-email-david.wagner@free-electrons.com>
	 <1308922482-14967-2-git-send-email-david.wagner@free-electrons.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.2 (3.0.2-2.fc15) 
Content-Transfer-Encoding: 8bit
Message-ID: <1309202771.24805.11.camel@koala>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-06-24 at 15:34 +0200, david.wagner@free-electrons.com
wrote:
> +	/* Stolen from mtd_blkdevs.c */
> +	/* Create processing thread */
> +	dev->thread = kthread_run(ubi_ubiblk_thread, dev, "%s%d_%d",
> +				  "kubiblkd", dev->ubi_num, dev->vol_id);
> +	if (IS_ERR(dev->thread)) {
> +		ret = PTR_ERR(dev->thread);
> +		goto out_thread;
> +	}

Why we need a kernel thread? Could you please describe when exactly it
is needed and why we cannot avoid having it?

> +	ret = register_blkdev(0, "ubiblk");
> +	if (ret <= 0) {
> +		pr_err("UBIBLK: could not register_blkdev\n");
> +		return -ENODEV;
> +	}
> +	major = ret;
> +	pr_info("UBIBLK: device's major: %d\n", major);
> +
> +	mutex_init(&devtable_lock);
> +	ret = ubi_register_volume_notifier(&ubiblk_notifier, 0);
> +	if (ret < 0)
> +		return ret;

You should probably de-register the blkdev when you fail here.

-- 
Best Regards,
Artem Bityutskiy (Битюцкий Артём)

