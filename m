Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754049Ab1IAHQE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 03:16:04 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:63651 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751418Ab1IAHQB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 03:16:01 -0400
MIME-Version: 1.0
In-Reply-To: <CAMuHMdWSm2bQQpdM1OM=6+17CeNikn9RYm_BpFmEV7jD4sAPig@mail.gmail.com>
References: <1314857640-6623-1-git-send-email-xiyou.wangcong@gmail.com>
	<CAMuHMdWSm2bQQpdM1OM=6+17CeNikn9RYm_BpFmEV7jD4sAPig@mail.gmail.com>
Date: Thu, 1 Sep 2011 15:16:00 +0800
Message-ID: <CAM_iQpULfmXV96AB5L4K78rLfom+9F=sb6FgGSaOywtOzPt6Pg@mail.gmail.com>
Subject: Re: [PATCH] cris: lower the printk level in cris serial driver
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Mikael Starvik <starvik@axis.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        Alan Cox <alan@linux.intel.com>, linux-cris-kernel@axis.com,
        linux-serial@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 1, 2011 at 2:35 PM, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> On Thu, Sep 1, 2011 at 08:14, WANG Cong <xiyou.wangcong@gmail.com> wrote:
>> KERN_CRIT is too high, replace those KERN_CRIT with KERN_ERR or KERN_INFO.
>>
>> Cc: Mikael Starvik <starvik@axis.com>
>> Cc: Jesper Nilsson <jesper.nilsson@axis.com>
>> Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
>>
>> ---
>> diff --git a/drivers/tty/serial/crisv10.c b/drivers/tty/serial/crisv10.c
>> index 225123b..77ba4ed 100644
>> --- a/drivers/tty/serial/crisv10.c
>> +++ b/drivers/tty/serial/crisv10.c
>> @@ -1788,7 +1788,7 @@ static unsigned int handle_descr_data(struct e100_serial *info,
>>        struct etrax_recv_buffer *buffer = phys_to_virt(descr->buf) - sizeof *buffer;
>>
>>        if (info->recv_cnt + recvl > 65536) {
>> -               printk(KERN_CRIT
>> +               printk(KERN_INFO
>>                       "%s: Too much pending incoming serial data! Dropping %u bytes.\n", __func__, recvl);
>>                return 0;
>>        }
>
> I think dropped data warrants KERN_WARN.
>

Yeah, agreed! I will update this patch shortly.

Thanks.
