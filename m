Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754390Ab2BSN6A (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 08:58:00 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:39289 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754354Ab2BSN56 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 08:57:58 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of shmulik.ladkani@gmail.com designates 10.180.109.228 as permitted sender) smtp.mail=shmulik.ladkani@gmail.com; dkim=pass header.i=shmulik.ladkani@gmail.com
Date: Sun, 19 Feb 2012 15:57:41 +0200
From: Shmulik Ladkani <shmulik.ladkani@gmail.com>
To: Richard Weinberger <rw@linutronix.de>
Cc: linux-mtd@lists.infradead.org, tglx@linutronix.de, dedekind1@gmail.com,
        linux-kernel@vger.kernel.org, tim.bird@am.sony.com
Subject: Re: [RFC][PATCH 7/7] MTD: UBI: wire up checkpointing
Message-ID: <20120219155741.4c2f0a02@pixies.home.jungo.com>
In-Reply-To: <1329250006-22944-8-git-send-email-rw@linutronix.de>
References: <1329250006-22944-1-git-send-email-rw@linutronix.de>
	<1329250006-22944-8-git-send-email-rw@linutronix.de>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Feb 2012 21:06:46 +0100 Richard Weinberger <rw@linutronix.de> wrote:
> +#ifdef CONFIG_MTD_UBI_CHECKPOINT
> +static int attach_by_checkpointing(struct ubi_device *ubi)
> +{
> +	int cp_start, err;
> +	struct ubi_scan_info *si;
> +
> +	cp_start = ubi_find_checkpoint(ubi);
> +	if (cp_start < 0)
> +		return -ENOENT;
> +
> +	si = ubi_read_checkpoint(ubi, cp_start);
> +	if (IS_ERR(si))
> +		return PTR_ERR(si);
> +
> +	ubi->bad_peb_count = 0;
> +	ubi->good_peb_count = ubi->peb_count;

Zero reported bad PEBs when checkpointing.
Seems that checkpointing does not remember number/location of bad PEBs.
Are we fine with that?

> +#ifdef CONFIG_MTD_UBI_CHECKPOINT
> +	err = attach_by_checkpointing(ubi);
> +
> +	if (err) {
> +		if (err != -ENOENT)
> +			ubi_msg("falling back to attach by scanning mode!\n");
> +
> +		err = attach_by_scanning(ubi);
> +	}

Code does not fit error message.
Message states "falling back to scanning" only if "err != -ENOENT".
However code calls 'attach_by_scanning' regardless 'err'.
Was it your intention?

Regards,
Shmulik
