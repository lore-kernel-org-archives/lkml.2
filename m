Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760166Ab0JGH6w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 03:58:52 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:38698 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753411Ab0JGH6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 03:58:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=Ak83OyOf1wIFEbQx4S7pPWa2SfJDcbvSp4Vfq92VN63mI1D/niM/mlN3UZVbHrbvva
         FTabRMbiRVEAILw6afqnAW3axAZIB88If2jyHSywAJ+xyU/CRnk6X7V9ttMarlhjjoEB
         xWptBamv6aVaiXoQvrw32zE16Soqdm301QTBQ=
Message-ID: <4CAD7DAB.8030209@gmail.com>
Date: Thu, 07 Oct 2010 09:58:35 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.9) Gecko/20100914 SUSE/3.1.4 Thunderbird/3.1.4
MIME-Version: 1.0
To: "Savoy, Pavan" <pavan_savoy@ti.com>
CC: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 1/2] drivers:staging:ti-st: move TI_ST from staging
References: <1286381895-11329-1-git-send-email-pavan_savoy@ti.com> <1286381895-11329-2-git-send-email-pavan_savoy@ti.com> <4CACD234.7020900@gmail.com> <19F8576C6E063C45BE387C64729E739404AA21CEA1@dbde02.ent.ti.com> <4CACF5A7.3010601@gmail.com> <19F8576C6E063C45BE387C64729E739404AA21CEC6@dbde02.ent.ti.com>
In-Reply-To: <19F8576C6E063C45BE387C64729E739404AA21CEC6@dbde02.ent.ti.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/07/2010 12:36 AM, Savoy, Pavan wrote:
>>>>> +int st_core_init(struct st_data_s **core_data)
>>>>> +{
>>>>> +	struct st_data_s *st_gdata;
>>>>> +	long err;
>>>>> +	static struct tty_ldisc_ops *st_ldisc_ops;
>>>>> +
>>>>> +	/* populate and register to TTY line discipline */
>>>>> +	st_ldisc_ops = kzalloc(sizeof(*st_ldisc_ops), GFP_KERNEL);
>>>>> +	if (!st_ldisc_ops) {
>>>>> +		pr_err("no mem to allocate");
>>>>> +		return -ENOMEM;
>>>>> +	}
>>>>> +
>>>>> +	st_ldisc_ops->magic = TTY_LDISC_MAGIC;
>>>>> +	st_ldisc_ops->name = "n_st";	/*"n_hci"; */
>>>>> +	st_ldisc_ops->open = st_tty_open;
>>>>> +	st_ldisc_ops->close = st_tty_close;
>>>>> +	st_ldisc_ops->receive_buf = st_tty_receive;
>>>>> +	st_ldisc_ops->write_wakeup = st_tty_wakeup;
>>>>> +	st_ldisc_ops->flush_buffer = st_tty_flush_buffer;
>>>>> +	st_ldisc_ops->owner = THIS_MODULE;
>>>>
>>>> This can be static structure, you don't need to allocate this on heap.
>>>> It should be a singleton.
>>>
>>> Yes, I got this comment before, but is it just a style issue?
>>> I want to keep this in heap because some day, I hope TTY ldics have their
>> own
>>> private_data, which I can pass around like the tty_struct's data.
>>> and having them in heap, I plan to keep a reference to ops structure, so
>> that I
>>> can pass around and use ops->private_data everywhere ..
>>
>> I doubt ldisc ops will ever have ->private_data. What would you need it
>> for? The ops generally work with ttys which have ->disc_data.
> 
> Yes, But in this case, I required something which can be set during ldisc_register, and can be picked up during tty_open.

Why? ldiscs are per-system, singletons, not per-device. So you should
not bind to them any device specific info.

regards,
-- 
js
