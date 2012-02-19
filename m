Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754102Ab2BSOIz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 09:08:55 -0500
Received: from www.linutronix.de ([62.245.132.108]:37417 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753188Ab2BSOIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 09:08:54 -0500
Message-ID: <4F41026C.6060203@linutronix.de>
Date: Sun, 19 Feb 2012 15:08:44 +0100
From: Richard Weinberger <rw@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120208 Thunderbird/10.0.1
MIME-Version: 1.0
To: Shmulik Ladkani <shmulik.ladkani@gmail.com>
CC: linux-mtd@lists.infradead.org, tglx@linutronix.de, dedekind1@gmail.com,
        linux-kernel@vger.kernel.org, tim.bird@am.sony.com
Subject: Re: [RFC][PATCH 7/7] MTD: UBI: wire up checkpointing
References: <1329250006-22944-1-git-send-email-rw@linutronix.de> <1329250006-22944-8-git-send-email-rw@linutronix.de> <20120219155741.4c2f0a02@pixies.home.jungo.com>
In-Reply-To: <20120219155741.4c2f0a02@pixies.home.jungo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 19.02.2012 14:57, schrieb Shmulik Ladkani:
> On Tue, 14 Feb 2012 21:06:46 +0100 Richard Weinberger<rw@linutronix.de>  wrote:
>> +#ifdef CONFIG_MTD_UBI_CHECKPOINT
>> +static int attach_by_checkpointing(struct ubi_device *ubi)
>> +{
>> +	int cp_start, err;
>> +	struct ubi_scan_info *si;
>> +
>> +	cp_start = ubi_find_checkpoint(ubi);
>> +	if (cp_start<  0)
>> +		return -ENOENT;
>> +
>> +	si = ubi_read_checkpoint(ubi, cp_start);
>> +	if (IS_ERR(si))
>> +		return PTR_ERR(si);
>> +
>> +	ubi->bad_peb_count = 0;
>> +	ubi->good_peb_count = ubi->peb_count;
>
> Zero reported bad PEBs when checkpointing.
> Seems that checkpointing does not remember number/location of bad PEBs.

Currently checkpointing cares only about used and free PEBs.
Bad PEBs are no longer visible to UBI after recovering from a checkpoint.

> Are we fine with that?

This patch is a RFC. :-)

>> +#ifdef CONFIG_MTD_UBI_CHECKPOINT
>> +	err = attach_by_checkpointing(ubi);
>> +
>> +	if (err) {
>> +		if (err != -ENOENT)
>> +			ubi_msg("falling back to attach by scanning mode!\n");
>> +
>> +		err = attach_by_scanning(ubi);
>> +	}
>
> Code does not fit error message.
> Message states "falling back to scanning" only if "err != -ENOENT".
> However code calls 'attach_by_scanning' regardless 'err'.
> Was it your intention?

Yes.
If recovering from a checkpoint fails the corresponding code prints
a human readable error message in any case.

Thanks,
//richard
