Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754174Ab2BSOkJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 09:40:09 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:46670 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753883Ab2BSOkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 09:40:08 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of shmulik.ladkani@gmail.com designates 10.180.92.227 as permitted sender) smtp.mail=shmulik.ladkani@gmail.com; dkim=pass header.i=shmulik.ladkani@gmail.com
Date: Sun, 19 Feb 2012 16:40:02 +0200
From: Shmulik Ladkani <shmulik.ladkani@gmail.com>
To: Richard Weinberger <rw@linutronix.de>
Cc: linux-mtd@lists.infradead.org, tglx@linutronix.de, dedekind1@gmail.com,
        linux-kernel@vger.kernel.org, tim.bird@am.sony.com
Subject: Re: [RFC][PATCH 7/7] MTD: UBI: wire up checkpointing
Message-ID: <20120219164002.00e76895@pixies.home.jungo.com>
In-Reply-To: <4F41026C.6060203@linutronix.de>
References: <1329250006-22944-1-git-send-email-rw@linutronix.de>
	<1329250006-22944-8-git-send-email-rw@linutronix.de>
	<20120219155741.4c2f0a02@pixies.home.jungo.com>
	<4F41026C.6060203@linutronix.de>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 19 Feb 2012 15:08:44 +0100 Richard Weinberger <rw@linutronix.de> wrote:
> Am 19.02.2012 14:57, schrieb Shmulik Ladkani:
> > On Tue, 14 Feb 2012 21:06:46 +0100 Richard Weinberger<rw@linutronix.de>  wrote:
> >> +#ifdef CONFIG_MTD_UBI_CHECKPOINT
> >> +static int attach_by_checkpointing(struct ubi_device *ubi)
> >> +{
> >> +	int cp_start, err;
> >> +	struct ubi_scan_info *si;
> >> +
> >> +	cp_start = ubi_find_checkpoint(ubi);
> >> +	if (cp_start<  0)
> >> +		return -ENOENT;
> >> +
> >> +	si = ubi_read_checkpoint(ubi, cp_start);
> >> +	if (IS_ERR(si))
> >> +		return PTR_ERR(si);
> >> +
> >> +	ubi->bad_peb_count = 0;
> >> +	ubi->good_peb_count = ubi->peb_count;
> >
> > Zero reported bad PEBs when checkpointing.
> > Seems that checkpointing does not remember number/location of bad PEBs.
> 
> Currently checkpointing cares only about used and free PEBs.
> Bad PEBs are no longer visible to UBI after recovering from a checkpoint.

Ok.
However it is still reported to the log in 'ubi_attach_mtd_dev'
and as a sysfs attribute.
BTW, the counter is still incremented by WL subsystem, though.
Hence, reported value will be bad PEBs encountered since last attach
(where formerly, it was absolute total bad PEBs in the ubi device).
Maybe remove 'bad_peb_count' altogether.

Also, "ubi->good_peb_count = ubi->peb_count" results in different
'beb_rsvd_level' caculation, see 'ubi_calculate_reserved'.

> > Are we fine with that?
> 
> This patch is a RFC. :-)

So I noticed :-) 
Just trying to point out things which cause ubi system to behave
differently.

> Thanks,
> //richard

Wellcome. Will try to review the big stuff later on.

Regards,
Shmulik
